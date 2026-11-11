/* NSHE YARA | Cycle 266 | T1083 (File and Directory Discovery) */
rule nshe_T1083_0d26e8e1 {
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