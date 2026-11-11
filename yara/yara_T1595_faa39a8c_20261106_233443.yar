/* NSHE YARA | Cycle 167 | T1595 (Active Scanning) */
rule nshe_T1595_faa39a8c {
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