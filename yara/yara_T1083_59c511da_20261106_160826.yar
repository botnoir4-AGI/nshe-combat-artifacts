/* NSHE YARA | Cycle 55 | T1083 (File and Directory Discovery) */
rule nshe_T1083_59c511da {
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