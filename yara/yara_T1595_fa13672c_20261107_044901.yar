/* NSHE YARA | Cycle 248 | T1595 (Active Scanning) */
rule nshe_T1595_fa13672c {
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