package provide gen 1.7.0
package require sqlite3
package require Tclx
package require textutil::string
package require ftp
if {[string equal $::tcl_platform(platform) "windows"]} {
     package require registry
}


array set ErrorCode {
     VARIABLE_NOT_FOUND -1
     INPUT_NON_NUMERIC -2
     VARIABLE_NAME_EMPTY -3
     INDEX_OUT_OF_RANGE -4
     INPUT_NOT_WELL_FORMED -5
     CANNOT_FACTOR_INPUT_LIST -6
     INPUT_INVALID -7
     INPUT_OUT_OF_RANGE -8
     INPUT_NON_POSITIVE -9
     SEARCH_STRING_EMPTY -10
     VARIABLE_CONTENTS_INVALID -11
     VARIABLE_CONTENTS_EMPTY -12
     DATABASE_VARIABLE_NOT_FOUND -13
     TABLE_NOT_FOUND -14
     ARGUMENTS_INCOHERENT -15
     REGISTRY_ELEMENT_NOT_FOUND -16
     PROC_NOT_FOUND -17
     ALREADY_EXISTS -18
     LIST_HAS_INVALID_ELEMENT -19
}

array set ErrorMessage {
     VARIABLE_NOT_FOUND {Could not find variable %s in caller.}
     INPUT_NON_NUMERIC {Got input value %s. Expected numeric value.}
     VARIABLE_NAME_EMPTY {Variable name is missing. Got empty string.}
     INDEX_OUT_OF_RANGE {List index %s is invalid.}
     INPUT_NOT_WELL_FORMED {Got input value %s. Expected input of the form %s.}
     CANNOT_FACTOR_INPUT_LIST {Input value %s does not divide list evenly.}
     INPUT_INVALID {Input value %s is invalid.}
     INPUT_OUT_OF_RANGE {Input value %s is out-of-range.}
     INPUT_NON_POSITIVE {Expected positive input value, got input value %s instead.}
     SEARCH_STRING_EMPTY {Got empty string for search value.}
     VARIABLE_CONTENTS_INVALID {Variable %s has invalid value %s.}
     VARIABLE_CONTENTS_EMPTY {Variable %s has empty value.}
     DATABASE_VARIABLE_NOT_FOUND {No variable called %s was found in the database globals table.}
     TABLE_NOT_FOUND {Table %s not found.}
     ARGUMENTS_INCOHERENT {Arguments %s and %s have incoherent values %s and %s.}
     REGISTRY_ELEMENT_NOT_FOUND {Registry key/value %s not found.}
     PROC_NOT_FOUND {Could not find proc %s.}
     ALREADY_EXISTS {Value %s in variable %s already exists.}
     LIST_HAS_INVALID_ELEMENT {List variable %s at index %s has invalid value %s.}
}

set PackageRoot [file dirname [lindex [package ifneeded gen 1.7.0]  1]]

source $PackageRoot/addepilogue.tcl

source $PackageRoot/addprologue.tcl

source $PackageRoot/addto.tcl

source $PackageRoot/appendstring2file.tcl

source $PackageRoot/arrangedict.tcl

source $PackageRoot/changecasing.tcl

source $PackageRoot/chopleft.tcl

source $PackageRoot/chopright.tcl

source $PackageRoot/coe.tcl

source $PackageRoot/commaseparatedstringtolist.tcl

source $PackageRoot/copyallfilesintodirectory.tcl

source $PackageRoot/currenttimeofday.tcl

source $PackageRoot/dateisafter.tcl

source $PackageRoot/dateisbefore.tcl

source $PackageRoot/dateisbetween.tcl

source $PackageRoot/dateison.tcl

source $PackageRoot/dateisonorafter.tcl

source $PackageRoot/dateisonorbefore.tcl

source $PackageRoot/dateminusdays.tcl

source $PackageRoot/dateplusdays.tcl

source $PackageRoot/datetimeisafter.tcl

source $PackageRoot/datetimeisat.tcl

source $PackageRoot/datetimeisatorafter.tcl

source $PackageRoot/datetimeisatorbefore.tcl

source $PackageRoot/datetimeisbefore.tcl

source $PackageRoot/datetimeisbetween.tcl

source $PackageRoot/dbaseregsub.tcl

source $PackageRoot/dbgoff.tcl

source $PackageRoot/dbgon.tcl

source $PackageRoot/dbgprint.tcl

source $PackageRoot/decr.tcl

source $PackageRoot/decrdbglobal.tcl

source $PackageRoot/deleteeverythingindirectory.tcl

source $PackageRoot/deleteonlyfilesindirectory.tcl

source $PackageRoot/dict2registrytree.tcl

source $PackageRoot/diffhhmmss.tcl

source $PackageRoot/divideby.tcl

source $PackageRoot/dividesevenly.tcl

source $PackageRoot/doublechop.tcl

source $PackageRoot/endswith.tcl

source $PackageRoot/escapedsqlstring.tcl

source $PackageRoot/evallist.tcl

source $PackageRoot/file2list.tcl

source $PackageRoot/file2string.tcl

source $PackageRoot/findandremove.tcl

source $PackageRoot/firstof.tcl

source $PackageRoot/flip.tcl

source $PackageRoot/foreachrecord.tcl

source $PackageRoot/ftpcleanremotedirectory.tcl

source $PackageRoot/ftpdownloaddirectory.tcl

source $PackageRoot/ftpdownloadsite.tcl

source $PackageRoot/ftpisdirectoryonremote.tcl

source $PackageRoot/ftpmirrorlocaltoremote.tcl

source $PackageRoot/ftpmirrorremotetolocal.tcl

source $PackageRoot/ftpuploaddirectory.tcl

source $PackageRoot/ftpuploadsite.tcl

