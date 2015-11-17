namespace eval ::GenNS::LoadingNS {
     
array set ::GenNS::LoadingNS::DependencyList {}
array set ::GenNS::LoadingNS::DependentsList {}
set ::GenNS::LoadingNS::PackageReadyList {}
set ::GenNS::LoadingNS::SourceReadyList {}

proc FindAllDistinctDependentsOn Command {
     set OutList {}
     if {[info exists GenNS::LoadingNS::DependentsList($Command)]} {          
          foreach Dependent $::GenNS::LoadingNS::DependentsList($Command) {
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

proc PrintStatusForPackage {PackageName} {
     # Find the version loaded, if any.
     set PackageVersionFound $::GenNS::LoadingNS::PackageVersionFound($PackageName)
     if {$PackageVersionFound != -1} {
          puts "Loaded package $PackageName, v[set PackageVersionFound]"
     } else {
          puts "Could not find package $PackageName"
     }
     set Flag 0
     # Find the commands in the package.     
     # For each of those commands, find out if any commands dependent on it were not loaded.
     foreach Element $::GenNS::LoadingNS::CommandsInPackage($PackageName) {
          lassign $Element Command Version
          if {![info exists ::GenNS::LoadingNS::DependentsList($Command)]} {
               continue
          }          
          foreach Dependent $::GenNS::LoadingNS::DependentsList($Command) {
               if {[lsearch $::GenNS::LoadingNS::CommandLoadedList $Dependent] == -1} {
                    if {$Flag == 0} {
                         puts "     The following commands were not loaded:"
                         set Flag 1
                    }
                    # For each of those, print out that it was not loaded, and what version number is needed.
                    puts "          $Dependent -- wants v[set Version]"
                    # Print out a recursion tree of commands dependent on it.
                    # TBD
               }
          }
     }
}

proc PrintDependenciesNotFoundForCommand {CommandName {Indentation "     "}} {
     # Find the list of dependencies.
     set CommandDependencies $::GenNS::LoadingNS::DependencyList($CommandName)
     foreach Dependency $CommandDependencies {
          # For each dependency, check whether it was loaded.
          if {[lsearch ::GenNS::LoadingNS::CommandLoadedList $Dependency] == -1} {
               if {[lsearch [array names ::GenNS::LoadingNS::DependencyList] $Dependency] != -1} {
                    # If not loaded, and it is a Gen command,
                    # then print it out and recurse.
                    puts "[set Indentation]command [set Dependency]"
                    append Indentation "     "
                    PrintDependenciesNotFoundForCommand $Dependency $Indentation
               } else {
                    # If not loaded, and it is a package command,
                    # then find the package version needed,
                    # and the package version found,
                    # and print out that information.
                    set Flag 0
                    foreach PackageName [array names ::GenNS::LoadingNS::CommandsInPackage] {
                         foreach Element $::GenNS::LoadingNS::CommandsInPackage($PackageName) {
                              lassign $Element Command Version
                              if {$Command eq $Dependency} {
                                   set Flag 1
                                   set PackageVersionNeeded $Version
                                   break
                              }
                         }
                         if {$Flag == 1} {
                              break
                         }
                    }
                    set PackageVersionFound $::GenNS::LoadingNS::PackageVersionFound($PackageName)
                    puts "[set Indentation]package [set PackageName]"
                    if {$PackageVersionFound == -1} {
                         puts "     [set Indentation]NOT LOADED"
                    } else {
                         puts "     [set Indentation]Have v[set PackageVersionFound]"
                    }
                    puts "     [set Indentation]Need v[set PackageVersionNeeded]"
               }
          }
     }
}

proc DoLoading {} {
     array set ::GenNS::LoadingNS::PackageVersionFound {}     
     set ::GenNS::LoadingNS::ReadyList {}
     set ::GenNS::LoadingNS::MissingPackageList {}
     set ::GenNS::LoadingNS::CommandLoadedList {}
     set ::GenNS::LoadingNS::CommandNotLoadedList {}

     # PHASE ONE
     # ---------
     # First try to load all the packages.
     # For each package loaded, find all the commands within it,
     # for each command within the package, find all Gen commands dependent on it,
     # remove the package command from the dependency list.
     # If the Gen command has no more outstanding dependencies,
     # put it on a list of command to be loaded in the next phase.
     while {[llength $::GenNS::LoadingNS::PackageReadyList] > 0} {
          # Pop the next package off the ready list
          set CurrentPackage [lindex $::GenNS::LoadingNS::PackageReadyList 0]
          set ::GenNS::LoadingNS::PackageReadyList [lreplace $::GenNS::LoadingNS::PackageReadyList 0 0]
          # Try to load package.
          if {[catch {package require $CurrentPackage} PackageVersion]} {
               # If it failed to load, put it on a list of missing packages.
               # We will follow up with diagnostics/warnings in the last phase.
               # For now, continue on to the next package.
               lappend ::GenNS::LoadingNS::MissingPackageList $CurrentPackage
               set ::GenNS::LoadingNS::PackageVersionFound($CurrentPackage) -1
               continue
          }
          set ::GenNS::LoadingNS::PackageVersionFound($CurrentPackage) $PackageVersion
          # Package successfully loaded. Find all commands in it that will be used.
          foreach Element $::GenNS::LoadingNS::CommandsInPackage($CurrentPackage) {
               lassign $Element Command MinimumVersion
               # Get the minimum version needed for the command to be loaded.
               # Check the minimum package version needed for the command to be loaded.
               if {[package vcompare $PackageVersion $MinimumVersion] == -1} {
                    # Package version is less than the minimum version for this command.
                    # So the command is not loaded.
                    continue
               }

               # Look up commands dependent on it.
               if {![info exists ::GenNS::LoadingNS::DependentsList($Command)]} {
                    continue
               }
               
               foreach DependentCommand $::GenNS::LoadingNS::DependentsList($Command) {
                    # Remove it from their dependency list.
                    set Index [lsearch $::GenNS::LoadingNS::DependencyList($DependentCommand) $Command]
                    set ::GenNS::LoadingNS::DependencyList($DependentCommand) [lreplace $::GenNS::LoadingNS::DependencyList($DependentCommand) $Index $Index]
                    
                    # If now empty, no more dependencies, so put it on source ready list.
                    # Will try to load it in the next phase.
                    if {[llength $::GenNS::LoadingNS::DependencyList($DependentCommand)] == 0} {
                         lappend ::GenNS::LoadingNS::SourceReadyList $DependentCommand
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
     set CommandsWithDependents [array names ::GenNS::LoadingNS::DependentsList]
     if {$GenNS::PutGenCommandsInNamespace == 1} {
          set NamespaceToUse "::[set GenNS::GenNamespaceName]"
     } else {
          set NamespaceToUse ::
     }     
     # Keep popping commands off the ready list until it is empty.
     while {[llength $::GenNS::LoadingNS::SourceReadyList] > 0} {
          # Pop next command to source off the ready list.
          set CurrentSource [lindex $::GenNS::LoadingNS::SourceReadyList 0]
          set ::GenNS::LoadingNS::SourceReadyList [lreplace $::GenNS::LoadingNS::SourceReadyList 0 0]
          # Try to load, should always succeed.
          set FileName "$::PackageRoot/[string tolower [join $CurrentSource ""]].tcl"
          set Command {namespace eval $NamespaceToUse {source \"$FileName\"}}
          # puts "Command is [subst $Command]"
          if {[catch [subst $Command]]} {
               puts "Failed to source $FileName"
          } else {
               if {($::GenNS::PutGenCommandsInNamespace == 1) && ($::GenNS::ImportGenCommandsIntoGlobalNamespace == 1)} {
                    namespace eval $NamespaceToUse "namespace export $CurrentSource"
                    namespace eval :: [subst {namespace import "::[set GenNS::GenNamespaceName]::[set CurrentSource]"}]
               }
               lappend ::GenNS::LoadingNS::CommandLoadedList $CurrentSource
               # Successfully loaded. Find all commands dependent on it.
               if {[lsearch $CommandsWithDependents $CurrentSource] != -1} {
                    foreach DependentCommand $::GenNS::LoadingNS::DependentsList($CurrentSource) {
                         # Remove it from their dependency list.
                         set Index [lsearch $::GenNS::LoadingNS::DependencyList($DependentCommand) $CurrentSource]
                         set ::GenNS::LoadingNS::DependencyList($DependentCommand) [lreplace $::GenNS::LoadingNS::DependencyList($DependentCommand) $Index $Index]
                         # If now empty, no more dependencies, 
                         # put command on source ready list so it can be loaded also.
                         if {[llength $::GenNS::LoadingNS::DependencyList($DependentCommand)] == 0} {
                              lappend ::GenNS::LoadingNS::SourceReadyList $DependentCommand
                         }
                    }
               }
          }
     }
     
     # PHASE THREE
     # -----------
     # Report on each package,
     # tell if it was loaded, what version loaded,
     # and what commands were needed it, but could not be loaded.
     if {$GenNS::ReportOnPackagesLoaded} {
          puts "\nPACKAGE LOAD REPORT"
          puts "-------------------"
          foreach PackageName [array names ::GenNS::LoadingNS::CommandsInPackage] {
               PrintStatusForPackage $PackageName
          }
          puts "\n"
     }
     # Likewise, go through by commands, and list out those not loaded, and why.
     if {$GenNS::WarnOnFailureToLoadCommand} {
          puts "\nCOMMANDS NOT LOADED"
          puts "-------------------"
          set Flag 0
          foreach CommandName [array names ::GenNS::LoadingNS::DependencyList] {
               if {[lsearch $::GenNS::LoadingNS::CommandLoadedList $CommandName] == -1} {
                    puts $CommandName
                    set Flag 1
               }
          }          
          if {$Flag == 0} {
               puts "All commands were loaded.\n"
          } else {
               puts "\n\nTo find out why a command was not loaded,\nsimply type in the name of the command into the terminal."
          }
     }
     
     # PHASE FOUR
     # ----------
     # For each command not loaded,
     # make a proc with its name.
     # Make that proc print out the missing dependencies,
     # and raise an error.
     foreach CommandName [array names GenNS::LoadingNS::DependencyList] {
          if {[lsearch $::GenNS::LoadingNS::CommandLoadedList $CommandName] == -1} {
               set Proc "proc $CommandName {args} {\n      ::GenNS::LoadingNS::PrintDependenciesNotFoundForCommand $CommandName\n\n     error \"Command $CommandName was not loaded\"\n}"
               eval [subst {namespace eval $NamespaceToUse {$Proc}}]
               if {$GenNS::PutGenCommandsInNamespace == 1} {
                    namespace eval $NamespaceToUse "namespace export $CommandName"
                    namespace eval :: [subst {namespace import "::[set GenNS::GenNamespaceName]::[set CommandName]"}]
               }
          }
     }
}



}

