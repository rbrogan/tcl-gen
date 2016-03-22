proc GetEmailUsingPop3 {ServerAddress Username Password {DeleteMode DeleteNone}} {

     set MessageDict [dict create]

     try {
          set Socket [::pop3::open $ServerAddress $Username $Password]
          set MessageList [::pop3::retrieve $Socket 1 end]

          set MessageNumber 1
          foreach Message $MessageList {
               set Token [::mime::initialize -string $Message]
               try {
                    # Create a new entry in the dictionary for the current message.
                    # Add each field of the message to the entry.
                    set From [::mime::getheader $Token From]
                    set To [::mime::getheader $Token To]
                    set Subject [::mime::getheader $Token Subject]
                    set Date [DoubleChop [::mime::getheader $Token Date]]
                    set Body [::mime::getbody $Token]

                    dict set MessageDict $MessageNumber From $From
                    dict set MessageDict $MessageNumber To $To
                    dict set MessageDict $MessageNumber Date $Date
                    dict set MessageDict $MessageNumber Subject $Subject
                    dict set MessageDict $MessageNumber Body $Body

                    incr MessageNumber
               } finally {
                    ::mime::finalize $Token
               }
          }

          if {$DeleteMode eq "DeleteAll"} {
               ::pop3::delete $Socket 1 end
          }
     } finally {
          ::pop3::close $Socket
     }

     return $MessageDict
}