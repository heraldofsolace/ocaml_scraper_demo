open Lwt
open Cohttp_lwt_unix
open Soup

let body =
  Client.get (Uri.of_string "http://quotes.toscrape.com/") >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >|= parse
    
let () =
  let body = Lwt_main.run body in
    let quotes = body $$ ".quote" in
    quotes
    |> iter (fun quote ->
      let text = quote $ ".text" |> R.leaf_text |> String.trim in
      let author = quote $ ".author" |> R.leaf_text |> String.trim in
        Printf.printf "%s - %s\n" text author
      );
    let first_quote = body $ ".quote:first-child .text" |> R.leaf_text |> String.trim in 
    Printf.printf "First quote: %s\n" first_quote