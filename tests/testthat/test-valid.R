test_that("Valid data layers", {
    result <- valid_data_layers()
    expected <-
        c(
            "00" = "layer_00",
            "01" = "layer_01",
            "02" = "layer_02",
            "03" = "layer_03",
            "04" = "layer_04",
            "99" = "layer_99"
        )
    expect_identical(result, expected)

    result <- valid_data_layers("01")
    expected <-
        c(
            "01" = "layer_01"
        )
    expect_identical(result, expected)

    result <- valid_data_layers(c("01", "03"))
    expected <-
        c(
            "01" = "layer_01",
            "03" = "layer_03"
        )
    expect_identical(result, expected)

    result <- valid_data_layers(2)
    expected <-
        c(
            "01" = "layer_01"
        )
    expect_identical(result, expected)

    result <- valid_data_layers(c(2, 4))
    expected <-
        c(
            "01" = "layer_01",
            "03" = "layer_03"
        )
    expect_identical(result, expected)

    result <- valid_data_layers(flip = TRUE)
    expected <-
        c(
            layer_00 = "00",
            layer_01 = "01",
            layer_02 = "02",
            layer_03 = "03",
            layer_04 = "04",
            layer_99 = "99"
        )
    expect_identical(result, expected)

    result <- valid_data_layers(reverse = TRUE)
    expected <-
        c(
            "99" = "layer_99",
            "04" = "layer_04",
            "03" = "layer_03",
            "02" = "layer_02",
            "01" = "layer_01",
            "00" = "layer_00"
        )
    expect_identical(result, expected)
})

test_that("Valid data layers: data frame", {
    result <- valid_data_layers(df = TRUE)
    expected <-
        structure(
            list(
                digit = c("00", "01", "02", "03", "04", "99"),
                layer = c(
                    "layer_00",
                    "layer_01",
                    "layer_02",
                    "layer_03",
                    "layer_04",
                    "layer_99"
                ),
                desc = c("inbox", "raw", "tidy",
                    "curated", "application", "sandbox")
            ),
            class = c("tbl_df",
                "tbl", "data.frame"),
            row.names = c(NA,-6L)
        )
    expect_identical(result, expected)

    result <- valid_data_layers(c("01", "02"), df = TRUE)
    expected <-
        structure(
            list(
                digit = c("01", "02"),
                layer = c("layer_01", "layer_02"),
                desc = c("raw", "tidy")
            ),
            class = c("tbl_df", "tbl", "data.frame"),
            row.names = c(NA,-2L)
        )
    expect_identical(result, expected)
})
