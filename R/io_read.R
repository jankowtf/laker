# Read --------------------------------------------------------------------

#' Read (generic)
#'
#' @param con
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
con_read <- function(con, ...) {
    UseMethod("con_read")
}

#' Read
#'
#' @param con
#'
#' @return
#' @export
con_read.con_fs_xls <- function(
    con = new_con_fs_xls(),
    select = character(),
    # from = character(),
    where = character(),
    limit = numeric(),
    fn_trans = identity
) {
    path <- con %>% fs_handle_read_path()

    # Read xls file
    result <- try(
        path %>%
            readxl::read_xls(
                n_max = ifelse(length(limit), limit, Inf)
            ),
        silent = TRUE
    )

    # Handle read result
    result %>% handle_read_result()

    # Transform
    out <- result %>% fn_trans()

    out
}

#' Read
#'
#' @param con
#'
#' @return
#' @export
#'
#' @examples
con_read.con_fs_rds <- function(
    con = new_con_fs_rds(),
    select = character(),
    # from = character(),
    where = character(),
    limit = numeric(),
    fn_trans = identity
) {
    # sql_(
    #   select = select,
    #   from = from,
    #   where = where,
    #   limit = limit
    # )

    # Input handling
    path <- con %>% fs_handle_read_path()

    # Read Rds file
    result <- try(
        path %>%
            readRDS(),
        silent = TRUE
    )

    # Handle read result
    result %>% handle_read_result()

    # Limit
    result <- if (length(limit)) {
        result %>%
            dplyr::slice(1:limit)
    } else {
        result
    }

    # Transform
    result <- result %>%
        fn_trans()

    result
}

#' Read
#'
#' @param con
#' @param select
#' @param from
#' @param where
#' @param limit
#' @param fn_trans
#' @param schema
#'
#' @return
#' @export
con_read.con_fs_arrow <- function(
    con = new_con_fs_rds(),
    select = character(),
    # from = character(),
    where = character(),
    limit = numeric(),
    fn_trans = identity,
    schema = NULL
) {
    # Input handling
    path <- con %>% fs::path_dir() %>% fs_handle_read_path()

    # Read arrow file
    result <- try(
        path %>%
            arrow::open_dataset(
                format = "arrow",
                schema = schema
            ) %>%
            dplyr::collect(),
        silent = TRUE
    )

    # Handle read result
    result %>% handle_read_result()

    # Limit
    result <- if (length(limit)) {
        result %>%
            dplyr::slice(1:limit)
    } else {
        result
    }

    # Transform
    result <- result %>% fn_trans()

    result
}

# Wrappers ----------------------------------------------------------------

#' Read from layer
#'
#' Convenience wrapper around call to [laker::con_read].
#'
#' @param constructor
#' @param version
#'
#' @return
#' @export
layer_read <- function(
    constructor,
    layer = valid_data_layers("02"),
    version = "v1"
) {
    # Curried constructor for reading
    fn <- purrr::partial(
        constructor,
        layer = layer,
        version = version
    )

    # Actual read
    data <- fn()
}

#' Read from tidy layer
#'
#' Convenience wrapper around `con` chain with suitable constructor
#'
#' @param con [connection] Arrow connection to data lake layer
#' @param constructor
#'
#' @return
#' @export
#'
#' @examples
read_tidy <- function(
    con = con_fs_arrow(),
    constructor
) {
    if (!(fs::path_file(con) %in% valid_data_layers("02"))) {
        con <- con %>%
            con_add_path(valid_data_layers("02"))
    }

    con %>% constructor()
}

#' Read from curated layer
#'
#' Convenience wrapper around `con` chain with suitable constructor
#'
#' @param con [connection] Arrow connection to data lake layer
#' @param constructor
#'
#' @return
#' @export
#'
#' @examples
read_curated <- function(
    con = con_fs_arrow(),
    constructor
) {
    valid_fs_layer <- valid_data_layers("03")

    if (!(fs::path_file(con) %in% valid_fs_layer)) {
        con <- con %>%
            con_add_path(valid_fs_layer)
    }

    con %>% constructor()
}
