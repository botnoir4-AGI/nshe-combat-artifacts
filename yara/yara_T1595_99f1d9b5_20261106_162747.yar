/* NSHE YARA | Cycle 60 | T1595 (Active Scanning) */
rule nshe_T1595_99f1d9b5 {
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