proc IsDict StringValue {

          if {![catch {dict size $StringValue}]} {
               return 1
          } else {
               return 0
          }
}