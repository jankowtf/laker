test_that("Entity path", {
    entity <- "tableau_global_superstore"

    if (FALSE) {
        x <- confx::conf_get(
            entity,
            from = fs::path_package(pkgload::pkg_name(), "data_catalog.yml"),
            config = "v2"
        )
        x
    }

    result <- catalog_entity_path(
        entity = entity,
        layer = valid_data_layers("01"),
        bucket = entity,
        version = "v1"
    )
    expected <- "tableau_global_superstore/layer_01/tableau_global_superstore/v1/file_name"
    expect_identical(result, expected)
})
