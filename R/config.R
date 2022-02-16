#' Factory for curried function (`conf_entity_*`)
#'
#' @param data
#'
#' @return
#' @export
#'
#' @examples
factory_conf_entity <- function(
    data,
    version = "v1",
    layer = "global",
    path_sub = "columns",
    prefix = "^data_"
) {
    # Capture class info
    cls <- data %>% extract_class_attribute(prefix = prefix)

    # Compose function name
    conf_fn <- "conf_entity_{cls}" %>%
        stringr::str_glue()

    # Check existence
    call <- deparse(sys.call())
    assertthat::assert_that(
        exists(conf_fn),
        msg = "Invalid constructed function: {conf_fn} (in {call})" %>%
            stringr::str_glue()
    )

    # Compose function call
    call <- rlang::call2(
        conf_fn,
        !!!list(
            version = version,
            layer = layer,
            path_sub = path_sub
        ))

    # Factory/curried function
    function() {
        call %>%
            rlang::eval_tidy()
    }
    # TODO-20201222-1115: Make the actual inner/curried call visible
}

conf_path_ <- function(
    path,
    version = character(),
    layer = character(),
    path_sub = character(),
    fn_valid = valid_data_catalog_entities
) {
    # Add version
    if (length(version)) {
        path <- path %>%
            fs::path(version)
    }

    # Add data lake env/layer
    if (length(layer)) {
        path <- path %>%
            fs::path(layer)
    }

    # Add subpath
    if (length(path_sub)) {
        path <- path %>%
            fs::path(path_sub %>% fn_valid()) %>%
            as.character()
    }

    path
}

conf_entity_attribute <- function(
    entity,
    config_path = env_conf_crosswalk_file(),
    config_id = env_conf_crosswalk_version()
) {
    .Deprecated("catalog_get_entity_value")
    confx::conf_get(entity, from = config_path, config = config_id)
}
