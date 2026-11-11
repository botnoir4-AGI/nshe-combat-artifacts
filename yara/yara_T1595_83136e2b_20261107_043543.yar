/* NSHE YARA | Cycle 244 | T1595 (Active Scanning) */
rule nshe_T1595_83136e2b {
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