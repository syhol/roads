
let main () =
  let len = Array.length Sys.argv in
  if len <= 1 then (
    print_endline "Failure 2" ;
    exit 1
  ) else (
    print_endline "Success 2" ;
    Roads.do_something () ;
    match Sys.argv.(1) with
      | "build" -> print_endline "Building"
      | "run" -> print_endline "Running"
      | _ -> print_endline "Command not found"
  )

let () = main ()
