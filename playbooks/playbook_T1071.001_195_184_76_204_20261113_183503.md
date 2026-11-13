# NSHE Incident Response Playbook
# Generated: 2026-11-13T18:35:03.894727 | Cycle: 1

## THREAT SUMMARY
- **TTP**: T1071.001 (Reported malicious C2/scanner IP)
- **MITRE Tactic**: Command and Control
- **Severity**: MEDIUM
- **Source IP**: 195.184.76.204

## IMMEDIATE ACTIONS
1. [ ] Block source IP 195.184.76.204 at perimeter firewall
2. [ ] Check logs for lateral movement
3. [ ] Verify no successful auth from this IP
4. [ ] Scan affected systems for IOCs

## GENERATED ARTIFACTS
- **suricata_rule**: `C:\UMBRA_CORE\countermeasures\suricata_T1071.001_195_184_76_204_20261113_183503.rules`

## REMEDIATION
1. [ ] Update IDS/IPS signatures
2. [ ] Patch vulnerable systems
3. [ ] Harden access controls