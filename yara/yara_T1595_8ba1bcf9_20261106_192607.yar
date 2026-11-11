/* NSHE YARA | Cycle 105 | T1595 (Active Scanning) */
rule nshe_T1595_8ba1bcf9 {
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