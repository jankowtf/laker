# Ingest ------------------------------------------------------------------

#' Ingest data from raw to tidy layer
#'
#' @param constructor ([function]) Constructor function
#' @param version ([character]) Data entity version
#'
#' @return
#' @export
#'
#' @examples
#' layer_ingest(
#'     constructor = data_tableau_global_superstore
#' )
layer_ingest <- function(
    constructor,
    version = "v1"
) {
    # Curried constructor for reading
    fn <- purrr::partial(
        constructor,
        layer = valid_data_layers("01"),
        version = version
    )

    # Actual read
    data <- fn()

    # Internal constructor
    constructor_internal <- data %>% factory_constructor_internal()

    # Query target path in data catalog
    to <- catalog_get_path(
        layer = valid_data_layers("02"),
        version = version,
        constructor = constructor_internal
    )

    # Connection constructor for writing
    con <- to %>% factory_con()

    # Write
    data %>% con_write(
        con = con()
        # valid_data_layers("02"),
        # version = version,
        # constructor = constructor_internal
    )

    # Return value
    invisible(data)
}

# Curate ------------------------------------------------------------------

#' curate data (generic)
#'
#' @param data
#'
#' @return
#' @export
layer_curate <- function(data, ...) {
    UseMethod("layer_curate")
}

#' Curate data
#'
#' @param data
#'
#' @return
#' @export
layer_curate.data <- function(
    data,
    version = "v1"
) {
    logger::log_trace("Curating instance of '{extract_class_attribute(data)}'")

    data_cura <- data %>%
        purrr::set_names(names(.) %>% snakecase::to_snake_case()) %>%
        restore_class(data)

    # Internal constructor
    constructor_internal <- data_cura %>%
        factory_constructor_internal()

    # Query target path in data catalog
    to <- catalog_get_path(
        layer = valid_data_layers("03"),
        version = version,
        constructor = constructor_internal
    )

    # Connection constructor for writing
    con <- to %>% factory_con()

    data_cura %>% con_write(con = con())

    data_cura
}
