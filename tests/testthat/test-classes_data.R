
# data --------------------------------------------------------------------

test_that("data", {
    result <- data(tibble::tibble(x = 1))
    expected <-
        structure(
            list(x = 1),
            class = c("data", "tbl_df", "tbl", "data.frame"),
            row.names = 1L
        )
    expect_identical(result, expected)

    expect_error(
        data("a"),
        regexp = "Expecting 'tbl' or 'data\\.frame'"
    )
})

# data_tableau_superstore -------------------------------------------------

test_that("data: tableau_superstore", {
    result <- data_tableau_global_superstore(
        layer = valid_data_layers("01"),
        version = "v1"
    )

    expected <-
        c("data_tableau_global_superstore",
            "data",
            "tbl_df",
            "tbl",
            "data.frame")
    expect_s3_class(result, expected)
})

# YAML --------------------------------------------------------------------

test_that("yaml", {
    result <- yaml()

    expect_s3_class(result, "yaml")
    expect_true(inherits(result, "logical"))
})

test_that("yaml: list", {
    result <- yaml_list()

    expect_s3_class(result, "yaml_list")
    expect_true(inherits(result, "yaml"))
    expect_true(inherits(result, "list"))
})

test_that("yaml: list: tbl", {
    result <- yaml_list_tbl(list(tibble::tibble(x = 1)))

    expect_s3_class(result, "yaml_list_tbl")
    expect_true(inherits(result, "yaml_list"))
    expect_true(inherits(result, "yaml"))
    expect_true(inherits(result, "list"))
})

# Extract class attribute -------------------------------------------------

test_that("Extract class attributes", {
    result <- tibble::tibble(id = 1) %>%
        structure(class = c("test", class(.))) %>%
        extract_class_attribute()

    target <- "test"

    expect_identical(result, target)
})

test_that("Extract class attributes: n", {
    result <- tibble::tibble(id = 1) %>%
        structure(class = c("test", class(.))) %>%
        extract_class_attribute(n = 2)

    target <- "tbl_df"

    expect_identical(result, target)
})

test_that("Extract class attributes: prefix", {
    result <- tibble::tibble(id = 1) %>%
        structure(class = c("data_test", class(.))) %>%
        extract_class_attribute(prefix = "^data_")

    target <- "test"

    expect_identical(result, target)
})

# Restore -----------------------------------------------------------------

test_that("Restore", {
    x <- tibble::tibble(id = 1:2) %>%
        structure(class = c("test", class(.)))

    result <- x %>%
        dplyr::group_by(id) %>%
        dplyr::ungroup() %>%
        restore_class(x)

    expect_s3_class(result, "test")
    expect_true(inherits(result, "tbl_df"))

})
