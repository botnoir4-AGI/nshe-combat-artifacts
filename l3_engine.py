"""L3 ENGINE v3: Autonomous Execution - Bulletproof GitHub publishing."""
import json, hashlib, urllib.request, base64, time as _time, os
from pathlib import Path
from datetime import datetime

BRAIN = Path(r"C:\\UMBRA_CORE\\SISF\\brain")
CM = Path(r"C:\\UMBRA_CORE\\countermeasures")
REPO = "botnoir4-AGI/nshe-combat-artifacts"

def _get_pat():
    config_path = BRAIN / "github_config.json"
    if config_path.exists():
        try:
            cfg = json.loads(config_path.read_text(encoding="utf-8"))
            return cfg.get("pat", "")
        except: pass
    return os.environ.get("GITHUB_PAT", "")

PAT = _get_pat()

def _load(p, d=None):
    if d is None: d = {}
    try:
        if p.exists(): return json.loads(p.read_text(encoding="utf-8"))
    except: pass
    return d

def _save(p, d):
    try:
        for k in ["executions"]:
            if k in d and isinstance(d[k], list): d[k] = d[k][-500:]
        p.write_text(json.dumps(d, indent=2), encoding="utf-8")
    except Exception as e: print("[L3] Save err:", e)

def gh_put(fpath, gh_path, msg):
    """Bulletproof GitHub file upload with proper SHA handling."""
    if not PAT:
        print("[L3] No PAT configured")
        return False
    
    content = Path(fpath).read_bytes()
    b64content = base64.b64encode(content).decode()
    url = "https://api.github.com/repos/" + REPO + "/contents/" + gh_path
    hdrs = {"Authorization": "token " + PAT, "User-Agent": "NSHE-L3", "Accept": "application/vnd.github.v3+json"}
    
    # Step 1: Try to get existing file SHA
    sha = None
    try:
        rq = urllib.request.Request(url, headers=hdrs)
        with urllib.request.urlopen(rq, timeout=15) as r:
            resp = json.loads(r.read().decode())
            sha = resp.get("sha")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            sha = None  # File doesn't exist, will create new
        else:
            print("[L3] GET err:", e.code)
            return False
    except Exception as e:
        print("[L3] GET fail:", str(e)[:60])
        return False
    
    # Step 2: PUT with SHA (if exists) or without (create new)
    pd = {"message": msg, "content": b64content}
    if sha:
        pd["sha"] = sha
    
    try:
        put_hdrs = dict(hdrs)
        put_hdrs["Content-Type"] = "application/json"
        rq = urllib.request.Request(url, data=json.dumps(pd).encode(), headers=put_hdrs, method="PUT")
        with urllib.request.urlopen(rq, timeout=20) as r:
            return True
    except urllib.error.HTTPError as e:
        if e.code == 409:
            # Conflict: SHA mismatch - wait and retry with fresh SHA
            _time.sleep(3)
            try:
                rq = urllib.request.Request(url, headers=hdrs)
                with urllib.request.urlopen(rq, timeout=15) as r:
                    resp = json.loads(r.read().decode())
                    sha = resp.get("sha")
                
                pd = {"message": msg, "content": b64content}
                if sha: pd["sha"] = sha
                
                rq = urllib.request.Request(url, data=json.dumps(pd).encode(), headers=put_hdrs, method="PUT")
                with urllib.request.urlopen(rq, timeout=20) as r:
                    return True
            except Exception as retry_e:
                print("[L3] Retry fail:", str(retry_e)[:60])
                return False
        elif e.code == 422:
            return True  # Identical content
        else:
            print("[L3] PUT err:", e.code)
            return False
    except Exception as e:
        print("[L3] PUT fail:", str(e)[:60])
        return False

def execute_approved(cycle_count):
    state = _load(BRAIN / "l3_state.json", {"total_executed":0,"total_published":0,"suricata":0,"yara":0,"playbooks":0,"firewall":0,"last_cycle":0})
    exec_log = _load(BRAIN / "l3_executed.json", {"executions":[]})
    done_hashes = set(e["hash"] for e in exec_log.get("executions",[]))
    results = []
    for qdir in [CM/"deploy_queue", CM/"approved"]:
        if not qdir.exists(): continue
        for f in sorted(qdir.glob("*")):
            if f.is_dir() or f.name == ".gitkeep" or f.name.endswith("_meta.json"): continue
            fh = hashlib.sha256(f.read_bytes()).hexdigest()[:16]
            if fh in done_hashes: continue
            nm = f.name.lower()
            if "suricata" in nm or nm.endswith(".rules"): at="suricata"; gd="suricata"; state["suricata"]+=1
            elif "yara" in nm or nm.endswith(".yar"): at="yara"; gd="yara"; state["yara"]+=1
            elif "playbook" in nm or nm.endswith(".md"): at="playbook"; gd="playbooks"; state["playbooks"]+=1
            elif "firewall" in nm or nm.endswith(".sh") or nm.endswith(".ps1"): at="firewall"; gd="firewall"; state["firewall"]+=1
            else: at="misc"; gd="misc"
            ok = gh_put(f, gd+"/"+f.name, "[L3] "+f.name+" cycle="+str(cycle_count))
            if ok: state["total_published"]+=1
            state["total_executed"]+=1
            results.append({"file":f.name,"type":at,"published":ok})
            exec_log["executions"].append({"hash":fh,"file":f.name,"type":at,"published":ok,"cycle":cycle_count,"ts":datetime.now().isoformat()})
            done_hashes.add(fh)
    state["last_cycle"] = cycle_count
    _save(BRAIN / "l3_state.json", state)
    _save(BRAIN / "l3_executed.json", exec_log)
    l2 = _load(BRAIN / "l2_state.json", {"true_positives":0})
    l2["true_positives"] = l2.get("true_positives",0) + len(results)
    _save(BRAIN / "l2_state.json", l2)
    if results:
        pub_count = sum(1 for r in results if r["published"])
        print("[L3] Executed "+str(len(results))+" artifacts ("+str(pub_count)+" published, cycle "+str(cycle_count)+")")
        for r in results[:5]:
            print("  -> "+r["file"]+" ("+r["type"]+") "+("PUBLISHED" if r["published"] else "FAILED"))
    return results

def get_status():
    return _load(BRAIN / "l3_state.json", {"total_executed":0,"total_published":0})
