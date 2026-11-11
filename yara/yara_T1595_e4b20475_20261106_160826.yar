/* NSHE YARA | Cycle 55 | T1595 (Active Scanning) */
rule nshe_T1595_e4b20475 {
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