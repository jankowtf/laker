# https://adv-r.hadley.nz/s3.html

# Factories ---------------------------------------------------------------

#' Factory for con constructor
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' fn <- "test.xlsx" %>% factory_con()
#' (con <- fn())
#' con %>% class()
factory_con <- function(x) {
    # Get file extension
    ext <- x %>% fs::path_ext()

    if (!length(ext) | ext == "") {
        clix::throw_error("Could not identify file extension: {x}")
    }

    # Compose catalog function name
    fn <- "con_fs_{ext}" %>%
        stringr::str_glue()

    # Assert existence
    assert_function_exists(fn)

    # Compose function call
    call <- compose_fn_call(
        fn = fn,
        args = list(
            x = x
        )
    )

    # Return curried function
    call %>% curry_fn()
}

# con_fs ------------------------------------------------------------------

#' Constructor
#'
#' @param x ([con_fs]) File system path that inherits from [con_fs]
#'
#' @return
#' @export
#'
#' @rdname con_fs
#' @examples
#' (x <- con("a/b/c"))
#' x %>% class()
con_fs <- function(x = getwd()) {
    x %>%
        # Ensure path structure
        fs::path() %>%
        new_con_fs() %>%
        validate_con_fs()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs("a/b/c"))
#' x %>% class()
new_con_fs <- function(x) {
    x %>%
        structure(class = construct_class_path(., "con_fs", prefix = FALSE))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs <- function(x) {
    stopifnot("Expecting 'character'" =  inherits(x, "character"))
    x
}

# CSV (con_fs_csv) --------------------------------------------------------

#' Constructor
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' (x <- con_fs_csv("a/b/c"))
#' x %>% class()
con_fs_csv <- function(x = env_data_lake()) {
    x %>%
        new_con_fs_csv() %>%
        validate_con_fs_csv()
}

#' Internal constructor
#'
#' @param x ([con_fs]) File system path that inherits from [con_fs]
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs_csv("a/b/c"))
#' x %>% class()
new_con_fs_csv <- function(x) {
    x %>%
        new_con_fs() %>%
        structure(class = construct_class_path(., "csv"))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs_csv <- function(x) {
    validate_con_fs(x)

    ext <- x %>% fs::path_ext()
    if (!(ext %>% stringr::str_detect("[cC][sS][vV]$"))) {
        msg <-
            "Expecting file type '.csv' (received: {x %>% fs::path_ext()})" %>%
            stringr::str_glue()
        stop(msg)
    }

    x
}

# XLSX (con_dl_xlsx) ------------------------------------------------------

#' Constructor
#'
#' @param x ([con_fs]) File system path that inherits from [con_fs]
#'
#' @return
#' @export
#'
#' @examples
#' (x <- con_fs_xlsx("a/b/c"))
#' x %>% class()
con_fs_xlsx <- function(x = env_data_lake()) {
    x %>%
        new_con_fs_xlsx() %>%
        validate_con_fs_xlsx()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs_xlsx("a/b/c"))
#' x %>% class()
new_con_fs_xlsx <- function(x) {
    x %>%
        new_con_fs() %>%
        structure(class = construct_class_path(., "xlsx"))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs_xlsx <- function(x) {
    validate_con_fs(x)

    ext <- x %>% fs::path_ext()
    if (!(ext %>% stringr::str_detect("[xX][lL][sS][xX]$"))) {
        msg <-
            "Expecting file type '.xlsx' (received: {x %>% fs::path_ext()})" %>%
            stringr::str_glue()
        stop(msg)
    }

    x
}

# XLS (con_dl_xls) --------------------------------------------------------

#' Constructor
#'
#' @param x ([con_fs]) File system path that inherits from [con_fs]
#'
#' @return
#' @export
#'
#' @examples
#' (x <- con_fs_xls("a/b/c"))
#' x %>% class()
con_fs_xls <- function(x = env_data_lake()) {
    x %>%
        new_con_fs_xls() %>%
        validate_con_fs_xls()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs_xls("a/b/c"))
#' x %>% class()
new_con_fs_xls <- function(x) {
    x %>%
        new_con_fs() %>%
        structure(class = construct_class_path(., "xls"))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs_xls <- function(x) {
    validate_con_fs(x)

    ext <- x %>% fs::path_ext()
    if (!(ext %>% stringr::str_detect("[xX][lL][sS]$"))) {
        msg <-
            "Expecting file type '.xls' (received: {x %>% fs::path_ext()})" %>%
            stringr::str_glue()
        stop(msg)
    }

    x
}

# Rds (con_fs_rds) --------------------------------------------------------

#' Constructor
#'
#' @param x ([con_fs]) File system path that inherits from [con_fs]
#'
#' @return
#' @export
#'
#' @examples
#' (x <- con_fs_rds("a/b/c"))
#' x %>% class()
con_fs_rds <- function(x = env_data_lake()) {
    x %>%
        new_con_fs_rds() %>%
        validate_con_fs_rds()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs_rds("a/b/c"))
#' x %>% class()
new_con_fs_rds <- function(x) {
    x %>%
        new_con_fs() %>%
        structure(class = construct_class_path(., "rds"))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs_rds <- function(x) {
    validate_con_fs(x)

    ext <- x %>% fs::path_ext()
    if (!(ext %>% stringr::str_detect("[rR][dD][sS]$"))) {
        msg <-
            "Expecting file type '.rds' (received: {x %>% fs::path_ext()})" %>%
            stringr::str_glue()
        stop(msg)
    }

    x
}

# Arrow (con_fs_arrow) ----------------------------------------------------

#' Constructor
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' (x <- con_fs_arrow("a/b/c"))
#' x %>% class()
con_fs_arrow <- function(x = env_data_lake()) {
    x %>%
        new_con_fs_arrow() %>%
        validate_con_fs_arrow()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_con_fs_arrow("a/b/c"))
#' x %>% class()
new_con_fs_arrow <- function(x) {
    x %>%
        new_con_fs() %>%
        structure(class = construct_class_path(., "arrow"))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_con_fs_arrow <- function(x) {
    validate_con_fs(x)

    ext <- x %>% fs::path_ext()
    # if (!(ext %>% stringr::str_detect("[aA][rR][rR][oO][wW]$"))) {
    #     msg <-
    #         "Expecting file type '.arrow' (received: {x %>% fs::path_ext()})" %>%
    #         stringr::str_glue()
    #     stop(msg)
    # }
    # NOTE-20220216-1635:
    # From a dev perspective, arrow data is typically written to *directories*
    # rather than files. Thus I took this validity test out

    x
}
