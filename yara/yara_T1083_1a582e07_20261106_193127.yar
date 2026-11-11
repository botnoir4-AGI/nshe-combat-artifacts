/* NSHE YARA | Cycle 106 | T1083 (File and Directory Discovery) */
rule nshe_T1083_1a582e07 {
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