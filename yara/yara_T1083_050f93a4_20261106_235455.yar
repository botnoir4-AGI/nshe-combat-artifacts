/* NSHE YARA | Cycle 172 | T1083 (File and Directory Discovery) */
rule nshe_T1083_050f93a4 {
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