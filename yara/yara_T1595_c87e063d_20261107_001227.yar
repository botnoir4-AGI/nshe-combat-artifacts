/* NSHE YARA | Cycle 176 | T1595 (Active Scanning) */
rule nshe_T1595_c87e063d {
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