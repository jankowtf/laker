# Dev ---------------------------------------------------------------------

test_that("DevOps env", {
  result <- env_devops_env()
  expected <- "dev"
  expect_identical(result, expected)
})

test_that("Data lake connection", {
  result <- env_data_lake()
  expected <- here::here("data") %>% fs::path()
  expect_identical(result, expected)

  result <- env_data_lake("layer_00")
  expected <- here::here("data", "layer_00") %>% fs::path()
  expect_identical(result, expected)
})

# Test --------------------------------------------------------------------

test_that("[Staging] DevOps env", {
  result <- env_devops_env(devops_env = valid::valid_devops_envs("staging"))
  expected <- structure("staging", names = "staging")
  expect_identical(result, expected)
})

# Prod --------------------------------------------------------------------

test_that("[Prod] DevOps env", {
  result <- env_devops_env(devops_env = valid::valid_devops_envs("prod"))
  expected <- structure("prod", names = "prod")
  expect_identical(result, expected)
})
