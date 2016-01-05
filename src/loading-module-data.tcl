

set ::GenNS::LoadingNS::PackageReadyList { Tcl Tclx ftp registry sqlite3 test-loading-module-package test-missing-package textutil::adjust textutil::string }

set ::GenNS::LoadingNS::SourceReadyList { AddEpilogue AddPrologue CurrentTimeOfDay DbgOff DbgOn DbgPrint DeleteOnlyFilesInDirectory DividesEvenly EscapedSqlString EvalList FirstOf GuessPackageRootDirectory IsDate IsDatetime IsDict IsDirectoryEmpty IsEmpty IsHhmmss IsMatrix IsTimeOfDay LastOf ListEndIndex NotEmpty Now QuoteIfColumnTypeIsText SaveWorkingDirectory SetDateFormat SetDatetimeFormat SetTimeOfDayFormat SliceLeft SliceRight SqlWhereClause StartsWith StringContains Ter TimeOfDay2Seconds Today Tomorrow UpdateDbGlobal UpdateRegistryValue Yesterday }

set ::GenNS::LoadingNS::CommandsInPackage(Tcl) { {tell 8.5} {socket 8.5} {subst 8.5} {open 8.5} {eof 8.5} {pwd 8.5} {glob 8.5} {list 8.5} {pid 8.5} {exec 8.5} {auto_load_index 8.5} {time 8.5} {unknown 8.5} {eval 8.5} {lassign 8.5} {lrange 8.5} {fblocked 8.5} {lsearch 8.5} {auto_import 8.5} {gets 8.5} {case 8.5} {lappend 8.5} {proc 8.5} {throw 8.6} {break 8.5} {variable 8.5} {llength 8.5} {auto_execok 8.5} {return 8.5} {linsert 8.5} {error 8.5} {catch 8.5} {clock 8.5} {info 8.5} {split 8.5} {array 8.5} {if 8.5} {fconfigure 8.5} {coroutine 8.6} {concat 8.5} {join 8.5} {lreplace 8.5} {source 8.5} {fcopy 8.5} {global 8.5} {switch 8.5} {auto_qualify 8.5} {update 8.5} {close 8.5} {cd 8.5} {for 8.5} {auto_load 8.5} {file 8.5} {append 8.5} {lreverse 8.5} {format 8.5} {lmap 8.6} {unload 8.5} {read 8.5} {package 8.5} {set 8.5} {namespace 8.5} {binary 8.5} {scan 8.5} {apply 8.5} {trace 8.5} {seek 8.5} {zlib 8.6} {while 8.5} {chan 8.5} {flush 8.5} {after 8.5} {vwait 8.5} {dict 8.5} {uplevel 8.5} {continue 8.5} {try 8.6} {foreach 8.5} {lset 8.5} {rename 8.5} {fileevent 8.5} {yieldto 8.6} {regexp 8.5} {lrepeat 8.5} {upvar 8.5} {tailcall 8.6} {encoding 8.5} {expr 8.5} {unset 8.5} {load 8.5} {regsub 8.5} {history 8.5} {interp 8.5} {exit 8.5} {puts 8.5} {incr 8.5} {lindex 8.5} {lsort 8.5} {tclLog 8.5} {string 8.5} {yield 8.6} }

set ::GenNS::LoadingNS::CommandsInPackage(Tclx) { {lvarpop 8.4} }

set ::GenNS::LoadingNS::CommandsInPackage(ftp) { {ftp::Cd 2.4.13} {ftp::List 2.4.13} {ftp::NList 2.4.13} {ftp::RmDir 2.4.13} {ftp::Delete 2.4.13} {ftp::Get 2.4.13} {ftp::Type 2.4.13} {ftp::Close 2.4.13} {ftp::MkDir 2.4.13} {ftp::Put 2.4.13} {ftp::FileSize 2.4.13} {ftp::ModTime 2.4.13} {ftp::Open 2.4.13} }

set ::GenNS::LoadingNS::CommandsInPackage(registry) { {registry 1.3.0} }

set ::GenNS::LoadingNS::CommandsInPackage(sqlite3) { {sqlite3 3.5.9} }

set ::GenNS::LoadingNS::CommandsInPackage(test-loading-module-package) { {TestLoadingModuleNS::SampleCommand1 0.1} {TestLoadingModuleNS::SampleCommand2 1.0} }

set ::GenNS::LoadingNS::CommandsInPackage(test-missing-package) { {TestLoadingModuleNS::SampleCommand3 1.0} }

