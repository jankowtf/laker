assert_function_exists <- function(
    fn
) {
    call <- deparse(sys.call(-1))
    assertthat::assert_that(
        exists(fn),
        msg = "Invalid constructed function: {fn} (in {call})" %>%
            stringr::str_glue()
    )
}

#' Assert successful arrow write \lifecycle{experimental}
#'
#' @param data
#' @param group_by
#' @param path
#'
#' @return
#' @export
#'
#' @examples
assert_arrow_write_success <- function(
    data,
    group_by = list(),
    path
) {
    # TODO-20201221-1655: Ensure that arrow content was created in more robust and
    # efficient way. E.g., it's inefficient to duplicate the grouping. Also
    # timestamps aren't checked. Also it would currently fail for multiple group
    # by statements

    # Compose assert information
    if (length(group_by)) {
        keys <- data %>%
            dplyr::group_by(!!!group_by) %>%
            dplyr::group_keys() %>%
            dplyr::pull() %>%
            unique()

        group_by_chr <- group_by %>%
            purrr::map_chr(~.x %>% rlang::quo_name())

        dirs_assert <- "{path}/{group_by_chr}={keys}" %>%
            stringr::str_glue()
    } else {
        dirs_assert <- "{path}/part-0.arrow" %>%
            stringr::str_glue()
    }

    # List data lake content
    dirs <- path %>%
        fs::dir_ls()

    # Assert successful write
    result <- assertthat::assert_that(all(dirs_assert %in% dirs))

    if (result) {
        logger::log_success("Write succeeded")
    } else {
        logger::log_error("Writing failed")
    }

    # Return value
    path
}
