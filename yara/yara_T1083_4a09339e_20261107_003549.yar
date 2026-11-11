/* NSHE YARA | Cycle 182 | T1083 (File and Directory Discovery) */
rule nshe_T1083_4a09339e {
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