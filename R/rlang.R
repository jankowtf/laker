#' Compose function call
#'
#' @param fn ([character]) Function name
#' @param args ([list]) List of arguments
#'
#' @return
#'
#' @examples
#' foo <- function(x, y) x + y
#' call <- compose_fn_call("foo", list(x = 1, y = 1))
#' eval(call)
compose_fn_call <- function(fn, args) {
    rlang::call2(
        fn,
        !!!args
    )
}

#' Curry function
#'
#' @param body Function body
#'
#' @return
#'
#' @examples
#' foo <- function(x, y) x + y
#' call <- compose_fn_call("foo", list(x = 1, y = 1))
#' fn <- call %>% curry_fn()
#' fn()
curry_fn <- function(body) {
    fn <- function() {}
    rlang::fn_body(fn) <- body
    fn
}
