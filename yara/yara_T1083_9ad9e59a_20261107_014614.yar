/* NSHE YARA | Cycle 200 | T1083 (File and Directory Discovery) */
rule nshe_T1083_9ad9e59a {
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