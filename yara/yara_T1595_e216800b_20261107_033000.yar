/* NSHE YARA | Cycle 228 | T1595 (Active Scanning) */
rule nshe_T1595_e216800b {
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