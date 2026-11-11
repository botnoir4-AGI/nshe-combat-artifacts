/* NSHE YARA | Cycle 206 | T1595 (Active Scanning) */
rule nshe_T1595_4ee6596e {
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