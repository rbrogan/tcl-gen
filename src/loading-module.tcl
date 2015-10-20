namespace eval GenLoadingNS {

array set DependencyList {}
array set DependentsList {}
set ReadyList {}
set PackageReadyList {}
set SourceReadyList {}
set MissingPackageList {}

proc FindAllDistinctDependentsOn Command {
     set OutList {}
     if {[info exists GenLoadingNS::DependentsList($Command)]} {          
          foreach Dependent $::GenLoadingNS::DependentsList($Command) {
               if {[lsearch $OutList $Dependent] == -1} {
                    lappend OutList $Dependent
                    set AddList [FindAllDistinctDependentsOn $Dependent]
                    foreach Element $AddList {
                         if {[lsearch $OutList $Element] == -1} {
                              lappend OutList $Element
                         }
                    }
               }
          }
     }
     
     return $OutList
}

proc DoLoading {} {
     set ::GenLoadingNS::MissingPackageList {}

     # PHASE ONE
     # ---------
     # First try to load all the packages.
     # For each package loaded, find all the commands within it,
     # for each command within the package, find all Gen commands dependent on it,
     # remove the package command from the dependency list.
     # If the Gen command has no more outstanding dependencies,
     # put it on a list of command to be loaded in the next phase.
     while {[llength $::GenLoadingNS::PackageReadyList] > 0} {
          # Pop the next package off the ready list
          set CurrentPackage [lindex $::GenLoadingNS::PackageReadyList 0]
          set ::GenLoadingNS::PackageReadyList [lreplace $::GenLoadingNS::PackageReadyList 0 0]
          # Try to load package.
          if {[catch {package require $CurrentPackage}]} {
               # If it failed to load, put it on a list of missing packages.
               # We will follow up with diagnostics/warnings in the last phase.
               # For now, continue on to the next package.
               lappend ::GenLoadingNS::MissingPackageList $CurrentPackage
               continue
          }
          # Package successfully loaded. Find all commands in it that will be used.
          foreach Command $::GenLoadingNS::CommandsInPackage($CurrentPackage) {
               # Look up commands dependent on it.
               foreach DependentCommand $::GenLoadingNS::DependentsList($Command) {
                    # Remove it from their dependency list.
                    set Index [lsearch $::GenLoadingNS::DependencyList($DependentCommand) $Command]
                    set ::GenLoadingNS::DependencyList($DependentCommand) [lreplace $::GenLoadingNS::DependencyList($DependentCommand) $Index $Index]
                    
                    # If now empty, no more dependencies, so put it on source ready list.
                    # Will try to load it in the next phase.
                    if {[llength $::GenLoadingNS::DependencyList($DependentCommand)] == 0} {
                         lappend ::GenLoadingNS::SourceReadyList $DependentCommand
                    }
               }
          }
     }
     
     # PHASE TWO
     # ---------
     # Try to load each command that has no more dependencies left outstanding.
     # Do it by sourcing the file with its name.
     # If successful (should always be), find all commands dependent on that command,
     # remove the freshly loaded command from their dependency list,
     # and if the dependency list is now empty, that command is now ready to be loaded,
     # so put it on the ready list.
     # Keep going until the ready list is empty.
     
     # Save a list of commands that have dependents, rather than look it up every time.
     set CommandsWithDependents [array names ::GenLoadingNS::DependentsList]
     # Keep popping commands off the ready list until it is empty.
     while {[llength $::GenLoadingNS::SourceReadyList] > 0} {
          # Pop next command to source off the ready list.
          set CurrentSource [lindex $::GenLoadingNS::SourceReadyList 0]
          set ::GenLoadingNS::SourceReadyList [lreplace $::GenLoadingNS::SourceReadyList 0 0]
          # Try to load, should always succeed.
          set FileName "$::PackageRoot/[string tolower [join $CurrentSource ""]].tcl"
          if {[catch {namespace eval :: "source \"$FileName\""}]} {
               puts "Failed to source $FileName"
          } else {
               # Successfully loaded. Find all commands dependent on it.
               if {[lsearch $CommandsWithDependents $CurrentSource] != -1} {
                    foreach DependentCommand $::GenLoadingNS::DependentsList($CurrentSource) {
                         # Remove it from their dependency list.
                         set Index [lsearch $::GenLoadingNS::DependencyList($DependentCommand) $CurrentSource]
                         set ::GenLoadingNS::DependencyList($DependentCommand) [lreplace $::GenLoadingNS::DependencyList($DependentCommand) $Index $Index]
                         # If now empty, no more dependencies, 
                         # put command on source ready list so it can be loaded also.
                         if {[llength $::GenLoadingNS::DependencyList($DependentCommand)] == 0} {
                              lappend ::GenLoadingNS::SourceReadyList $DependentCommand
                         }
                    }
               }
          }
     }
     
     # PHASE THREE
     # -----------
     # Show missing packages and affected commands.
     # If we are configured to print this out,
     # go through each package that did not load,
     # find all the commands that were in the package that we would have used,
     # then recursively find all distinct commands further dependent,
     # and build a list of all Gen commands that needed that package.
     # Print out a message saying that the package failed to load
     # and a list of all the commands that were affected.
     if {$GenNS::WarnOnFailureToLoadCommand} {
          foreach Package $::GenLoadingNS::MissingPackageList {
               set AffectedCommands {}
               foreach Command $::GenLoadingNS::CommandsInPackage($Package) {
                    lappend AffectedCommands {*}[FindAllDistinctDependentsOn $Command]
               }
               
               puts "Could not load package [set Package].\nThese commands cannot be used without package [set Package]: "
               foreach AffectedCommand $AffectedCommands {
                    puts "     $AffectedCommand"
               }
          }
     }
}



}

