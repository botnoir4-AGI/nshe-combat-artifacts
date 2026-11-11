/* NSHE YARA | Cycle 156 | T1595 (Active Scanning) */
rule nshe_T1595_4b3cf766 {
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