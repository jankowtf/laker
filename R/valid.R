valid_devops_envs <- function(
    devops_env = character(),
    reverse = FALSE,
    flip = FALSE
) {
    values <- c("dev", "stage", "prod")
    names(values) <- values

    valid::valid(
        choice = devops_env,
        choices = values,
        reverse = reverse,
        flip = flip
    )
}

#' Title
#'
#' @param layer
#' @param reverse
#' @param flip
#' @param df ([logical]) Return data frame (else vector)?
#'
#' @return
#' @export
#'
#' @examples
valid_data_layers <- function(
    layer = character(),
    reverse = FALSE,
    flip = FALSE,
    df = FALSE
) {
    tbl <- tibble::tribble(
        ~digit, ~layer, ~desc,
        "00", "layer_00", "inbox",
        "01", "layer_01", "raw",
        "02", "layer_02", "tidy",
        "03", "layer_03", "curated",
        "04", "layer_04", "application",
        "99", "layer_99", "sandbox"
    )

    values <- tbl$layer
    names(values) <- tbl$digit

    result <- valid::valid(
        choice = layer,
        choices = values,
        reverse = reverse,
        flip = flip
    )

    if (!df) {
        return(result)
    }

    tbl %>% dplyr::filter(layer %in% result)
}

valid_data_catalog_entities <- function(
    path_sub = character(),
    reverse = FALSE,
    flip = FALSE
) {
    values <- c("columns", "file_name", "valid_since", "valid_until")
    names(values) <- values

    valid::valid(
        choice = path_sub,
        choices = values,
        reverse = reverse,
        flip = flip
    )
}

# DT ----------------------------------------------------------------------

#' Valid DT argument: selection
#'
#' See [DT::datatable]
#'
#' @param ...
#' @param reverse
#' @param flip
#'
#' @return
#' @export
#'
#' @examples
valid_dt_arg_selection <- function(
    ...,
    reverse = FALSE,
    flip = FALSE
) {
    value <- rlang::list2(...) %>%
        unlist()

    values <- c(
        "none",
        "single",
        "multiple"
    )
    names(values) <- values

    valid::valid(
        choice = value,
        choices = values,
        reverse = reverse,
        flip = flip
    )
}


#' Valid DT extensions
#'
#' See https://datatables.net/extensions/index
#'
#' @param ...
#' @param reverse
#' @param flip
#'
#' @return
#' @export
#'
#' @examples
valid_dt_extensions <- function(
    ...,
    reverse = FALSE,
    flip = FALSE
) {
    value <- rlang::list2(...) %>%
        unlist()

    values <- c(
        "AutoFill",
        "Buttons",
        "ColReorder",
        "Editor",
        "FixedColumns",
        "FixedHeader",
        "KeyTable",
        "Responsive",
        "RowGroup",
        "RowReorder",
        "Scroller",
        "SearchBuilder",
        "Select",
        "SearchPanes",
        "ColVis"
    )
    names(values) <- values

    valid::valid(
        choice = value,
        choices = values,
        reverse = reverse,
        flip = flip
    )
}
