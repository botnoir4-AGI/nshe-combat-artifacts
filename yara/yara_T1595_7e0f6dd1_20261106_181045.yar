/* NSHE YARA | Cycle 86 | T1595 (Active Scanning) */
rule nshe_T1595_7e0f6dd1 {
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