/* NSHE YARA | Cycle 207 | T1595 (Active Scanning) */
rule nshe_T1595_c8b2b0cd {
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