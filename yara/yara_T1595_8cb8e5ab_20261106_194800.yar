/* NSHE YARA | Cycle 110 | T1595 (Active Scanning) */
rule nshe_T1595_8cb8e5ab {
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