/* NSHE YARA | Cycle 96 | T1083 (File and Directory Discovery) */
rule nshe_T1083_45741653 {
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