/* NSHE YARA | Cycle 64 | T1595 (Active Scanning) */
rule nshe_T1595_fa595eef {
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