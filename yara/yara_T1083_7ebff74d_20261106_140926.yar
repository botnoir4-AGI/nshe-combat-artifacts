/* NSHE YARA | Cycle 25 | T1083 (File and Directory Discovery) */
rule nshe_T1083_7ebff74d {
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