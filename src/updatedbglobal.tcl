proc UpdateDbGlobal {VarName DbGlobalName args} {

     upvar #0 $VarName Var     
     SetDbGlobal $DbGlobalName $Var
}