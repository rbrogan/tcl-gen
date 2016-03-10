 namespace eval GenNS {
     variable NowTesting 0
     variable WarnOnFailureToLoadCommand 0
     variable ReportOnPackagesLoaded 0     
     variable DatabaseName "testdb"
     variable GlobalsTable "globals"
     variable DateFormat %Y-%m-%d     
     variable DatetimeFormat {{%Y-%m-%d %H:%M:%S}}
     variable TimeOfDayFormat %H:%M:%S
     variable LoadHelpx 1
     variable DebugOn 0
     variable SavedWorkingDirectory ""
     variable PutGenCommandsInNamespace 0
     variable ImportGenCommandsIntoGlobalNamespace 0
     variable GenNamespaceName GenNS
     namespace eval Ftp {
          variable Server See-test/README-test-ftp.txt
          variable Username See-test/README-test-ftp.txt
          variable Password See-test/README-test-ftp.txt
          variable OptionsList ""
          variable FileTransferType ""
          variable DryRun 0
     }
     namespace eval SendEmail {
          variable Host {::GenNS::SendEmail::Host is not set!}
          variable Port {::GenNS::SendEmail::Port is not set!}
          variable FromAddress {::GenNS::SendEmail::FromAddress is not set!}
          variable Username {::GenNS::SendEmail::Username is not set!}
          variable Password {::GenNS::SendEmail::Password is not set!}
          variable UseTls false
          variable Debug false
          variable Queue false
          variable AtLeastOne true
     }     
}

