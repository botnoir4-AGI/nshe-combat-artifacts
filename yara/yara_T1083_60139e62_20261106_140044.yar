/* NSHE YARA | Cycle 23 | T1083 (File and Directory Discovery) */
rule nshe_T1083_60139e62 {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1083"
        severity = "MEDIUM"
    strings:
        $traversal = /\.\.[\/]/ ascii
        $cmdi = "/etc/passwd" ascii
    condition:
        any of them
}