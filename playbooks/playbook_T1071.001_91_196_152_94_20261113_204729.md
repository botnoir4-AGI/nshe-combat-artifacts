# NSHE Incident Response Playbook
# Generated: 2026-11-13T20:47:29.295250 | Cycle: 7

## THREAT SUMMARY
- **TTP**: T1071.001 (Reported malicious C2/scanner IP)
- **MITRE Tactic**: Command and Control
- **Severity**: MEDIUM
- **Source IP**: 91.196.152.94

## IMMEDIATE ACTIONS
1. [ ] Block source IP 91.196.152.94 at perimeter firewall
2. [ ] Check logs for lateral movement
3. [ ] Verify no successful auth from this IP
4. [ ] Scan affected systems for IOCs

## GENERATED ARTIFACTS
- **suricata_rule**: `C:\UMBRA_CORE\countermeasures\suricata_T1071.001_91_196_152_94_20261113_204729.rules`

## REMEDIATION
1. [ ] Update IDS/IPS signatures
2. [ ] Patch vulnerable systems
3. [ ] Harden access controls