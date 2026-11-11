/* NSHE YARA | Cycle 58 | T1595 (Active Scanning) */
rule nshe_T1595_cf2cb3a5 {
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