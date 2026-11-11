/* NSHE YARA | Cycle 68 | T1083 (File and Directory Discovery) */
rule nshe_T1083_d74e2c26 {
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