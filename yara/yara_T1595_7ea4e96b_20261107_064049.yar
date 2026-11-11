/* NSHE YARA | Cycle 278 | T1595 (Active Scanning) */
rule nshe_T1595_7ea4e96b {
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