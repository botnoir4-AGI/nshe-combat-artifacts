/* NSHE YARA | Cycle 249 | T1595 (Active Scanning) */
rule nshe_T1595_49c14b58 {
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