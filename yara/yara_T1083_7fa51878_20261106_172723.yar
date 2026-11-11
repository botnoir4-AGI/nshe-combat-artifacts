/* NSHE YARA | Cycle 75 | T1083 (File and Directory Discovery) */
rule nshe_T1083_7fa51878 {
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