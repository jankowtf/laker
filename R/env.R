env_devops_env <- function(
    # devops_env = Sys.getenv("LAKER_DEVOPS_ENV", valid::valid_devops_envs("dev"))
    devops_env = Sys.getenv("LAKER_DEVOPS_ENV",
        pops::get_option("devops_env"))
) {
    # confx::conf_get(
    #     "devops_env",
    #     from = fs::path_package("dbt.def.core", "conf_devops.yml"),
    #     config = devops_env
    # )
    devops_env
}

#' Data lake connection (file system)
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
env_data_lake <- function(...) {
    con <- confx::conf_get(
        "data_lake",
        from = fs::path_package(pkgload::pkg_name(), "config.yml"),
        config = env_devops_env()
    ) %>%
        fs::path()

    # Capture arguments
    dots <- rlang::list2(...)

    # Early exit if no path components via dots
    if (!length(dots)) {
        return(con)
    }

    # Collapse dots to path
    dots <- dots %>%
        unlist() %>%
        stringr::str_c(collapse = "/")

    # Extend 'con' with path compontenst from dots
    con %>%
        fs::path(dots)
}

#' Env shorthand
#'
#' @param devops_env
#'
#' @return
#' @export
#'
#' @examples
#' env_data_catalog()
env_data_catalog <- function(
    devops_env = Sys.getenv("LAKER_DEVOPS_ENV",
        pops::get_option("devops_env"))
) {
    confx::conf_get(
        "data_catalog",
        from = fs::path_package(pkgload::pkg_name(), "config.yml"),
        config = devops_env
    )
}

#' Env shorthand
#'
#' @param devops_env
#'
#' @return
#' @export
#'
#' @examples
#' env_data_catalog_version()
env_data_catalog_version <- function(
    devops_env = Sys.getenv("LAKER_DEVOPS_ENV",
        pops::get_option("devops_env"))
) {
    confx::conf_get(
        "data_catalog_version",
        from = fs::path_package(pkgload::pkg_name(), "config.yml"),
        config = devops_env
    )
}
