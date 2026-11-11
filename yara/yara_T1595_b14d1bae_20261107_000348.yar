/* NSHE YARA | Cycle 174 | T1595 (Active Scanning) */
rule nshe_T1595_b14d1bae {
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