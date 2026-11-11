"""PRECISION YARA v2: tight hex indicators; dedup; per-payload TP/FP."""
import json, hashlib
from pathlib import Path
BRAIN = Path("C:/UMBRA_CORE/SISF/brain")
CM = Path("C:/UMBRA_CORE/countermeasures")
CURATED = CM / "curated_yara"
NL = chr(10)
Q = chr(34)
def _load(p,d=None):
    if d is None:d={}
    try:
        if p.exists():return json.loads(p.read_text(encoding="utf-8"))
    except:pass
    return d
def defeat_log():
    return _load(BRAIN/"combat_record.json",{}).get("defeat_log",[])
def extract_indicators(payload):
    inds=[];p=payload.strip();low=p.lower()
    if not p:return inds
    if low.startswith("failed password for"):
        pref="Failed password for invalid user " if "invalid user" in low else "Failed password for "
        inds.append(pref.encode())
    parts=p.split()
    for i,tok in enumerate(parts):
        if tok in ("GET","POST","PUT","HEAD") and i+1<len(parts):
            path=parts[i+1].split("?")[0]
            if path.startswith("/") and len(path)>=3:inds.append(path.encode())
    for tok in ["union select","<script","../","/etc/passwd","cmd.exe","powershell -","${jndi:"]:
        if tok in low:inds.append(tok.encode())
    inds.append(p[:64].encode())
    return inds
def generate_curated():
    CURATED.mkdir(parents=True,exist_ok=True)
    for f in CURATED.glob("*.yar"):
        try:f.unlink()
        except:pass
    seen=set();n=0
    for e in defeat_log():
        ttp=e.get("ttp_id","T0000")
        for raw in extract_indicators(e.get("payload_preview","") or ""):
            if len(raw)<4:continue
            key=(ttp,raw)
            if key in seen:continue
            seen.add(key)
            hexs=" ".join("%02x"%b for b in raw)
            name="nshe_"+ttp.replace(".","_")+"_"+hashlib.md5(raw).hexdigest()[:8]
            rule="rule "+name+" {"+NL+"  meta:"+NL+"    ttp = "+Q+ttp+Q+NL+"  strings:"+NL+"    $a = { "+hexs+" }"+NL+"  condition:"+NL+"    $a"+NL+"}"+NL
            (CURATED/(name+".yar")).write_text(rule,encoding="utf-8")
            n+=1
    return n
def measure():
    try:import yara
    except Exception:return {"available":False,"tp":0,"fp":0,"precision":0.0,"rules":0,"corpus":0}
    corpus=[]
    for e in defeat_log():
        t=e.get("payload_preview","")
        if t:corpus.append((e.get("ttp_id",""),t.encode("utf-8",errors="replace")))
    rules=[]
    for yar in sorted(CURATED.glob("*.yar")):
        parts=yar.stem.split("_")
        rt=parts[1] if len(parts)>1 else ""
        if len(parts)>2 and parts[2].isdigit():rt=rt+"."+parts[2]
        try:rules.append((rt,yara.compile(filepath=str(yar))))
        except Exception:continue
    tp=fp=fn=0
    for label,data in corpus:
        base=label.split(".")[0];same=cross=False
        for rt,comp in rules:
            try:hits=comp.match(data=data)
            except Exception:continue
            if hits:
                if rt and rt.split(".")[0]==base:same=True
                else:cross=True
        if same:tp+=1
        elif cross:fp+=1
        else:fn+=1
    prec=tp/(tp+fp) if (tp+fp) else 0.0
    return {"available":True,"tp":tp,"fp":fp,"fn":fn,"precision":round(prec,3),"rules":len(rules),"corpus":len(corpus)}
if __name__=="__main__":
    print("curated rules:",generate_curated())
    print(json.dumps(measure()))
