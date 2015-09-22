package provide gen 1.8.0

set PackageRoot [file dirname [lindex [package ifneeded gen 1.8.0]  1]]

source $PackageRoot/gen-error.tcl

source $PackageRoot/gen-config.tcl

catch {source $PackageRoot/gen-user-config.tcl}

source $PackageRoot/addepilogue.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/addprologue.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/addto.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/appendstring2file.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/arrangedict.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/backupifexists.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/changecasing.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/chopleft.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/chopright.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/coe.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/commaseparatedstringtolist.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/copyeverythingindirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/currenttimeofday.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateisafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateisbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateisbetween.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateison.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateisonorafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateisonorbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateminusdays.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dateplusdays.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisatorafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisatorbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/datetimeisbetween.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dbaseregsub.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dbgoff.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dbgon.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dbgprint.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/decr.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/decrdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/deleteeverythingindirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/deleteonlyfilesindirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dict2registrytree.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/diffhhmmss.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/divideby.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/dividesevenly.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/doublechop.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/endswith.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/escapedsqlstring.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/evallist.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/file2list.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/file2string.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/findandremove.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/firstof.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/flip.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/foreachrecord.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpcleanremotedirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpdownloaddirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpdownloadsite.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpisdirectoryonremote.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpmirrorlocaltoremote.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpmirrorremotetolocal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpuploaddirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpuploadsite.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpwhichislarger.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ftpwhichisnewer.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/getdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/guesspackagerootdirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/hhmmss2seconds.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/incrdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isdate.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isdatetime.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isdict.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isdirectoryempty.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isempty.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ishhmmss.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ismatrix.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnegative.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnonnegative.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnonnumeric.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnonpositive.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnonzero.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isnumeric.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ispositive.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/istimeofday.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/isvalidlistindex.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/iszero.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/lappendifnotalready.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/lastid.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/lastof.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/limitlinelengthinfile.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/linktclvariabletoregistryvalue.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/linkvartodbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/list2file.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/listendindex.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/listremoveat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/mash.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/matrix2htmltable.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/multiset.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/multiplyby.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/multiplyhhmmss.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/notempty.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/now.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/prepend.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/printdict.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/printmatrix.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/printvar.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/q1.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/qq.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/quoteifcolumntypeistext.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/raise.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/registryexists.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/registryprint.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/registrytree2dict.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/reloadpackage.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/restoreifexists.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/restoreworkingdirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/retzeroifempty.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/run.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/runsqlcreatetable.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/runsqlenter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/runsqlinsertifdoesnotexist.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/saveworkingdirectory.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/seconds2hhmmss.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/setdateformat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/setdatetimeformat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/setdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/settimeofdayformat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/setzeroifempty.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sliceleft.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sliceright.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/splitandtrim.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/splitntimes.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlcountstatement.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlinsertstatement.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlrecordexists.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlselectstatement.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlsetclause.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlupdatestatement.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlwhereclause.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlitecolumnnameandtypelist.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlitecolumnnamelist.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlitecolumntype.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlitecopytable.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqliterenamecolumn.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sqlitetableexists.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/startsandendswith.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/startswith.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/string2file.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/stringcontains.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/stringinsert.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/stringmid.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/subtractfrom.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/sumhhmmss.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/surroundeach.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/swap.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/ter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofday2seconds.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisat.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisatorafter.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisatorbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisbefore.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/timeofdayisbetween.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/tobackslashes.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/todoublebackslashes.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/toforwardslashes.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/today.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/tomorrow.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/unlinktclvariablefromregistryvalue.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/unlinkvarfromdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/unsetdbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/updatedbglobal.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/updateregistryvalue.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/upvarexistingordie.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/upvarx.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/varexistsincaller.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

source $PackageRoot/yesterday.tcl; if {($::GenPackageWarning ne "") && ($::GenNS::WarnOnFailureToLoadCommand != 0)} { puts $::GenPackageWarning }

proc GenCurrentVersion {} {
     puts 1.8.0
}
