.onLoad <- function(libname, pkgname) {
    options(digits.secs = 3)
    Sys.setenv(TZ = "UTC")
    Sys.setenv(language = "en")

    # Package options
    library(magrittr)
    pops::init_package_options(
        values = list("devops_env" = valid::valid_devops_envs("dev"))
    )

    # # Symlink for local data lake
    # fs_create_symlink(
    #     original = "~/data/dev",
    #     symlink = "data",
    # )

    invisible(TRUE)
}
