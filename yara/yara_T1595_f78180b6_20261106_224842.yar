/* NSHE YARA | Cycle 155 | T1595 (Active Scanning) */
rule nshe_T1595_f78180b6 {
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