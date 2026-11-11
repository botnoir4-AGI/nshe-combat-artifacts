/* NSHE YARA | Cycle 222 | T1595 (Active Scanning) */
rule nshe_T1595_d5c0b57b {
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