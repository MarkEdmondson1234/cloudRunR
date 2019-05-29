#' @get /hello
#' @html
function(){
  "<html><h1>hello world</h1></html>"
}

## run locally via
# pr <- plumber::plumb("schedule.R"); pr$run(port=8080)
