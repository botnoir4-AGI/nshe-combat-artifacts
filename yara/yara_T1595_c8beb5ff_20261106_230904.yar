/* NSHE YARA | Cycle 160 | T1595 (Active Scanning) */
rule nshe_T1595_c8beb5ff {
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