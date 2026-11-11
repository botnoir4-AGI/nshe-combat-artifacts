/* NSHE YARA | Cycle 125 | T1595 (Active Scanning) */
rule nshe_T1595_b8320d9f {
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