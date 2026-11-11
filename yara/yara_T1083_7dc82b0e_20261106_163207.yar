/* NSHE YARA | Cycle 61 | T1083 (File and Directory Discovery) */
rule nshe_T1083_7dc82b0e {
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