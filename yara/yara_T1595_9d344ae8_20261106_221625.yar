/* NSHE YARA | Cycle 147 | T1595 (Active Scanning) */
rule nshe_T1595_9d344ae8 {
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