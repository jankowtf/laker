# fs_create_symlink <- function(
#     original = "layer_00",
#     symlink = "00_Data"
# ) {
#     command <- stringr::str_glue("ln -s ~/data/dbt-def-datalake/{original} ~/Code/upskill/ds4b.201/{symlink}")
#     message(command)
#     system(command)
# }

# https://itectec.com/unixlinux/bash-create-symlink-overwrite-if-one-exists/
#' Create symlinc
#'
#' @param original ([character]) Path to original directory to symlink.
#' @param symlink ([character]) Path to directory to use as symlink.
#' @param subdirs ([logical]) Link subdirectories of `original` into `symlink`
#'   (`TRUE`) or link `original` itself into `symlink` (FALSE)?
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' fs_create_symlink(
#'     original = "~/data/dev/",
#'     symlink = "data/"
#' )
#' }
fs_create_symlink <- function(
    original = "~/data/dev/",
    symlink = "data/",
    subdirs = TRUE
) {
    # command <- "ln -s ~/data/dbt-def-datalake/{original} ~/Code/upskill/ds4b.201/{symlink}" %>%
    #     stringr::str_glue()

    if (!(original %>% fs::dir_exists())) {
        "Original data lake directory does not exist: {original}" %>%
            clix::throw_error()
    }

    # symlink %>% fs::path_dir() %>% clix::ask_dir_create()
    symlink %>% clix::ask_dir_create()

    if (!subdirs) {
        command <- "ln -s {original} {symlink}" %>%
            stringr::str_glue()
    } else {
        dirs <- original %>% fs::dir_ls(type = "directory")
        command <- "ln -s {dirs} {symlink}" %>%
            stringr::str_glue()
    }

    cli::cli_alert_success(command)

    command %>% purrr::walk(system)
    # system(command)

    cli::cli_alert_success("Symlink created")
}

#' Handle file path for read methods
#'
#' Testing lists:
#' * TRUE: File must exist
#' * FALSE: File does not have to exist
#'
#' @param con ([ANY])3 Connection object
#' @param from ([character])3 File path
#' @param strict ([logical])3 [TRUE]: File must exist | [FALSE]: File does not
#'   have to exist
#'
#' @return
#'
#' @examples
#' try(fs_handle_read_path(con_fs_csv("test.csv")))
#' fs_handle_read_path(con_fs_xls("test.xls"), strict = FALSE)
#' fs_handle_read_path(con_fs_xlsx("test.xlsx"), strict = FALSE)
#' fs_handle_read_path(con_fs_rds("test.Rds"), strict = FALSE)
#' fs_handle_read_path(con_fs_arrow("test.arrow"), strict = FALSE)
fs_handle_read_path <- function(
    con = character(),
    strict = TRUE
) {
    # Input handling
    if (!length(con)) {
        logger::log_error("Argument 'con' has length zero, returning empty tibble")
        return(tibble::tibble())
    }

    # Log
    logger::log_trace("Reading from <data-lake>/{con %>% fs::path_file()}")

    # Assert that file exists
    if (strict) {
        assertthat::assert_that(
            fs::file_exists(con),
            msg = "Path does not exist: {con}" %>% stringr::str_glue()
        )
    }

    con
}
