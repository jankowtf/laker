# Write -------------------------------------------------------------------

#' Write data to connection (generic)
#'
#' @param data
#' @param con
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
con_write <- function(data, con, ...) {
    UseMethod("con_write", con)
}

#' Write data to connection
#'
#' @param data
#' @param con
#' @param to ([character]) Optional overwrite of destination. Not recommended!
#' @param group_by
#' @param ...
#' @param layer
#' @param version
#' @param constructor
#'
#' @return
#' @export
#'
#' @examples
con_write.con_fs_arrow <- function(
    data,
    con,
    layer,
    version,
    constructor,
    to = character(),
    group_by = list(),
    ...
) {
    # Input handling
    group_by <- handle_input_column_name(group_by, force_list = TRUE)
    data_orig <- data

    # Querying path from data catalog
    # to <- catalog_get_path(
    #     layer = layer,
    #     version = version,
    #     constructor = constructor,
    #     path = to
    # )

    # Log
    logger::log_trace("Writing to <data-lake>/{con %>% fs::path_file()}")

    # Assert that bucket exists
    # assertthat::assert_that(fs::file_exists(path))
    # TODO-20201221-1952: Should non-existing buckets fail for writes? Possibly
    # add 'strict' argument?

    # Ensure that bucket exists
    path <- con %>%
        fs::path_dir()
    path %>%
        fs::dir_create(recurse = TRUE)

    # Actual write
    data <- data %>% arrow::Table$create()
    if (FALSE) {
        # NOTE-20201221-2143: This a) doesn't fully work and b) is much to much
        # overhead for dealing with columns containing empty columns which are
        # supposed to become grouping columns for arrow. Either find a better
        # solution or do without grouping all together

        # Create explicit group var(s) and ensure they are not empty
        data_handled <- data %>%
            handle_grouping_columns_for_arrow_in_data(
                group_by = group_by
            )

        group_by_handled <- group_by %>%
            handle_grouping_columns_for_arrow_in_columns()

        # Split data and write subsets as arrow files
        data_handled %>%
            dplyr::group_by(!!!group_by_handled) %>%
            arrow::write_dataset(path, format = "arrow")
    }

    # If 'group_by' info is available then group, otherwise write to single entity
    if (!length(group_by)) {
        data %>%
            arrow::write_dataset(path, format = "arrow")
        try_res <- NULL
    } else {
        try_res <- try(
            data %>%
                dplyr::group_by(!!!group_by) %>%
                arrow::write_dataset(path, format = "arrow"),
            silent = TRUE
        )
    }

    # Try again without grouping
    if (inherits(try_res, "try-error")) {
        data %>%
            arrow::write_dataset(path, format = "arrow")
    }

    # Assert successful write
    # Ensure that content was created (is also return value)
    # data_handled %>%
    #   assert_arrow_write_success(
    #     group_by = group_by_handled,
    #     path = path
    #   )

    data_orig %>%
        assert_arrow_write_success(
            group_by = group_by,
            path = path
        )

}
