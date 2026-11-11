/* NSHE YARA | Cycle 273 | T1083 (File and Directory Discovery) */
rule nshe_T1083_94a47a6e {
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