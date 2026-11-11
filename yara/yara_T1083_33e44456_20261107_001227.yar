/* NSHE YARA | Cycle 176 | T1083 (File and Directory Discovery) */
rule nshe_T1083_33e44456 {
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