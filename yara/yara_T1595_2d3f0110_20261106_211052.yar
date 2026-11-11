/* NSHE YARA | Cycle 131 | T1595 (Active Scanning) */
rule nshe_T1595_2d3f0110 {
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