proc Swap {VarNameA VarNameB} {

     UpvarX $VarNameA A
     UpvarX $VarNameB B
     set Temp $A
     set A $B
     set B $Temp
     return
}