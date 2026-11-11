/* NSHE YARA | Cycle 94 | T1595 (Active Scanning) */
rule nshe_T1595_6f4b79fc {
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