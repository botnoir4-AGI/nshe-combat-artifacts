/* NSHE YARA | Cycle 154 | T1083 (File and Directory Discovery) */
rule nshe_T1083_0901f2d1 {
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