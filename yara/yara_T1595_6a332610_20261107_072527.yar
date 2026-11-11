/* NSHE YARA | Cycle 289 | T1595 (Active Scanning) */
rule nshe_T1595_6a332610 {
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