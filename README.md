
<!-- README.md is generated from README.Rmd. Please edit that file -->

# laker

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/valid)](https://CRAN.R-project.org/package=valid)
<!-- badges: end -->

## Installation

You can install the development version of laker from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rappster/laker")
```

## What?

A framework for a local data lake.

## Why?

More control of data pipelines.

## How?

Via data layers and systematic S3 method dispatch.

The goal is to integrate `{laker}` as much as possible with `{targets}`
in the future

## Symlink your local data lake

Assuming that you have a local directory that should act as your “local
data lake” you can symlink it to the `data` directory within your
(package) project.

Mine is layered as follows

``` r
valid_data_layers(df = TRUE)
```

You can create a symbol link with `[fs_create_symlink]`.

``` r
fs_create_symlink(
    original = "~/data/dev/",
    symlink = "data/",
    subdirs = TRUE
)
```

## Ingest

Put an arbitrary file\* in your “inbox” layer.

\*As long as it’s the Tableau Global Superstore data ;-)

Bear with me: it’s currently the only data class that has been defined
and I still didn’t get around the part of describing how to define your
own data classes - which is obviously the entire point of this package.
We’ll get there ;-)

``` r
superstore <- laker::layer_ingest(
    constructor = laker::data_tableau_global_superstore,
    version = "v1"
)
```

What you just did is to “ingest” the original file from *layer 01* (the
“raw” layer) into *layer 02* (the “tidy” layer) and stored it as an
arrow file.

``` r
fs::dir_ls(here::here("data", "layer_01"), recurse = TRUE)
```

### TODO-2022-02-17-2326: Describe curation step/layer

Systematically transform data as needed.

``` r
layer_curate
```

### TODO-2022-02-17-2334: Describe “application-ready” step/layer

Taking curated data from *layer 03* and making it “application-read” -
whatever that means ;-)

``` r
# No generic function and methods yet :-()
```

TODO-2022-02-17-2327: Explain the data catalog YAML

``` r
path <- fs::path_package("laker", "data_catalog.yml")
path %>% readLines() %>% cat(sep = "\n")
confx::conf_get(from = path, config = "v2")
```

TODO-2022-02-17-2328: Explain the config YAML

``` r
path <- fs::path_package("laker", "config.yml")
path %>% readLines() %>% cat(sep = "\n")
confx::conf_get(from = path, config = "dev")
```

## Read

You can read data from arbitray layers with

Read from *layer 01*

``` r
superstore <- laker::layer_read(
    constructor = laker::data_tableau_global_superstore,
    layer = laker::valid_data_layers("01"),
    version = "v1"
) %>% 
    dplyr::glimpse()
```

Read from *layer 02*

``` r
laker::layer_read(
    constructor = laker::data_tableau_global_superstore,
    layer = laker::valid_data_layers("02"),
    version = "v1"
) %>% 
    dplyr::glimpse()
```

## Write
