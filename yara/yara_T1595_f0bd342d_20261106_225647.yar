/* NSHE YARA | Cycle 157 | T1595 (Active Scanning) */
rule nshe_T1595_f0bd342d {
    meta:
        author = "NSHE-AUTARCH"
        ttp = "T1595"
        severity = "MEDIUM"
    strings:
        $traversal = /\.\.[\/]/ ascii
        $cmdi = "/etc/passwd" ascii
    condition:
        any of them
}