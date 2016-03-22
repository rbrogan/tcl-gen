proc GetEmailUsingImap4 {EmailAddress Password {DeleteMode DeleteNone}} {

     try {
          set MessageDict [dict create]
          set Channel [::imap4::open $::GenNS::GetEmailUsingImap4::Hostname $::GenNS::GetEmailUsingImap4::Port]
          set ReturnCode [::imap4::login $Channel $EmailAddress $Password]
          if {$ReturnCode} {
               error "IMAP4 login failed with return code $ReturnCode"
          }

          set ReturnCode [::imap4::select $Channel INBOX]
          if {$ReturnCode} {
               error "IMAP4 select failed with return code $ReturnCode"
          }

          if {![::imap4::search $Channel ALL]} {
               set MessageIds [::imap4::mboxinfo $Channel found]
               if {[llength $MessageIds] > 0} {
                    set Fields {from: to: subject: date: TEXT}
                    set MessageNumber 1
                    set Messages [::imap4::fetch $Channel : -inline {*}$Fields]
                    foreach Message $Messages {
                         foreach {From To Subject Date Body} $Message {
                              # Create a new entry in the dictionary for the current message.
                              # Add each field of the message to the entry.

                              dict set MessageDict $MessageNumber From $From
                              dict set MessageDict $MessageNumber To $To
                              dict set MessageDict $MessageNumber Date [DoubleChop $Date]
                              dict set MessageDict $MessageNumber Subject $Subject
                              dict set MessageDict $MessageNumber Body $Body

                              incr MessageNumber
                         }
                    }

                    if {$DeleteMode eq "DeleteAll"} {
                         ::imap4::store $Channel : +FLAGS "Deleted"
                         ::imap4::expunge $Channel
                    }
               }
          }
     } finally {
          ::imap4::cleanup $Channel
     }

     return $MessageDict
}