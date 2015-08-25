proc Run {Script args} {

     if {[info exists ::argv]} {
          set PrevArgv $::argv
          set ResetArgv 1
     } else {
          set ResetArgv 0
     }

     set ::argv $args

     try {    
          source $Script
     } finally {
          if {$ResetArgv} {
               set ::argv $PrevArgv
          }
     }
}