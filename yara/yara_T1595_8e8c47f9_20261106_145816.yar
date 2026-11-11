/* NSHE YARA | Cycle 37 | T1595 (Active Scanning) */
rule nshe_T1595_8e8c47f9 {
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