set ::GenNS::LoadingNS::CommandsInPackage(textutil::adjust) { {::textutil::adjust::adjust 0.7.1} }

set ::GenNS::LoadingNS::CommandsInPackage(textutil::string) { {::textutil::string::cap 0.8} }

set ::GenNS::LoadingNS::DependentsList(::textutil::adjust::adjust) {LimitLineLengthInFile}

set ::GenNS::LoadingNS::DependentsList(::textutil::string::cap) {ChangeCasing}

set ::GenNS::LoadingNS::DependentsList(AddTo) {SumHhmmss DatetimePlus DatePlus}

set ::GenNS::LoadingNS::DependentsList(ChopLeft) {DoubleChop}

set ::GenNS::LoadingNS::DependentsList(ChopRight) {DoubleChop}

set ::GenNS::LoadingNS::DependentsList(Coe) {DbaseRegsub SqlCountStatement SqlSelectStatement SqlUpdateStatement}

set ::GenNS::LoadingNS::DependentsList(CurrentTimeOfDay) {CurrentTimeOfDayIsAfter CurrentTimeOfDayIsBefore CurrentTimeOfDayIsBetween CurrentTimeOfDayIsAtOrAfter CurrentTimeOfDayIsAtOrBefore}

set ::GenNS::LoadingNS::DependentsList(CurrentTimeOfDayIsBetween) {CurrentTimeOfDayIsAbout}

set ::GenNS::LoadingNS::DependentsList(DateIsAfter) {DateIsOnOrBefore}

set ::GenNS::LoadingNS::DependentsList(DateIsBefore) {DateIsOnOrAfter}

set ::GenNS::LoadingNS::DependentsList(DatePlus) {DateMinus}

set ::GenNS::LoadingNS::DependentsList(DatetimeIsAfter) {DatetimeIsAtOrBefore}

set ::GenNS::LoadingNS::DependentsList(DatetimeIsBefore) {DatetimeIsAtOrAfter}

set ::GenNS::LoadingNS::DependentsList(DatetimePlus) {DatetimeMinus}

