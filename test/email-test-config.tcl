set ::GenNS::SendEmail::Servers {your send to server not set, check test/email-test-config.tcl}
set ::GenNS::SendEmail::Port {your send to port not set, check test/email-test-config.tcl}
set ::GenNS::SendEmail::FromAddress {your send from address not set, check test/email-test-config.tcl}
set ::GenNS::SendEmail::Username {your send from username not set, check test/email-test-config.tcl}
set ::GenNS::SendEmail::Password {your send from password not set, check test/email-test-config.tcl}
set ::GenNS::SendEmail::UseTls false
set ::GenNS::SendEmail::Debug false
set ::GenNS::SendEmail::Queue false
set ::GenNS::SendEmail::AtLeastOne true

namespace eval ::GenTest::Email {

set EmailServerAddress {your receive from server not set, check test/email-test-config.tcl}
set ReceiveEmailAddress {your receive from email address not set, check test/email-test-config.tcl}
set ReceiveEmailAccount {your receive from email account not set, check test/email-test-config.tcl}
set ReceiveEmailPassword {your receive from email password not set, check test/email-test-config.tcl}

}
