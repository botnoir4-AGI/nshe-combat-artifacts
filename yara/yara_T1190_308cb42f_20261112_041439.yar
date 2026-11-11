/* NSHE YARA | Cycle 8 | T1190 (Exploit Public-Facing Application) */
rule nshe_T1190_308cb42f {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1190"
        severity = "MEDIUM"
    strings:
        $sqli = /(?i)(union\s+select|or\s+1\s*=\s*1)/ ascii wide
    condition:
        any of them
}