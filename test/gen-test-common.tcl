proc CommandIsLoaded {CommandName} {
     if {[lsearch $::GenNS::LoadingNS::CommandLoadedList $CommandName] >= 0} {
          return 1
     } else {
          return 0
     }
}

proc CheckAllDependenciesLoaded {CommandName} {
     
     foreach CommandDependentOn $::GenNS::LoadingNS::DependencyList($CommandName) {
          if {![CommandIsLoaded $CommandDependentOn]} {
               return 0
          }
     }
     
     return 1
}
