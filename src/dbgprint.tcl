proc DbgPrint Message {

     if {$GenNS::DebugOn} {
          puts $Message
     }
}