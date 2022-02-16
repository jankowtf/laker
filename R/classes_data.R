# data -------------------------------------------------------------------

#' Constructor
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' (x <- data(tibble::tibble(x = 1)))
#' x %>% class()
data <- function(x = tibble::tibble()) {
    x %>%
        new_data() %>%
        validate_data()
}

#' Internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_data(tibble::tibble(x = 1)))
#' x %>% class()
new_data <- function(x) {
    x %>%
        structure(class = construct_class_path(., "data", prefix = FALSE))
}

#' Validator for internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_data <- function(x) {
    stopifnot("Expecting 'tbl' or 'data.frame'" = inherits(x, "data.frame"))
    x
}

# data_tableau_global_superstore ------------------------------------------

#' Constructor
#'
#' @param con ([con_])
#' @param from ([character])
#'
#' @return
#' @export
#'
#' @examples
#' x <- con_fs_arrow() %>%
#'   con_add_path(valid_data_layers("02")) %>%
#'   data_tableau_superstore()
#' x %>% dplyr::glimpse()
#' x %>% class()
# data_tableau_global_superstore <- function(
#     con = con_fs_arrow(),
#     from = character()
# ) {
#     constructor <- new_data_tableau_global_superstore
#
#     # Querying source from data catalog
#     from <- catalog_get_source(
#         con = con,
#         constructor = constructor,
#         from = from
#     )
#
#     con %>%
#         con_read(from = from) %>%
#         constructor() %>%
#         validate_data_tableau_superstore()
# }
data_tableau_global_superstore <- function(
    layer = valid_data_layers("03"),
    version = "v1",
    from = character()
) {
    constructor <- new_data_tableau_global_superstore

    # Querying file name from data catalog
    from <- catalog_get_path(
        layer = layer,
        version = version,
        constructor = constructor,
        path = from
    )

    # Connection constructor
    con <- from %>% factory_con()

    con() %>%
        con_read() %>%
        constructor() %>%
        validate_data_tableau_global_superstore()
}

#' Internal constructor
#'
#' Take class path of [new_data_tableau] and add prefixed subclass `base`.
#'
#' @param x
#'
#' @return
#'
#' @examples
#' (x <- new_data_tableau_superstore(tibble::tibble(x = 1)))
#' x %>% class()
new_data_tableau_global_superstore <- function(x = tibble::tibble()) {
    x %>%
        new_data() %>%
        structure(class = construct_class_path(., "tableau_global_superstore"))
}

#' Validator internal constructor
#'
#' @param x
#'
#' @return
#'
#' @examples
validate_data_tableau_global_superstore <- function(x) {
    validate_data(x)
}

#' Query layer path in data entity in data catalog
#'
#' @param layer ([character]) Data layer
#' @param version ([character]) Version of data entity
#'
#' @return
catalog_tableau_global_superstore <- function(
    layer = character(),
    version = character()
) {
    id <- "tableau_global_superstore"
    id %>%
        catalog_entity_path(
            layer = layer,
            bucket = id,
            version = version
        )
}

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
factory_constructor_internal <- function(x) {
    # Get file extension
    class <- x %>% extract_class_attribute()

    # Compose catalog function name
    fn <- "new_{class}" %>%
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

# Helpers -----------------------------------------------------------------

capture_data_class <- function(data, drop_prefix = FALSE) {
    .Deprecated("extract_class_attribute")

    data %>%
        class() %>%
        dplyr::first() %>%
        {
            if (drop_prefix) {
                stringr::str_remove(., "^data_")
            } else {
                .
            }
        }
}

#' Construct class path
#'
#' @param x [ANY]
#' @param subclass [character] Name of desired subclass. Can be a vector of
#'   length > 1
#' @param prefix [logical]
#' - `TRUE` (default): `subclass` is prefixed with first element of class path of `x`
#' - `FALSE`: `subclass` becomes stand-alone entity within class path
#'
#' @return
#'
#' @importFrom stringr str_c
#' @export
#'
#' @example inst/examples/ex-construct_class_path.R
construct_class_path <- function(
    x,
    subclass,
    prefix = TRUE,
    sep = "_"
) {
    # unique(c(
    #     ifelse(
    #         prefix,
    #         stringr::str_c(class(x)[[1]], "_", subclass),
    #         subclass
    #     ),
    #     class(x)
    # ))

    # Necessary for vector input of 'subclass'
    unique(c(
        if (prefix) {
            stringr::str_c(class(x)[[1]], "_", subclass)
        } else {
            subclass
        },
        class(x)
    ))
}

#' Restore class information
#'
#' @param data
#' @param to
#'
#' @return Object with identical class path as `to`
#'
#' @importFrom vctrs vec_restore
#' @examples
restore_class <- function(data, to) {
    data %>%
        vctrs::vec_restore(to)
}

capture_data_lake_layer <- function(con) {
    # con %>%
    #     fs::path_file() %>%
    #     stringr::str_remove("^\\d+_")
    layers <- valid_data_layers() %>% unname()
    index <- con %>% stringr::str_detect(layers)
    layer <- layers[index]

    stopifnot("Unable to capture data lake layer" = length(layer) > 0)

    layer %>% stringr::str_remove("(?<=\\d{2}).*")
}

# BREAK -------------------------------------------------------------------

# Add ---------------------------------------------------------------------

#' Add path components to connection object
#'
#' @param con
#' @param path
#'
#' @return
#' @export
#'
#' @examples
con_add_path <- function(con, path) {
    # Add path
    out <- con %>%
        fs::path(path)

    # Restore class information
    vctrs::vec_restore(out, con)
}

#' Add class information to connection object
#'
#' @param con
#' @param class_fn
#'
#' @return
#' @export
#'
#' @examples
con_add_class <- function(con, class_fn = new_con_fs_arrow) {
    # Add class
    con %>%
        class_fn()
}

# Handle ------------------------------------------------------------------

#' Handle read result
#'
#' @param result
#'
#' @return
#' @export
#'
#' @examples
handle_read_result <- function(result) {
    # Log
    if (!inherits(result, "try-error")) {
        logger::log_success("Read succeeded")
    } else {
        logger::log_error("Read failed")
        return(tibble::tibble())
    }
}

handle_read_limit <- function() {
    result <- if (length(limit)) {
        result %>%
            dplyr::slice(1:limit)
    } else {
        result
    }
}

handle_input_column_name <- function(x, force_list = FALSE) {
    # try_res <- try(x, silent = TRUE)
    # if (inherits(try_res, "try-error")) {
    #   x <- rlang::enquo(x)
    # }
    # TODO-20201221-2053: Find "one size fits all" solutions for handling
    # different input formats (string, symbol, quo/enquo)

    if (force_list) {
        return(rlang::syms(x))
    }

    if (length(x) == 1) {
        rlang::sym(x)
    } else {
        rlang::syms(x)
    }
}



