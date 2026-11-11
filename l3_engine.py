"""L3 ENGINE v4: Autonomous Execution via Git Data API (atomic batch commit)."""
import json, hashlib, urllib.request, base64, os, re
from pathlib import Path
from datetime import datetime

BRAIN = Path("C:/UMBRA_CORE/SISF/brain")
CM = Path("C:/UMBRA_CORE/countermeasures")
REPO = "botnoir4-AGI/nshe-combat-artifacts"

def _get_pat():
    cp = BRAIN / "github_config.json"
    if cp.exists():
        try: return json.loads(cp.read_text(encoding="utf-8")).get("pat","")
        except: pass
    return os.environ.get("GITHUB_PAT","")

PAT = _get_pat()
API = "https://api.github.com/repos/" + REPO
HDRS = {"Authorization":"token "+PAT, "User-Agent":"NSHE-L3", "Accept":"application/vnd.github.v3+json"}

def _req(method, url, payload=None):
    h = dict(HDRS); data = None
    if payload is not None:
        h["Content-Type"]="application/json"; data=json.dumps(payload).encode()
    rq = urllib.request.Request(url, data=data, headers=h, method=method)
    with urllib.request.urlopen(rq, timeout=25) as r:
        return json.loads(r.read().decode())

def _load(p, d=None):
    if d is None: d={}
    try:
        if p.exists(): return json.loads(p.read_text(encoding="utf-8"))
    except: pass
    return d

def _save(p, d):
    try:
        for k in ["executions"]:
            if k in d and isinstance(d[k],list): d[k]=d[k][-500:]
        p.write_text(json.dumps(d,indent=2),encoding="utf-8")
    except Exception as e: print("[L3] Save err:",e)

SECRETS=[(re.compile(r"ghp_[A-Za-z0-9]{36}"),"[REDACTED_GH_PAT]"),
 (re.compile(r"github_pat_[A-Za-z0-9_]{20,}"),"[REDACTED_GH_PAT]"),
 (re.compile(r"AKIA[0-9A-Z]{16}"),"[REDACTED_AWS_KEY]"),
 (re.compile(r"sk-live-[A-Za-z0-9]+"),"[REDACTED_API_KEY]"),
 (re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),"[REDACTED_PRIVATE_KEY]")]
def sanitize(b):
    t=b.decode("utf-8",errors="replace")
    for pat,repl in SECRETS: t=pat.sub(repl,t)
    return t.encode("utf-8")

def batch_commit(files,msg):
    if not PAT: print("[L3] No PAT"); return False
    try:
        ref=_req("GET",API+"/git/ref/heads/main"); cs=ref["object"]["sha"]
        commit=_req("GET",API+"/git/commits/"+cs); bt=commit["tree"]["sha"]
        entries=[]
        for gp,content in files:
            blob=_req("POST",API+"/git/blobs",{"content":base64.b64encode(content).decode(),"encoding":"base64"})
            entries.append({"path":gp,"mode":"100644","type":"blob","sha":blob["sha"]})
        if not entries: return True
        tree=_req("POST",API+"/git/trees",{"base_tree":bt,"tree":entries})
        nc=_req("POST",API+"/git/commits",{"message":msg,"tree":tree["sha"],"parents":[cs]})
        _req("PATCH",API+"/git/refs/heads/main",{"sha":nc["sha"]})
        return True
    except urllib.error.HTTPError as e:
        body=""
        try: body=e.read().decode()[:150]
        except: pass
        print("[L3] GitAPI err:",e.code,body); return False
    except Exception as e:
        print("[L3] GitAPI fail:",str(e)[:80]); return False

def execute_approved(cycle_count):
    state=_load(BRAIN/"l3_state.json",{"total_executed":0,"total_published":0,"suricata":0,"yara":0,"playbooks":0,"firewall":0,"last_cycle":0})
    exec_log=_load(BRAIN/"l3_executed.json",{"executions":[]})
    done=set(e["hash"] for e in exec_log.get("executions",[]))
    batch=[]; meta=[]
    for qdir in [CM/"deploy_queue",CM/"approved"]:
        if not qdir.exists(): continue
        for f in sorted(qdir.glob("*")):
            if f.is_dir() or f.name==".gitkeep" or f.name.endswith("_meta.json"): continue
            fh=hashlib.sha256(f.read_bytes()).hexdigest()[:16]
            if fh in done: continue
            nm=f.name.lower()
            if "suricata" in nm or nm.endswith(".rules"): at="suricata";gd="suricata";state["suricata"]+=1
            elif "yara" in nm or nm.endswith(".yar"): at="yara";gd="yara";state["yara"]+=1
            elif "playbook" in nm or nm.endswith(".md"): at="playbook";gd="playbooks";state["playbooks"]+=1
            elif "firewall" in nm or nm.endswith(".sh") or nm.endswith(".ps1"): at="firewall";gd="firewall";state["firewall"]+=1
            else: at="misc";gd="misc"
            batch.append((gd+"/"+f.name,sanitize(f.read_bytes())))
            meta.append({"hash":fh,"file":f.name,"type":at,"cycle":cycle_count,"ts":datetime.now().isoformat()})
            done.add(fh)
    if not batch: return []
    ok=batch_commit(batch,"[L3] Autonomous defense artifacts cycle="+str(cycle_count))
    results=[]
    for (gp,content),m in zip(batch,meta):
        if ok: state["total_published"]+=1
        state["total_executed"]+=1
        m["published"]=ok; exec_log["executions"].append(m)
        results.append({"file":m["file"],"type":m["type"],"published":ok})
    state["last_cycle"]=cycle_count
    _save(BRAIN/"l3_state.json",state); _save(BRAIN/"l3_executed.json",exec_log)
    l2=_load(BRAIN/"l2_state.json",{"true_positives":0})
    if ok: l2["true_positives"]=l2.get("true_positives",0)+len(results)
    _save(BRAIN/"l2_state.json",l2)
    pub=sum(1 for r in results if r["published"])
    print("[L3] Executed "+str(len(results))+" artifacts ("+str(pub)+" published, cycle "+str(cycle_count)+")")
    for r in results[:5]:
        print("  -> "+r["file"]+" ("+r["type"]+") "+("PUBLISHED" if r["published"] else "FAILED"))
    return results

def get_status():
    return _load(BRAIN/"l3_state.json",{"total_executed":0,"total_published":0})
