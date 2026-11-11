/* NSHE YARA | Cycle 171 | T1083 (File and Directory Discovery) */
rule nshe_T1083_9cf0d668 {
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