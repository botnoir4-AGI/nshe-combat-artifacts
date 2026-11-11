/* NSHE YARA | Cycle 148 | T1595 (Active Scanning) */
rule nshe_T1595_683d530d {
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