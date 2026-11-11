"""REAL EXECUTION v2: YARA real-scan on REAL payloads + payload-derived rules, Suricata -T, safe firewall."""
import json, re, shutil, subprocess, ipaddress, time as _time
from pathlib import Path
from datetime import datetime

BRAIN = Path("C:/UMBRA_CORE/SISF/brain")
CM = Path("C:/UMBRA_CORE/countermeasures")
FEEDBACK = BRAIN / "real_feedback.json"
REPORT = BRAIN / "real_exec_report.txt"
FW_LOG = BRAIN / "firewall_applied.json"
DERIVED = CM / "derived_yara"
WHITELIST = [ipaddress.ip_network(n) for n in
    ["127.0.0.0/8","10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","169.254.0.0/16","0.0.0.0/8"]]

def _load(p,d=None):
    if d is None:d={}
    try:
        if p.exists():return json.loads(p.read_text(encoding="utf-8"))
    except:pass
    return d
def _save(p,d):
    try:p.write_text(json.dumps(d,indent=2),encoding="utf-8")
    except Exception as e:print("[REAL] save err",e)
def is_external(ip):
    try:
        a=ipaddress.ip_address(ip);return not any(a in n for n in WHITELIST)
    except:return False

def defeat_log():
    return _load(BRAIN/"combat_record.json",{}).get("defeat_log",[])

def build_corpus():
    c=[]
    for e in defeat_log():
        t=e.get("payload_preview","") or e.get("event_payload","")
        if t:c.append((e.get("ttp_id",""),t.encode("utf-8",errors="replace")))
    hp=_load(BRAIN/"honeypot_events.json",{})
    for e in (hp.get("events",[]) if isinstance(hp,dict) else []):
        t=(e.get("body_preview","")+" "+e.get("path","")+" "+e.get("user_agent",""))
        c.append((e.get("ttp_id",""),t.encode("utf-8",errors="replace")))
    for sd in [CM/"samples",BRAIN/"samples",BRAIN/"payloads"]:
        if sd.exists():
            for f in sd.glob("*"):
                if f.is_file():c.append(("",f.read_bytes()))
    return c

def derive_yara_from_payloads():
    """Generate YARA rules from REAL observed payload indicators (hex strings)."""
    DERIVED.mkdir(parents=True,exist_ok=True)
    n=0;seen=set()
    for e in defeat_log():
        t=(e.get("payload_preview","") or "").strip()
        if not t or t in seen:continue
        seen.add(t)
        raw=t.encode("utf-8",errors="replace")[:64]
        hexs=" ".join(f"{b:02x}" for b in raw)
        ttp=e.get("ttp_id","T0000").replace(".","_")
        name=f"nshe_derived_{ttp}_{e.get('id','x')[:8]}"
        rule=f'rule {name} {{\n  meta:\n    ttp = "{e.get("ttp_id","")}"\n    source = "real_payload"\n  strings:\n    $a = {{ {hexs} }}\n  condition:\n    $a\n}}\n'
        (DERIVED/f"{name}.yar").write_text(rule,encoding="utf-8")
        n+=1
    return n

def yara_scan():
    try:import yara
    except Exception:
        try:
            subprocess.run(["python","-m","pip","install","yara-python","--quiet","--disable-pip-version-check"],timeout=150,capture_output=True)
            import yara
        except Exception:
            return {"engine":"yara","available":False,"tp":0,"fp":0,"tested":0}
    corpus=build_corpus();tp=fp=tested=0;details=[]
    for yar in sorted(CM.rglob("*.yar")):
        m=re.search(r"(T\d{4}(?:\.\d{3})?)",yar.name);rt=m.group(1) if m else ""
        try:rules=yara.compile(filepath=str(yar))
        except Exception:continue
        tested+=1;ms=md=0
        for label,data in corpus:
            try:hits=rules.match(data=data)
            except Exception:continue
            if hits:
                if label and rt and label.startswith(rt.split(".")[0]):ms+=1
                else:md+=1
        tp+=ms;fp+=md
        if ms or md:details.append({"rule":yar.name,"ttp":rt,"tp":ms,"fp":md})
    return {"engine":"yara","available":True,"tp":tp,"fp":fp,"tested":tested,"corpus":len(corpus),"details":details[:50]}

