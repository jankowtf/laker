# Helpers -----------------------------------------------------------------

test_that("Construct class path: prefixed", {
    result <- construct_class_path(
        x = NA,
        subclass = "test"
    )
    expectation <- c("logical_test", "logical")
    expect_identical(result, expectation)

    result <- construct_class_path(x = logical(), c("sub_sub", "sub"))
    expectation <- c("logical_sub_sub", "logical_sub", "logical")
    expect_identical(result, expectation)
})

test_that("Construct class path: non-prefixed", {
    result <- construct_class_path(
        x = NA,
        subclass = "test",
        prefix = FALSE
    )

    expectation <- c("test", "logical")

    expect_identical(result, expectation)
})

# FS ----------------------------------------------------------------------

test_that("con: fs", {
    result <- con_fs(test_path())
    expected <-
        structure("tests/testthat", class = c("con_fs", "fs_path", "character"))
    expect_identical(result, expected)
})

test_that("con: fs: subdirs", {
    result <- con_fs("a/b/c")
    expected <- structure("a/b/c", class = c("con_fs", "fs_path",
        "character"))
    expect_identical(result, expected)
})

# Determine ---------------------------------------------------------------

test_that("Determine class", {
    result <- "test.xls" %>% factory_con()
    result()
})

# FS: csv -----------------------------------------------------------------

test_that("con: fs: csv", {
    result <- con_fs_csv(test_path("test.csv"))
    expected <-
        structure("tests/testthat/test.csv",
            class = c("con_fs_csv",
                "con_fs", "character"))
    expect_identical(result, expected)

    expect_error(
        con_fs_csv(1),
        regexp = "Expecting 'character'"
    )

    expect_error(
        con_fs_csv(),
        regexp = "Expecting file type '.csv'"
    )
})

# FS: xls ----------------------------------------------------------------

test_that("con: fs: xls", {
    result <- con_fs_xls(test_path("test.xls"))
    expected <-
        structure("tests/testthat/test.xls", class = c("con_fs_xls", "con_fs", "character"))
    expect_identical(result, expected)

    expect_error(
        con_fs_xls(1),
        regexp = "Expecting 'character'"
    )

    expect_error(
        con_fs_xls(),
        regexp = "Expecting file type '.xls'"
    )
})

# FS: xlsx ----------------------------------------------------------------

test_that("con: fs: xlsx", {
    result <- con_fs_xlsx(test_path("test.xlsx"))
    expected <-
        structure("tests/testthat/test.xlsx",
            class = c("con_fs_xlsx",
                "con_fs", "character"))
    expect_identical(result, expected)

    expect_error(
        con_fs_xlsx(1),
        regexp = "Expecting 'character'"
    )

    expect_error(
        con_fs_xlsx(),
        regexp = "Expecting file type '.xlsx'"
    )
})

# FS: rds -----------------------------------------------------------------

test_that("con: fs: rds", {
    result <- con_fs_rds(test_path("test.rds"))
    expected <-
        structure("tests/testthat/test.rds",
            class = c("con_fs_rds",
                "con_fs", "character"))
    expect_identical(result, expected)

    expect_error(
        con_fs_rds(1),
        regexp = "Expecting 'character'"
    )

    expect_error(
        con_fs_rds(),
        regexp = "Expecting file type '.rds'"
    )
})

# Arrow -------------------------------------------------------------------

test_that("con: fs: arrow", {
    result <- con_fs_arrow("test.arrow")
    expected <-
        structure("test.arrow", class = c("con_fs_arrow", "con_fs", "character"))
    expect_identical(result, expected)

    expect_error(
        con_fs_arrow(1),
        regexp = "Expecting 'character'"
    )

    expect_error(
        con_fs_arrow(),
        regexp = "Expecting file type '.arrow'"
    )
})
