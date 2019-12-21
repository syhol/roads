open Printf
open Unix

let do_something () =
  let unixtime = time () in
  printf "%.3f seconds have elapsed since 1970-01-01T00:00:00.\n%!"
    unixtime
