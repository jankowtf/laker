
# Dev dependencies --------------------------------------------------------

renv::install("devtools")
renv::install("testthat")
renv::install("roxygen2")
renv::install("roxygen2md")
renv::install("rmarkdown")
renv::install("here")

# "Add the pipe"
usethis::use_pipe()

# Add package description
usethis::use_package_doc()

# Use {thestthat}
usethis::use_testthat()

usethis::use_package("testthat", type = "Suggests")

# Dev preparations --------------------------------------------------------

usethis::use_roxygen_md()
roxygen2md::roxygen2md()
usethis::use_readme_rmd()
usethis::use_mit_license()
usethis::use_lifecycle()
usethis::use_lifecycle_badge("experimental")
usethis::use_news_md()

usethis::use_build_ignore(
    c(
        "dev",
        "inst/examples",
        "tests"
    )
)

# Prod dependencies -------------------------------------------------------

renv::install("rappster/confx")
renv::install("rappster/valid", rebuild = TRUE)
renv::install("rappster/clix", rebuild = TRUE)
renv::install("rappster/pops", rebuild = TRUE)
renv::install("dplyr")
renv::install("readxl")
renv::install("arrow")
renv::install("snakecase")
renv::install("assertthat")

usethis::use_dev_package("confx", type = "Imports", remote = "rappster/confx")
usethis::use_dev_package("valid", type = "Imports", remote = "rappster/valid")
usethis::use_dev_package("clix", type = "Imports", remote = "rappster/clix")
usethis::use_dev_package("pops", type = "Imports", remote = "rappster/pops")
usethis::use_package("dplyr", type = "Imports")
usethis::use_package("readxl", type = "Imports")
usethis::use_package("arrow", type = "Imports")
usethis::use_package("snakecase", type = "Imports")
usethis::use_package("assertthat", type = "Imports")

# Tests -------------------------------------------------------------------

usethis::use_test("fs")
usethis::use_test("classes_data")
usethis::use_test("valid")
usethis::use_test("data_catalog")
usethis::use_test("layers")

# Continuous dev ----------------------------------------------------------

usethis::use_version("dev")
