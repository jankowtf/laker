factory_catalog <- function(
    data,
    version = "v1",
    layer = "global",
    path_sub = "columns",
    prefix = "^data_"
) {
    # Capture class info
    class <- data %>% extract_class_attribute(prefix = prefix)

    # Compose catalog function name
    fn <- "catalog_{class}" %>%
        stringr::str_glue()

    # Assert existence
    assert_function_exists(fn)

    # Compose function call
    call <- compose_fn_call(
        fn = fn,
        args = list(
            layer = layer,
            version = version
        )
    )

    # Return curried function
    call %>% curry_fn()
}

#' Compose entity path in data catalog
#'
#' @param entity
#' @param layer
#' @param bucket
#' @param version
#' @param fn_valid
#'
#' @return
#' @export
catalog_entity_path <- function(
    entity,
    layer = character(),
    bucket = character(),
    version = character(),
    fn_valid = valid_data_catalog_entities
) {
    path <- entity

    # Add data layer
    if (length(layer)) {
        path <- path %>%
            fs::path(layer)
    }

    # Add bucket
    if (length(bucket)) {
        path <- path %>%
            fs::path(bucket)
    }

    # Add version
    if (length(version)) {
        path <- path %>%
            fs::path(version)
    }

    # Add path
    path <- path %>%
        fs::path("file_name" %>% fn_valid()) %>%
        as.character()

    path
}

catalog_get_entity_value <- function(
    entity_key,
    catalog = env_data_catalog(),
    catalog_version = env_data_catalog_version()
) {
    confx::conf_get(entity_key, from = catalog, config = catalog_version)
}

#' Get source path from data catalog
#'
#' @param con Data connection
#' @param constructor Class/instance constructor function
#' @param from optional source path. In this case this is simply returned
#'
#' @return
catalog_get_path <- function(
    layer,
    version,
    constructor,
    path = character(),
    con_data_lake = env_data_lake()
) {
    if (length(path)) {
        return(path)
    }

    # Compose curried catalog function
    fn <- factory_catalog(
        data = constructor(),
        layer = layer,
        version = version,
        path_sub = "path"
    )

    # Get entity key
    entity_key <- fn()

    # File name
    file_name <- catalog_get_entity_value(entity = entity_key)

    # Complete source path
    entity_key %>%
        stringr::str_split("/") %>%
        unlist() %>%
        `[`(-1) %>%
        `[`(-(length(.))) %>%
        c(con_data_lake, ., file_name) %>%
        stringr::str_c(collapse = "/") %>%
        fs::path()
}
