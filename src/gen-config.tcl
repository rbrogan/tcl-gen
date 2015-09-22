 namespace eval GenNS {
     variable WarnOnFailureToLoadCommand 0
     variable DatabaseName "testdb"
     variable GlobalsTable "globals"
     variable DateFormat %Y-%m-%d     
     variable DatetimeFormat {{%Y-%m-%d %H:%M:%S}}
     variable TimeOfDayFormat %H:%M:%S
     variable LoadHelpx 1
     variable DebugOn 0
     variable SavedWorkingDirectory ""
     namespace eval Ftp {
          variable Server See-test/README-test-ftp.txt
          variable Username See-test/README-test-ftp.txt
          variable Password See-test/README-test-ftp.txt
          variable OptionsList ""
          variable FileTransferType ""
          variable DryRun 0
     }     
}

