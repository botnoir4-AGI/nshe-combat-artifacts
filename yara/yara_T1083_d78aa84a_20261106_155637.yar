/* NSHE YARA | Cycle 52 | T1083 (File and Directory Discovery) */
rule nshe_T1083_d78aa84a {
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