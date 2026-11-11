/* NSHE YARA | Cycle 208 | T1083 (File and Directory Discovery) */
rule nshe_T1083_8ce5292a {
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