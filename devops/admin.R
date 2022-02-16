
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
usethis::use_mit_license()
usethis::use_lifecycle()
usethis::use_lifecycle_badge("experimental")
usethis::use_readme_rmd()
usethis::use_news_md()
usethis::use_version("dev")

usethis::use_build_ignore(
    c(
        "devops",
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
renv::install("assertthat")
renv::install("arrow")
renv::install("snakecase")

# Tests -------------------------------------------------------------------

usethis::use_test("fs")
usethis::use_test("classes_data")
usethis::use_test("valid")
usethis::use_test("data_catalog")
usethis::use_test("layers")
