test_that("Create symbolic links", {
    fs_create_symlink()
    expect_true("datalake" %>% fs::dir_exists())
})

test_that("Link data lake", {
    link_data_lake(is_interactive = FALSE)
    expect_true("datalake" %>% fs::dir_exists())
    "datalake/layer_0" %>% stringr::str_c(1:4) %>%
        purrr::map(~(.x %>% fs::dir_exists()) %>% expect_true())
})
