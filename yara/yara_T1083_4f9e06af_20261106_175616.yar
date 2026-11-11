/* NSHE YARA | Cycle 82 | T1083 (File and Directory Discovery) */
rule nshe_T1083_4f9e06af {
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