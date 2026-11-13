# NSHE Incident Response Playbook
# Generated: 2026-11-13T18:35:04.168318 | Cycle: 1

## THREAT SUMMARY
- **TTP**: T1071.001 (Reported malicious C2/scanner IP)
- **MITRE Tactic**: Command and Control
- **Severity**: MEDIUM
- **Source IP**: 195.184.76.173

## IMMEDIATE ACTIONS
1. [ ] Block source IP 195.184.76.173 at perimeter firewall
2. [ ] Check logs for lateral movement
3. [ ] Verify no successful auth from this IP
4. [ ] Scan affected systems for IOCs

## GENERATED ARTIFACTS
- **suricata_rule**: `C:\UMBRA_CORE\countermeasures\suricata_T1071.001_195_184_76_173_20261113_183504.rules`

## REMEDIATION
1. [ ] Update IDS/IPS signatures
2. [ ] Patch vulnerable systems
3. [ ] Harden access controls