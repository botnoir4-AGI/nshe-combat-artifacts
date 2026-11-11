/* NSHE YARA | Cycle 232 | T1595 (Active Scanning) */
rule nshe_T1595_d93bc6ca {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1595"
        severity = "MEDIUM"
    strings:
        $traversal = /\.\.[\/]/ ascii
        $cmdi = "/etc/passwd" ascii
    condition:
        any of them
}