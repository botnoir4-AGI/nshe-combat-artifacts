/* NSHE YARA | Cycle 253 | T1083 (File and Directory Discovery) */
rule nshe_T1083_a4b1e22e {
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