set ::GenNS::LoadingNS::DependentsList(DbgPrint) {FtpCleanRemoteDirectory FtpDownloadDirectory FtpUploadDirectory FtpDownloadFiles FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(Decr) {SplitNTimes}

set ::GenNS::LoadingNS::DependentsList(EndsWith) {StartsAndEndsWith}

set ::GenNS::LoadingNS::DependentsList(EscapedSqlString) {DbaseRegsub}

set ::GenNS::LoadingNS::DependentsList(File2List) {LimitLineLengthInFile}

set ::GenNS::LoadingNS::DependentsList(FindAndRemove) {FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(FirstOf) {Q1}

set ::GenNS::LoadingNS::DependentsList(FtpCleanRemoteDirectory) {FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(FtpDownloadDirectory) {FtpDownloadSite FtpMirrorRemoteToLocal}

set ::GenNS::LoadingNS::DependentsList(FtpIsDirectoryOnRemote) {FtpCleanRemoteDirectory FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(FtpUploadDirectory) {FtpMirrorLocalToRemote FtpUploadSite}

set ::GenNS::LoadingNS::DependentsList(FtpWhichIsLarger) {FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(FtpWhichIsNewer) {FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(GetDbGlobal) {SetDbGlobal}

set ::GenNS::LoadingNS::DependentsList(Hhmmss2Seconds) {DiffHhmmss MultiplyHhmmss SumHhmmss}

set ::GenNS::LoadingNS::DependentsList(IsDate) {DateIsAfter DateIsBefore DateIsBetween DateIsOn DateMinusDays DatePlusDays DateMinus DatePlus}

set ::GenNS::LoadingNS::DependentsList(IsDatetime) {DatetimeIsAfter DatetimeIsAt DatetimeIsBefore DatetimeIsBetween DatetimeMinus DatetimePlus}

set ::GenNS::LoadingNS::DependentsList(IsDict) {Dict2RegistryTree PrintDict}

set ::GenNS::LoadingNS::DependentsList(IsEmpty) {BackupIfExists LimitLineLengthInFile RestoreIfExists AddTo UpvarX AppendString2File UpvarExistingOrDie CopyEverythingInDirectory DbaseRegsub Decr DecrDbGlobal DeleteEverythingInDirectory Dict2RegistryTree DiffHhmmss DivideBy EndsWith ForeachRecord FtpWhichIsLarger FtpWhichIsNewer GetDbGlobal Hhmmss2Seconds IncrDbGlobal IsNonNumeric IsNumeric LastId LinkTclVariableToRegistryValue LinkVarToDbGlobal ListRemoveAt MultiplyBy MultiplyHhmmss PrintMatrix PrintVar Q1 QQ RegistryExists RegistryTree2Dict ReloadPackage RetZeroIfEmpty RunSqlCreateTable RunSqlEnter RunSqlInsertIfDoesNotExist Seconds2Hhmmss SetDbGlobal SetZeroIfEmpty SqlCountStatement SqlInsertStatement SqlRecordExists SqlSelectStatement SqlSetClause SqlUpdateStatement SqliteColumnNameAndTypeList SqliteColumnNameList SqliteColumnType SqliteCopyTable SqliteRenameColumn SqliteTableExists StringInsert SubtractFrom UnlinkTclVariableFromRegistryValue UnlinkVarFromDbGlobal UnsetDbGlobal VarExistsInCaller Coe}

set ::GenNS::LoadingNS::DependentsList(IsHhmmss) {DiffHhmmss Hhmmss2Seconds MultiplyHhmmss SumHhmmss}

set ::GenNS::LoadingNS::DependentsList(IsMatrix) {Matrix2HtmlTable PrintMatrix}

set ::GenNS::LoadingNS::DependentsList(IsNegative) {IsValidListIndex StringInsert}

set ::GenNS::LoadingNS::DependentsList(IsNonNumeric) {AddTo DateMinusDays DatePlusDays Decr DecrDbGlobal DivideBy Flip IncrDbGlobal IsNegative IsNonNegative IsNonPositive IsNonZero IsPositive IsZero ListRemoveAt MultiplyBy MultiplyHhmmss PrintMatrix Seconds2Hhmmss SplitNTimes StringInsert StringMid SubtractFrom}

set ::GenNS::LoadingNS::DependentsList(IsNonPositive) {LimitLineLengthInFile ListRemoveAt PrintMatrix SplitNTimes StringMid}

set ::GenNS::LoadingNS::DependentsList(IsPositive) {Raise StringInsert}

set ::GenNS::LoadingNS::DependentsList(IsTimeOfDay) {TimeOfDayIsAfter TimeOfDayIsAt TimeOfDayIsBefore TimeOfDayIsBetween CurrentTimeOfDayIsAbout CurrentTimeOfDayIsAfter CurrentTimeOfDayIsBefore CurrentTimeOfDayIsBetween CurrentTimeOfDayIsAtOrAfter CurrentTimeOfDayIsAtOrBefore}

set ::GenNS::LoadingNS::DependentsList(LastId) {RunSqlEnter RunSqlInsertIfDoesNotExist}

set ::GenNS::LoadingNS::DependentsList(List2File) {LimitLineLengthInFile}

set ::GenNS::LoadingNS::DependentsList(MultiplyBy) {DatetimePlus DatePlus}

set ::GenNS::LoadingNS::DependentsList(NotEmpty) {File2String UpvarX Decr File2List FtpCleanRemoteDirectory FtpDownloadDirectory FtpDownloadSite FtpMirrorRemoteToLocal FtpUploadDirectory FtpUploadSite PrintMatrix RestoreWorkingDirectory RunSqlEnter SplitAndTrim}

set ::GenNS::LoadingNS::DependentsList(PrintDict) {RegistryPrint}

set ::GenNS::LoadingNS::DependentsList(Q1) {DecrDbGlobal GetDbGlobal IncrDbGlobal LastId RunSqlEnter RunSqlInsertIfDoesNotExist SqlRecordExists SqliteColumnNameAndTypeList SqliteColumnNameList SqliteTableExists}

set ::GenNS::LoadingNS::DependentsList(QQ) {DbaseRegsub ForeachRecord RunSqlCreateTable RunSqlEnter RunSqlInsertIfDoesNotExist SqliteCopyTable SqliteRenameColumn UnsetDbGlobal}

set ::GenNS::LoadingNS::DependentsList(RegistryExists) {Dict2RegistryTree LinkTclVariableToRegistryValue RegistryPrint RegistryTree2Dict}

set ::GenNS::LoadingNS::DependentsList(RegistryTree2Dict) {RegistryPrint}

set ::GenNS::LoadingNS::DependentsList(RestoreWorkingDirectory) {FtpDownloadSite FtpMirrorLocalToRemote}

set ::GenNS::LoadingNS::DependentsList(RunSqlCreateTable) {SqliteCopyTable SqliteRenameColumn}

set ::GenNS::LoadingNS::DependentsList(RunSqlEnter) {SetDbGlobal}

set ::GenNS::LoadingNS::DependentsList(RunSqlInsertIfDoesNotExist) {RunSqlEnter}

set ::GenNS::LoadingNS::DependentsList(SaveWorkingDirectory) {FtpDownloadSite FtpMirrorLocalToRemote}

set ::GenNS::LoadingNS::DependentsList(Seconds2Hhmmss) {DiffHhmmss MultiplyHhmmss SumHhmmss}

set ::GenNS::LoadingNS::DependentsList(SetDbGlobal) {DecrDbGlobal IncrDbGlobal LinkVarToDbGlobal}

set ::GenNS::LoadingNS::DependentsList(SetZeroIfEmpty) {AddTo Decr SubtractFrom}

set ::GenNS::LoadingNS::DependentsList(SqlCountStatement) {SqlRecordExists}

set ::GenNS::LoadingNS::DependentsList(SqlInsertStatement) {RunSqlEnter}

set ::GenNS::LoadingNS::DependentsList(SqlRecordExists) {DecrDbGlobal GetDbGlobal IncrDbGlobal}

set ::GenNS::LoadingNS::DependentsList(SqlSelectStatement) {RunSqlInsertIfDoesNotExist}

set ::GenNS::LoadingNS::DependentsList(SqlSetClause) {SqlUpdateStatement}

set ::GenNS::LoadingNS::DependentsList(SqlUpdateStatement) {RunSqlEnter}

set ::GenNS::LoadingNS::DependentsList(SqlWhereClause) {DbaseRegsub RunSqlEnter SqlCountStatement SqlSelectStatement SqlUpdateStatement}

set ::GenNS::LoadingNS::DependentsList(SqliteColumnNameAndTypeList) {SqliteColumnType SqliteCopyTable SqliteRenameColumn}

set ::GenNS::LoadingNS::DependentsList(SqliteTableExists) {SqliteCopyTable SqliteRenameColumn}

set ::GenNS::LoadingNS::DependentsList(StartsWith) {Hhmmss2Seconds StartsAndEndsWith}

set ::GenNS::LoadingNS::DependentsList(SubtractFrom) {DatetimePlus DatePlus}

set ::GenNS::LoadingNS::DependentsList(Ter) {Decr PrintDict StringInsert}

set ::GenNS::LoadingNS::DependentsList(TestLoadingModuleNS::SampleCommand1) {GenTestCommand1}

set ::GenNS::LoadingNS::DependentsList(TestLoadingModuleNS::SampleCommand2) {GenTestCommand2}

set ::GenNS::LoadingNS::DependentsList(TestLoadingModuleNS::SampleCommand3) {GenTestCommand3}

set ::GenNS::LoadingNS::DependentsList(TimeOfDay2Seconds) {TimeOfDayIsBetween TimeOfDayIsAfter TimeOfDayIsBefore TimeOfDayIsAtOrBefore TimeOfDayIsAtOrAfter}

set ::GenNS::LoadingNS::DependentsList(TimeOfDayIsAfter) {TimeOfDayIsAtOrBefore CurrentTimeOfDayIsAfter}

set ::GenNS::LoadingNS::DependentsList(TimeOfDayIsAtOrAfter) {CurrentTimeOfDayIsAtOrAfter}

set ::GenNS::LoadingNS::DependentsList(TimeOfDayIsAtOrBefore) {CurrentTimeOfDayIsAtOrBefore}

set ::GenNS::LoadingNS::DependentsList(TimeOfDayIsBefore) {TimeOfDayIsAtOrAfter CurrentTimeOfDayIsBefore}

set ::GenNS::LoadingNS::DependentsList(TimeOfDayIsBetween) {CurrentTimeOfDayIsBetween}

set ::GenNS::LoadingNS::DependentsList(ToDoubleBackslashes) {LinkTclVariableToRegistryValue UnlinkTclVariableFromRegistryValue}

set ::GenNS::LoadingNS::DependentsList(UpdateDbGlobal) {LinkVarToDbGlobal}

set ::GenNS::LoadingNS::DependentsList(UpdateRegistryValue) {LinkTclVariableToRegistryValue}

set ::GenNS::LoadingNS::DependentsList(UpvarExistingOrDie) {ArrangeDict ChangeCasing ChopLeft ChopRight CommaSeparatedStringToList DoubleChop Mash SplitAndTrim StringInsert ToBackslashes ToDoubleBackslashes ToForwardSlashes FindAndRemove ListRemoveAt Raise SurroundEach DateMinusDays DatePlusDays DiffHhmmss DivideBy Flip Hhmmss2Seconds MultiplyBy MultiplyHhmmss PrintVar Seconds2Hhmmss}

set ::GenNS::LoadingNS::DependentsList(UpvarX) {AddTo Decr LappendIfNotAlready LinkTclVariableToRegistryValue LinkVarToDbGlobal MultiSet Prepend SetZeroIfEmpty SubtractFrom Swap}

set ::GenNS::LoadingNS::DependentsList(VarExistsInCaller) {UpvarX UpvarExistingOrDie}

set ::GenNS::LoadingNS::DependentsList(ftp::Cd) {FtpCleanRemoteDirectory FtpDownloadDirectory FtpDownloadSite FtpMirrorLocalToRemote FtpUploadDirectory FtpUploadSite FtpDownloadFiles FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(ftp::Close) {FtpDownloadSite FtpMirrorLocalToRemote FtpMirrorRemoteToLocal FtpUploadSite FtpDownloadFiles FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(ftp::Delete) {FtpCleanRemoteDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(ftp::FileSize) {FtpIsDirectoryOnRemote FtpWhichIsLarger}

set ::GenNS::LoadingNS::DependentsList(ftp::Get) {FtpDownloadDirectory FtpDownloadFiles}

set ::GenNS::LoadingNS::DependentsList(ftp::List) {FtpCleanRemoteDirectory FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(ftp::MkDir) {FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(ftp::ModTime) {FtpWhichIsNewer}

set ::GenNS::LoadingNS::DependentsList(ftp::NList) {FtpCleanRemoteDirectory FtpDownloadDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(ftp::Open) {FtpMirrorRemoteToLocal FtpUploadSite FtpDownloadFiles FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(ftp::Put) {FtpUploadDirectory FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(ftp::RmDir) {FtpCleanRemoteDirectory FtpUploadDirectory}

set ::GenNS::LoadingNS::DependentsList(ftp::Type) {FtpDownloadSite FtpMirrorRemoteToLocal FtpUploadSite FtpDownloadFiles FtpUploadFiles}

set ::GenNS::LoadingNS::DependentsList(lvarpop) {ChangeCasing SqliteColumnNameAndTypeList}

set ::GenNS::LoadingNS::DependentsList(registry) {Dict2RegistryTree LinkTclVariableToRegistryValue RegistryExists RegistryPrint RegistryTree2Dict UnlinkTclVariableFromRegistryValue}

set ::GenNS::LoadingNS::DependentsList(sqlite3) {Q1 QQ}

set ::GenNS::LoadingNS::DependentsList(try) {FtpDownloadFiles FtpUploadFiles File2List File2String AppendString2File FtpMirrorRemoteToLocal FtpMirrorLocalToRemote FtpDownloadFiles FtpDownloadSite FtpUploadFiles FtpUploadSite List2File Run String2File}

set ::GenNS::LoadingNS::DependencyList(AddTo) { IsEmpty IsNonNumeric SetZeroIfEmpty UpvarX}
set ::GenNS::LoadingNS::DependencyList(AppendString2File) { IsEmpty try}
set ::GenNS::LoadingNS::DependencyList(ArrangeDict) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(BackupIfExists) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(ChangeCasing) { ::textutil::string::cap UpvarExistingOrDie lvarpop}
set ::GenNS::LoadingNS::DependencyList(ChopLeft) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(ChopRight) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Coe) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(CommaSeparatedStringToList) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(CopyEverythingInDirectory) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsAbout) { CurrentTimeOfDayIsBetween IsTimeOfDay}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsAfter) { CurrentTimeOfDay IsTimeOfDay TimeOfDayIsAfter}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsAtOrAfter) { CurrentTimeOfDay IsTimeOfDay TimeOfDayIsAtOrAfter}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsAtOrBefore) { CurrentTimeOfDay IsTimeOfDay TimeOfDayIsAtOrBefore}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsBefore) { CurrentTimeOfDay IsTimeOfDay TimeOfDayIsBefore}
set ::GenNS::LoadingNS::DependencyList(CurrentTimeOfDayIsBetween) { CurrentTimeOfDay IsTimeOfDay TimeOfDayIsBetween}
set ::GenNS::LoadingNS::DependencyList(DateIsAfter) { IsDate}
set ::GenNS::LoadingNS::DependencyList(DateIsBefore) { IsDate}
set ::GenNS::LoadingNS::DependencyList(DateIsBetween) { IsDate}
set ::GenNS::LoadingNS::DependencyList(DateIsOn) { IsDate}
set ::GenNS::LoadingNS::DependencyList(DateIsOnOrAfter) { DateIsBefore}
set ::GenNS::LoadingNS::DependencyList(DateIsOnOrBefore) { DateIsAfter}
set ::GenNS::LoadingNS::DependencyList(DateMinus) { DatePlus IsDate}
set ::GenNS::LoadingNS::DependencyList(DateMinusDays) { IsDate IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(DatePlus) { AddTo IsDate MultiplyBy SubtractFrom}
set ::GenNS::LoadingNS::DependencyList(DatePlusDays) { IsDate IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsAfter) { IsDatetime}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsAt) { IsDatetime}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsAtOrAfter) { DatetimeIsBefore}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsAtOrBefore) { DatetimeIsAfter}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsBefore) { IsDatetime}
set ::GenNS::LoadingNS::DependencyList(DatetimeIsBetween) { IsDatetime}
set ::GenNS::LoadingNS::DependencyList(DatetimeMinus) { DatetimePlus IsDatetime}
set ::GenNS::LoadingNS::DependencyList(DatetimePlus) { AddTo IsDatetime MultiplyBy SubtractFrom}
set ::GenNS::LoadingNS::DependencyList(DbaseRegsub) { Coe EscapedSqlString IsEmpty QQ SqlWhereClause}
set ::GenNS::LoadingNS::DependencyList(Decr) { IsEmpty IsNonNumeric NotEmpty SetZeroIfEmpty Ter UpvarX}
set ::GenNS::LoadingNS::DependencyList(DecrDbGlobal) { IsEmpty IsNonNumeric Q1 SetDbGlobal SqlRecordExists}
set ::GenNS::LoadingNS::DependencyList(DeleteEverythingInDirectory) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(Dict2RegistryTree) { IsDict IsEmpty RegistryExists registry}
set ::GenNS::LoadingNS::DependencyList(DiffHhmmss) { Hhmmss2Seconds IsEmpty IsHhmmss Seconds2Hhmmss UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(DivideBy) { IsEmpty IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(DoubleChop) { ChopLeft ChopRight UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(EndsWith) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(File2List) { NotEmpty try}
set ::GenNS::LoadingNS::DependencyList(File2String) { NotEmpty try}
set ::GenNS::LoadingNS::DependencyList(FindAndRemove) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Flip) { IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(ForeachRecord) { IsEmpty QQ}
set ::GenNS::LoadingNS::DependencyList(FtpCleanRemoteDirectory) { DbgPrint FtpIsDirectoryOnRemote NotEmpty ftp::Cd ftp::Delete ftp::List ftp::NList ftp::RmDir}
set ::GenNS::LoadingNS::DependencyList(FtpDownloadDirectory) { DbgPrint FindAndRemove FtpIsDirectoryOnRemote FtpWhichIsLarger FtpWhichIsNewer NotEmpty ftp::Cd ftp::Get ftp::List ftp::NList}
set ::GenNS::LoadingNS::DependencyList(FtpDownloadFiles) { DbgPrint ftp::Cd ftp::Close ftp::Get ftp::Open ftp::Type try try}
set ::GenNS::LoadingNS::DependencyList(FtpDownloadSite) { FtpDownloadDirectory NotEmpty RestoreWorkingDirectory SaveWorkingDirectory ftp::Cd ftp::Close ftp::Type try}
set ::GenNS::LoadingNS::DependencyList(FtpIsDirectoryOnRemote) { ftp::FileSize}
set ::GenNS::LoadingNS::DependencyList(FtpMirrorLocalToRemote) { FtpUploadDirectory RestoreWorkingDirectory SaveWorkingDirectory ftp::Cd ftp::Close try}
set ::GenNS::LoadingNS::DependencyList(FtpMirrorRemoteToLocal) { FtpDownloadDirectory NotEmpty ftp::Close ftp::Open ftp::Type try}
set ::GenNS::LoadingNS::DependencyList(FtpUploadDirectory) { DbgPrint FindAndRemove FtpCleanRemoteDirectory FtpIsDirectoryOnRemote FtpWhichIsLarger FtpWhichIsNewer NotEmpty ftp::Cd ftp::Delete ftp::List ftp::MkDir ftp::NList ftp::Put ftp::RmDir}
set ::GenNS::LoadingNS::DependencyList(FtpUploadFiles) { DbgPrint ftp::Cd ftp::Close ftp::Open ftp::Put ftp::Type try try}
set ::GenNS::LoadingNS::DependencyList(FtpUploadSite) { FtpUploadDirectory NotEmpty ftp::Cd ftp::Close ftp::Open ftp::Type try}
set ::GenNS::LoadingNS::DependencyList(FtpWhichIsLarger) { IsEmpty ftp::FileSize}
set ::GenNS::LoadingNS::DependencyList(FtpWhichIsNewer) { IsEmpty ftp::ModTime}
set ::GenNS::LoadingNS::DependencyList(GenTestCommand1) { TestLoadingModuleNS::SampleCommand1}
set ::GenNS::LoadingNS::DependencyList(GenTestCommand2) { TestLoadingModuleNS::SampleCommand2}
set ::GenNS::LoadingNS::DependencyList(GenTestCommand3) { TestLoadingModuleNS::SampleCommand3}
set ::GenNS::LoadingNS::DependencyList(GetDbGlobal) { IsEmpty Q1 SqlRecordExists}
set ::GenNS::LoadingNS::DependencyList(Hhmmss2Seconds) { IsEmpty IsHhmmss StartsWith UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(IncrDbGlobal) { IsEmpty IsNonNumeric Q1 SetDbGlobal SqlRecordExists}
set ::GenNS::LoadingNS::DependencyList(IsNegative) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(IsNonNegative) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(IsNonNumeric) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(IsNonPositive) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(IsNonZero) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(IsNumeric) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(IsPositive) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(IsValidListIndex) { IsNegative}
set ::GenNS::LoadingNS::DependencyList(IsZero) { IsNonNumeric}
set ::GenNS::LoadingNS::DependencyList(LappendIfNotAlready) { UpvarX}
set ::GenNS::LoadingNS::DependencyList(LastId) { IsEmpty Q1}
set ::GenNS::LoadingNS::DependencyList(LimitLineLengthInFile) { ::textutil::adjust::adjust File2List IsEmpty IsNonPositive List2File}
set ::GenNS::LoadingNS::DependencyList(LinkTclVariableToRegistryValue) { IsEmpty RegistryExists ToDoubleBackslashes UpdateRegistryValue UpvarX registry}
set ::GenNS::LoadingNS::DependencyList(LinkVarToDbGlobal) { IsEmpty SetDbGlobal UpdateDbGlobal UpvarX}
set ::GenNS::LoadingNS::DependencyList(List2File) { try}
set ::GenNS::LoadingNS::DependencyList(ListRemoveAt) { IsEmpty IsNonNumeric IsNonPositive UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Mash) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Matrix2HtmlTable) { IsMatrix}
set ::GenNS::LoadingNS::DependencyList(MultiSet) { UpvarX}
set ::GenNS::LoadingNS::DependencyList(MultiplyBy) { IsEmpty IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(MultiplyHhmmss) { Hhmmss2Seconds IsEmpty IsHhmmss IsNonNumeric Seconds2Hhmmss UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Prepend) { UpvarX}
set ::GenNS::LoadingNS::DependencyList(PrintDict) { IsDict Ter}
set ::GenNS::LoadingNS::DependencyList(PrintMatrix) { IsEmpty IsMatrix IsNonNumeric IsNonPositive NotEmpty}
set ::GenNS::LoadingNS::DependencyList(PrintVar) { IsEmpty UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Q1) { FirstOf IsEmpty sqlite3}
set ::GenNS::LoadingNS::DependencyList(QQ) { IsEmpty sqlite3}
set ::GenNS::LoadingNS::DependencyList(Raise) { IsPositive UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(RegistryExists) { IsEmpty registry}
set ::GenNS::LoadingNS::DependencyList(RegistryPrint) { PrintDict RegistryExists RegistryTree2Dict registry}
set ::GenNS::LoadingNS::DependencyList(RegistryTree2Dict) { IsEmpty RegistryExists registry}
set ::GenNS::LoadingNS::DependencyList(ReloadPackage) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(RestoreIfExists) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(RestoreWorkingDirectory) { NotEmpty}
set ::GenNS::LoadingNS::DependencyList(RetZeroIfEmpty) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(Run) { try}
set ::GenNS::LoadingNS::DependencyList(RunSqlCreateTable) { IsEmpty QQ}
set ::GenNS::LoadingNS::DependencyList(RunSqlEnter) { IsEmpty LastId NotEmpty Q1 QQ RunSqlInsertIfDoesNotExist SqlInsertStatement SqlUpdateStatement SqlWhereClause}
set ::GenNS::LoadingNS::DependencyList(RunSqlInsertIfDoesNotExist) { IsEmpty LastId Q1 QQ SqlSelectStatement}
set ::GenNS::LoadingNS::DependencyList(Seconds2Hhmmss) { IsEmpty IsNonNumeric UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(SetDbGlobal) { GetDbGlobal IsEmpty RunSqlEnter}
set ::GenNS::LoadingNS::DependencyList(SetZeroIfEmpty) { IsEmpty UpvarX}
set ::GenNS::LoadingNS::DependencyList(SplitAndTrim) { NotEmpty UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(SplitNTimes) { Decr IsNonNumeric IsNonPositive}
set ::GenNS::LoadingNS::DependencyList(SqlCountStatement) { Coe IsEmpty SqlWhereClause}
set ::GenNS::LoadingNS::DependencyList(SqlInsertStatement) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(SqlRecordExists) { IsEmpty Q1 SqlCountStatement}
set ::GenNS::LoadingNS::DependencyList(SqlSelectStatement) { Coe IsEmpty SqlWhereClause}
set ::GenNS::LoadingNS::DependencyList(SqlSetClause) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(SqlUpdateStatement) { Coe IsEmpty SqlSetClause SqlWhereClause}
set ::GenNS::LoadingNS::DependencyList(SqliteColumnNameAndTypeList) { IsEmpty Q1 lvarpop}
set ::GenNS::LoadingNS::DependencyList(SqliteColumnNameList) { IsEmpty Q1}
set ::GenNS::LoadingNS::DependencyList(SqliteColumnType) { IsEmpty SqliteColumnNameAndTypeList}
set ::GenNS::LoadingNS::DependencyList(SqliteCopyTable) { IsEmpty QQ RunSqlCreateTable SqliteColumnNameAndTypeList SqliteTableExists}
set ::GenNS::LoadingNS::DependencyList(SqliteRenameColumn) { IsEmpty QQ RunSqlCreateTable SqliteColumnNameAndTypeList SqliteTableExists}
set ::GenNS::LoadingNS::DependencyList(SqliteTableExists) { IsEmpty Q1}
set ::GenNS::LoadingNS::DependencyList(StartsAndEndsWith) { EndsWith StartsWith}
set ::GenNS::LoadingNS::DependencyList(String2File) { try}
set ::GenNS::LoadingNS::DependencyList(StringInsert) { IsEmpty IsNegative IsNonNumeric IsPositive Ter UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(StringMid) { IsNonNumeric IsNonPositive}
set ::GenNS::LoadingNS::DependencyList(SubtractFrom) { IsEmpty IsNonNumeric SetZeroIfEmpty UpvarX}
set ::GenNS::LoadingNS::DependencyList(SumHhmmss) { AddTo Hhmmss2Seconds IsHhmmss Seconds2Hhmmss}
set ::GenNS::LoadingNS::DependencyList(SurroundEach) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(Swap) { UpvarX}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsAfter) { IsTimeOfDay TimeOfDay2Seconds}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsAt) { IsTimeOfDay}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsAtOrAfter) { TimeOfDay2Seconds TimeOfDayIsBefore}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsAtOrBefore) { TimeOfDay2Seconds TimeOfDayIsAfter}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsBefore) { IsTimeOfDay TimeOfDay2Seconds}
set ::GenNS::LoadingNS::DependencyList(TimeOfDayIsBetween) { IsTimeOfDay TimeOfDay2Seconds}
set ::GenNS::LoadingNS::DependencyList(ToBackslashes) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(ToDoubleBackslashes) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(ToForwardSlashes) { UpvarExistingOrDie}
set ::GenNS::LoadingNS::DependencyList(UnlinkTclVariableFromRegistryValue) { IsEmpty ToDoubleBackslashes registry}
set ::GenNS::LoadingNS::DependencyList(UnlinkVarFromDbGlobal) { IsEmpty}
set ::GenNS::LoadingNS::DependencyList(UnsetDbGlobal) { IsEmpty QQ}
set ::GenNS::LoadingNS::DependencyList(UpvarExistingOrDie) { IsEmpty VarExistsInCaller}
set ::GenNS::LoadingNS::DependencyList(UpvarX) { IsEmpty NotEmpty VarExistsInCaller}
set ::GenNS::LoadingNS::DependencyList(VarExistsInCaller) { IsEmpty}
