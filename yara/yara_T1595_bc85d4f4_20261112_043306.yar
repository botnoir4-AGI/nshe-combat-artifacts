/* NSHE YARA | Cycle 12 | T1595 (Active Scanning) */
rule nshe_T1595_bc85d4f4 {
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