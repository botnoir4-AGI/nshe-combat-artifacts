/* NSHE YARA | Cycle 48 | T1083 (File and Directory Discovery) */
rule nshe_T1083_f02e3e53 {
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