# NSHE Incident Response Playbook
# Generated: 2026-11-15T14:55:34.502959 | Cycle: 79

## THREAT SUMMARY
- **TTP**: T1071.001 (Reported malicious C2/scanner IP)
- **MITRE Tactic**: Command and Control
- **Severity**: MEDIUM
- **Source IP**: 91.196.152.210

## IMMEDIATE ACTIONS
1. [ ] Block source IP 91.196.152.210 at perimeter firewall
2. [ ] Check logs for lateral movement
3. [ ] Verify no successful auth from this IP
4. [ ] Scan affected systems for IOCs

## GENERATED ARTIFACTS
- **suricata_rule**: `C:\UMBRA_CORE\countermeasures\suricata_T1071.001_91_196_152_210_20261115_145534.rules`

## REMEDIATION
1. [ ] Update IDS/IPS signatures
2. [ ] Patch vulnerable systems
3. [ ] Harden access controls