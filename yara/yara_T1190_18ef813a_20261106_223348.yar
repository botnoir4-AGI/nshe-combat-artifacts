/* NSHE YARA | Cycle 151 | T1190 (Exploit Public-Facing Application) */
rule nshe_T1190_18ef813a {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1190"
        severity = "MEDIUM"
    strings:
        $sqli = /(?i)(union\s+select|or\s+1\s*=\s*1)/ ascii wide
    condition:
        any of them
}