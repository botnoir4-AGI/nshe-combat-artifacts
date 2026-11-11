/* NSHE YARA | Cycle 71 | T1595 (Active Scanning) */
rule nshe_T1595_c6316a86 {
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