/* NSHE YARA | Cycle 31 | T1083 (File and Directory Discovery) */
rule nshe_T1083_e0ea7a3f {
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