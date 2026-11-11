/* NSHE YARA | Cycle 2 | T1595 (Active Scanning) */
rule nshe_T1595_9ddf5e71 {
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