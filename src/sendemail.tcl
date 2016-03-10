proc SendEmail {ToEmailAddress Subject Body} {

     # !! Double check to make sure that the configuration and the arguments support all options.
     try {
          set Token [mime::initialize -canonical "text/plain" -encoding "7bit" -string $Body]
          #mime::setheader $Token Subject $Subject
          smtp::sendmessage $Token  -servers [list $::GenNS::SendEmail::Host]  -ports [list $::GenNS::SendEmail::Port]  -usetls $::GenNS::SendEmail::UseTls  -username $::GenNS::SendEmail::Username  -password $::GenNS::SendEmail::Password  -queue $::GenNS::SendEmail::Queue  -atleastone $::GenNS::SendEmail::AtLeastOne  -header [list From "$::GenNS::SendEmail::FromAddress"]  -header [list To "$ToEmailAddress"]  -header [list Subject "$Subject"]  -header [list Date "[clock format [clock seconds]]"]
     } finally {
          mime::finalize $Token
     }
}