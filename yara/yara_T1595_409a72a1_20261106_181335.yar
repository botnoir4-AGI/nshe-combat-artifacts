/* NSHE YARA | Cycle 87 | T1595 (Active Scanning) */
rule nshe_T1595_409a72a1 {
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