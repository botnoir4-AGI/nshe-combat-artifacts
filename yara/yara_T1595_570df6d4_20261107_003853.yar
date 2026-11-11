/* NSHE YARA | Cycle 183 | T1595 (Active Scanning) */
rule nshe_T1595_570df6d4 {
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