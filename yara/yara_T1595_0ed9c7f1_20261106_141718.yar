/* NSHE YARA | Cycle 27 | T1595 (Active Scanning) */
rule nshe_T1595_0ed9c7f1 {
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