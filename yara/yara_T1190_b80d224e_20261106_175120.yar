/* NSHE YARA | Cycle 81 | T1190 (Exploit Public-Facing Application) */
rule nshe_T1190_b80d224e {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1190"
        severity = "MEDIUM"
    strings:
        $sqli = /(?i)(union\s+select|or\s+1\s*=\s*1)/ ascii wide
    condition:
        any of them
}