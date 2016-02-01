proc NextMinorVersionNumber VersionNumber {

     MultiSet {CurrentMajor CurrentMinor CurrentRevision} [split $VersionNumber .]
     set NextMinor [incr CurrentMinor]
     return [join [list $CurrentMajor $NextMinor 0] .]
}