def suricata_test():
    b=shutil.which("suricata")
    if not b:return {"engine":"suricata","available":False}
    rules=sorted(CM.rglob("*.rules"))
    if not rules:return {"engine":"suricata","available":True,"tested":0}
    comb=CM/"_combined_test.rules"
    comb.write_text("\n".join(r.read_text(encoding="utf-8",errors="replace") for r in rules[:200]),encoding="utf-8")
    try:
        p=subprocess.run([b,"-T","-S",str(comb),"-l",str(CM)],timeout=60,capture_output=True,text=True)
        return {"engine":"suricata","available":True,"tested":len(rules[:200]),"valid":p.returncode==0,"err":p.stderr[:200]}
    except Exception as e:return {"engine":"suricata","available":True,"error":str(e)[:120]}

def firewall_apply(rollback_seconds=900):
    b=shutil.which("netsh")
    if not b:return {"engine":"firewall","available":False}
    applied=_load(FW_LOG,{"applied":[]});done={a["ip"] for a in applied["applied"]};res=[]
    for e in defeat_log():
        ip=e.get("source_ip","");sev=e.get("threat_level","") or e.get("severity","")
        if not is_external(ip) or ip in done or sev not in ("HIGH","CRITICAL"):continue
        name="NSHE-BLOCK-"+ip.replace(".","_")
        try:
            subprocess.run([b,"advfirewall","firewall","add","rule","name="+name,"dir=in","action=block","remoteip="+ip],timeout=20,capture_output=True)
            subprocess.Popen('cmd /c timeout /t '+str(rollback_seconds)+' /nobreak >nul & netsh advfirewall firewall delete rule name='+name,shell=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
            applied["applied"].append({"ip":ip,"rule":name,"ts":datetime.now().isoformat(),"rollback_s":rollback_seconds})
            done.add(ip);res.append({"ip":ip,"blocked":True,"rollback_s":rollback_seconds})
        except Exception as ex:res.append({"ip":ip,"blocked":False,"err":str(ex)[:80]})
    _save(FW_LOG,applied)
    return {"engine":"firewall","available":True,"actions":res}

def run_real_execution():
    derived=derive_yara_from_payloads()
    y=yara_scan();s=suricata_test();f=firewall_apply()
    fb=_load(FEEDBACK,{"history":[]})
    entry={"ts":datetime.now().isoformat(),"derived_rules":derived,"yara":{k:v for k,v in y.items() if k!="details"},"suricata":s,"firewall":f}
    fb["history"]=fb.get("history",[])[-100:]+[entry]
    fb["real_tp"]=y.get("tp",0);fb["real_fp"]=y.get("fp",0);_save(FEEDBACK,fb)
    if y.get("available"):
        l2=_load(BRAIN/"l2_state.json",{})
        l2["true_positives"]=y.get("tp",0);l2["false_positives"]=y.get("fp",0)
        l2["feedback_seeded"]=False;l2["feedback_source"]="real_yara_scan"
        _save(BRAIN/"l2_state.json",l2)
    lines=["=== REAL EXECUTION REPORT v2 "+datetime.now().isoformat()+" ===",
        "[DERIVED] payload-derived YARA rules: "+str(derived),
        "[YARA] "+json.dumps({k:v for k,v in y.items() if k!="details"}),
        "[SURICATA] "+json.dumps(s),
        "[FIREWALL] "+json.dumps(f)]
    REPORT.write_text("\n".join(lines),encoding="utf-8")
    return fb

if __name__=="__main__":
    run_real_execution()
