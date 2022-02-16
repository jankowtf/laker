test_that("Ingestion", {
    result <- layer_ingest(
        constructor = data_tableau_global_superstore
    )
    expected <- "/Users/jankothyson/Code/Rappster/laker/data/layer_02/tableau_global_superstore/v1"
    expect_identical(result, expected)
})
