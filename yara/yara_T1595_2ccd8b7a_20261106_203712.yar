/* NSHE YARA | Cycle 123 | T1595 (Active Scanning) */
rule nshe_T1595_2ccd8b7a {
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