source $PackageRoot/ftpwhichislarger.tcl

source $PackageRoot/ftpwhichisnewer.tcl

source $PackageRoot/getdbglobal.tcl

source $PackageRoot/guesspackagerootdirectory.tcl

source $PackageRoot/hhmmss2seconds.tcl

source $PackageRoot/incrdbglobal.tcl

source $PackageRoot/isdate.tcl

source $PackageRoot/isdatetime.tcl

source $PackageRoot/isdict.tcl

source $PackageRoot/isempty.tcl

source $PackageRoot/ishhmmss.tcl

source $PackageRoot/ismatrix.tcl

source $PackageRoot/isnegative.tcl

source $PackageRoot/isnonnegative.tcl

source $PackageRoot/isnonnumeric.tcl

source $PackageRoot/isnonpositive.tcl

source $PackageRoot/isnonzero.tcl

source $PackageRoot/isnumeric.tcl

source $PackageRoot/ispositive.tcl

source $PackageRoot/istimeofday.tcl

source $PackageRoot/isvalidlistindex.tcl

source $PackageRoot/iszero.tcl

source $PackageRoot/lappendifnotalready.tcl

source $PackageRoot/lastid.tcl

source $PackageRoot/lastof.tcl

source $PackageRoot/linktclvariabletoregistryvalue.tcl

source $PackageRoot/linkvartodbglobal.tcl

source $PackageRoot/list2file.tcl

source $PackageRoot/listendindex.tcl

source $PackageRoot/listremoveat.tcl

source $PackageRoot/mash.tcl

source $PackageRoot/matrix2htmltable.tcl

source $PackageRoot/multiset.tcl

source $PackageRoot/multiplyby.tcl

source $PackageRoot/multiplyhhmmss.tcl

source $PackageRoot/notempty.tcl

source $PackageRoot/now.tcl

source $PackageRoot/prepend.tcl

source $PackageRoot/printdict.tcl

source $PackageRoot/printmatrix.tcl

source $PackageRoot/printvar.tcl

source $PackageRoot/q1.tcl

source $PackageRoot/qq.tcl

source $PackageRoot/quoteifcolumntypeistext.tcl

source $PackageRoot/raise.tcl

source $PackageRoot/registryexists.tcl

source $PackageRoot/registryprint.tcl

source $PackageRoot/registrytree2dict.tcl

source $PackageRoot/reloadpackage.tcl

source $PackageRoot/restoreworkingdirectory.tcl

source $PackageRoot/retzeroifempty.tcl

source $PackageRoot/run.tcl

source $PackageRoot/runsqlcreatetable.tcl

source $PackageRoot/runsqlenter.tcl

source $PackageRoot/runsqlinsertifdoesnotexist.tcl

source $PackageRoot/saveworkingdirectory.tcl

source $PackageRoot/seconds2hhmmss.tcl

source $PackageRoot/setdateformat.tcl

source $PackageRoot/setdatetimeformat.tcl

source $PackageRoot/setdbglobal.tcl

source $PackageRoot/settimeofdayformat.tcl

source $PackageRoot/setzeroifempty.tcl

source $PackageRoot/sliceleft.tcl

source $PackageRoot/sliceright.tcl

source $PackageRoot/splitandtrim.tcl

source $PackageRoot/splitntimes.tcl

source $PackageRoot/sqlcountstatement.tcl

source $PackageRoot/sqlinsertstatement.tcl

source $PackageRoot/sqlrecordexists.tcl

source $PackageRoot/sqlselectstatement.tcl

source $PackageRoot/sqlsetclause.tcl

source $PackageRoot/sqlupdatestatement.tcl

source $PackageRoot/sqlwhereclause.tcl

source $PackageRoot/sqlitecolumnnameandtypelist.tcl

source $PackageRoot/sqlitecolumnnamelist.tcl

source $PackageRoot/sqlitecolumntype.tcl

source $PackageRoot/sqlitecopytable.tcl

source $PackageRoot/sqliterenamecolumn.tcl

source $PackageRoot/sqlitetableexists.tcl

source $PackageRoot/startsandendswith.tcl

source $PackageRoot/startswith.tcl

source $PackageRoot/string2file.tcl

source $PackageRoot/stringcontains.tcl

source $PackageRoot/stringinsert.tcl

source $PackageRoot/stringmid.tcl

source $PackageRoot/subtractfrom.tcl

source $PackageRoot/sumhhmmss.tcl

source $PackageRoot/surroundeach.tcl

source $PackageRoot/swap.tcl

source $PackageRoot/ter.tcl

source $PackageRoot/timeofday2seconds.tcl

source $PackageRoot/timeofdayisafter.tcl

source $PackageRoot/timeofdayisat.tcl

source $PackageRoot/timeofdayisatorafter.tcl

source $PackageRoot/timeofdayisatorbefore.tcl

source $PackageRoot/timeofdayisbefore.tcl

source $PackageRoot/timeofdayisbetween.tcl

source $PackageRoot/tobackslashes.tcl

source $PackageRoot/todoublebackslashes.tcl

source $PackageRoot/toforwardslashes.tcl

source $PackageRoot/today.tcl

source $PackageRoot/tomorrow.tcl

source $PackageRoot/unlinktclvariablefromregistryvalue.tcl

source $PackageRoot/unlinkvarfromdbglobal.tcl

source $PackageRoot/unsetdbglobal.tcl

source $PackageRoot/updatedbglobal.tcl

source $PackageRoot/updateregistryvalue.tcl

source $PackageRoot/upvarexistingordie.tcl

source $PackageRoot/upvarx.tcl

source $PackageRoot/varexistsincaller.tcl

source $PackageRoot/yesterday.tcl

proc GenCurrentVersion {} {
     puts 1.7.0
}
