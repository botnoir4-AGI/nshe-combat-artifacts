/* NSHE YARA | Cycle 247 | T1595 (Active Scanning) */
rule nshe_T1595_08f1a104 {
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