
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
library(laker)
#> 
#> Attaching package: 'laker'
#> The following object is masked from 'package:utils':
#> 
#>     data
```

``` r
valid_data_layers(df = TRUE)
#> # A tibble: 6 × 3
#>   digit layer    desc       
#>   <chr> <chr>    <chr>      
#> 1 00    layer_00 inbox      
#> 2 01    layer_01 raw        
#> 3 02    layer_02 tidy       
#> 4 03    layer_03 curated    
#> 5 04    layer_04 application
#> 6 99    layer_99 sandbox
```

You can create a symbolIC link with `[fs_create_symlink]`.

``` r
fs_create_symlink(
    original = "~/data/dev/",
    symlink = "data/"
)
#> 
#> ── Directory check ─────────────────────────────────────────────────────────────
#> Directory data/ already exists.
#> 
#> ✓ Removing existing subdirectories of data/
#> ✓ rm -r data/layer_00
#> ✓ rm -r data/layer_01
#> ✓ rm -r data/layer_02
#> ✓ rm -r data/layer_03
#> ✓ rm -r data/layer_04
#> 
#> ── Creating symbolic link(s) ───────────────────────────────────────────────────
#> ✓ ln -s /Users/jankothyson/data/dev/layer_00 data/
#> ✓ ln -s /Users/jankothyson/data/dev/layer_01 data/
#> ✓ ln -s /Users/jankothyson/data/dev/layer_02 data/
#> ✓ ln -s /Users/jankothyson/data/dev/layer_03 data/
#> ✓ ln -s /Users/jankothyson/data/dev/layer_04 data/
#> ✓ Symbolic link(s) created
```

This is simply for my own convenience while “developing the thing” and
I’m sorry for any annoyances it may cause for others. I’ll change that
in the future.

If the use case to create symbolic links is to “link to a data lake”
then there is a more user-friendly wrapper around `fs_create_symlink()`

``` r
link_data_lake(
    path_data_lake = "~/data/dev",
    path = "datalake"
)
#> 
#> ── Directory check ─────────────────────────────────────────────────────────────
#> Directory datalake already exists.
#> 
#> ✓ Removing existing subdirectories of datalake
#> ✓ rm -r datalake/layer_00
#> ✓ rm -r datalake/layer_01
#> ✓ rm -r datalake/layer_02
#> ✓ rm -r datalake/layer_03
#> ✓ rm -r datalake/layer_04
#> 
#> ── Creating symbolic link(s) ───────────────────────────────────────────────────
#> ✓ ln -s /Users/jankothyson/data/dev/layer_00 datalake
#> ✓ ln -s /Users/jankothyson/data/dev/layer_01 datalake
#> ✓ ln -s /Users/jankothyson/data/dev/layer_02 datalake
#> ✓ ln -s /Users/jankothyson/data/dev/layer_03 datalake
#> ✓ ln -s /Users/jankothyson/data/dev/layer_04 datalake
#> ✓ Symbolic link(s) created
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
#> Warning: replacing previous import 'magrittr::set_names' by 'purrr::set_names'
#> when loading 'confx'
```

What you just did is to “ingest” the original file from *layer 01* (the
“raw” layer) into *layer 02* (the “tidy” layer) and stored it as an
arrow file.

``` r
fs::dir_ls(here::here("data", "layer_01"), recurse = TRUE)
#> /Users/jankothyson/Code/rappster/laker/data/layer_01/tableau_global_superstore
#> /Users/jankothyson/Code/rappster/laker/data/layer_01/tableau_global_superstore/v1
#> /Users/jankothyson/Code/rappster/laker/data/layer_01/tableau_global_superstore/v1/Tableau Global Superstore.xls
```

### TODO-2022-02-17-2326: Describe curation step/layer

Systematically transform data as needed.

``` r
layer_curate
#> function(data, ...) {
#>     UseMethod("layer_curate")
#> }
#> <bytecode: 0x10506e158>
#> <environment: namespace:laker>
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
#> default:
#>   date_start: "2020-01-01"
#> 
#> v1:
#>   tableau_superstore:
#>     v1:
#>       global:
#>         # path: "tableau_superstore/v1"
#>         path: "Global Superstore.xls"
#>         valid_since: "2021-02-26"
#>         valid_until: null
#>         columns_ref: ./travex_enriched/v1/global
#>         columns: null
#>       layer_01:
#>         path: "Global Superstore.xls"
#>       layer_02:
#>         path: "tableau_superstore/v1"
#>       layer_03: "tableau_superstore/v1"
#> 
#> v2:
#>     tableau_global_superstore:
#>         layer_01:
#>             tableau_global_superstore:
#>                 v1:
#>                     file_name: "Tableau Global Superstore.xls"
#>         layer_02:
#>             tableau_global_superstore:
#>                 v1:
#>                     file_name: "tableau_global_superstore.arrow"
#>                     # file_name: "tableau_global_superstore"
#>                     # The second way would be cleaner but currently clashes with
#>                     # factory setup for the 'con_*' classes
#>         layer_03:
#>             tableau_global_superstore:
#>                 v1:
#>                     file_name: "tableau_global_superstore.arrow"
confx::conf_get(from = path, config = "v2")
#> $date_start
#> [1] "2020-01-01"
#> 
#> $tableau_global_superstore
#> $tableau_global_superstore$layer_01
#> $tableau_global_superstore$layer_01$tableau_global_superstore
#> $tableau_global_superstore$layer_01$tableau_global_superstore$v1
#> $tableau_global_superstore$layer_01$tableau_global_superstore$v1$file_name
#> [1] "Tableau Global Superstore.xls"
#> 
#> 
#> 
#> 
#> $tableau_global_superstore$layer_02
#> $tableau_global_superstore$layer_02$tableau_global_superstore
#> $tableau_global_superstore$layer_02$tableau_global_superstore$v1
#> $tableau_global_superstore$layer_02$tableau_global_superstore$v1$file_name
#> [1] "tableau_global_superstore.arrow"
#> 
#> 
#> 
#> 
#> $tableau_global_superstore$layer_03
#> $tableau_global_superstore$layer_03$tableau_global_superstore
#> $tableau_global_superstore$layer_03$tableau_global_superstore$v1
#> $tableau_global_superstore$layer_03$tableau_global_superstore$v1$file_name
#> [1] "tableau_global_superstore.arrow"
#> 
#> 
#> 
#> 
#> 
#> attr(,"config")
#> [1] "v2"
#> attr(,"file")
#> [1] "/Users/jankothyson/Code/rappster/laker/renv/library/R-4.1/aarch64-apple-darwin20/laker/data_catalog.yml"
```

TODO-2022-02-17-2328: Explain the config YAML

``` r
path <- fs::path_package("laker", "config.yml")
path %>% readLines() %>% cat(sep = "\n")
#> default:
#>     data_catalog: !expr Sys.getenv(
#>         "DATA_CATALOG", fs::path_package(pops:::pkg_name(), "data_catalog.yml"))
#>     data_catalog_version: !expr Sys.getenv(
#>         "DATA_CATALOG_VERSION", "v2")
#>     data_lake: !expr Sys.getenv(
#>         "DATA_LAKE", here::here("data"))
#> 
#> dev:
#>     inherits: default
#> 
#> staging:
#>     inherits: dev
#> 
#> prod:
#>     inherits: staging
confx::conf_get(from = path, config = "dev")
#> $data_catalog
#> [1] "/Users/jankothyson/Code/rappster/laker/renv/library/R-4.1/aarch64-apple-darwin20/laker/data_catalog.yml"
#> 
#> $data_catalog_version
#> [1] "v2"
#> 
#> $data_lake
#> [1] "/Users/jankothyson/Code/rappster/laker/data"
#> 
#> $inherits
#> [1] "default"
#> 
#> attr(,"config")
#> [1] "dev"
#> attr(,"file")
#> [1] "/Users/jankothyson/Code/rappster/laker/renv/library/R-4.1/aarch64-apple-darwin20/laker/config.yml"
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
#> Rows: 51,290
#> Columns: 24
#> $ `Row ID`         <dbl> 32298, 26341, 25330, 13524, 47221, 22732, 30570, 3119…
#> $ `Order ID`       <chr> "CA-2012-124891", "IN-2013-77878", "IN-2013-71249", "…
#> $ `Order Date`     <dttm> 2012-07-31, 2013-02-05, 2013-10-17, 2013-01-28, 2013…
#> $ `Ship Date`      <dttm> 2012-07-31, 2013-02-07, 2013-10-18, 2013-01-30, 2013…
#> $ `Ship Mode`      <chr> "Same Day", "Second Class", "First Class", "First Cla…
#> $ `Customer ID`    <chr> "RH-19495", "JR-16210", "CR-12730", "KM-16375", "RH-9…
#> $ `Customer Name`  <chr> "Rick Hansen", "Justin Ritter", "Craig Reiter", "Kath…
#> $ Segment          <chr> "Consumer", "Corporate", "Consumer", "Home Office", "…
#> $ City             <chr> "New York City", "Wollongong", "Brisbane", "Berlin", …
#> $ State            <chr> "New York", "New South Wales", "Queensland", "Berlin"…
#> $ Country          <chr> "United States", "Australia", "Australia", "Germany",…
#> $ `Postal Code`    <chr> "10024", NA, NA, NA, NA, NA, NA, NA, "95823", "28027"…
#> $ Market           <chr> "US", "APAC", "APAC", "EU", "Africa", "APAC", "APAC",…
#> $ Region           <chr> "East", "Oceania", "Oceania", "Central", "Africa", "O…
#> $ `Product ID`     <chr> "TEC-AC-10003033", "FUR-CH-10003950", "TEC-PH-1000466…
#> $ Category         <chr> "Technology", "Furniture", "Technology", "Technology"…
#> $ `Sub-Category`   <chr> "Accessories", "Chairs", "Phones", "Phones", "Copiers…
#> $ `Product Name`   <chr> "Plantronics CS510 - Over-the-Head monaural Wireless …
#> $ Sales            <dbl> 2309.650, 3709.395, 5175.171, 2892.510, 2832.960, 286…
#> $ Quantity         <dbl> 7, 9, 9, 5, 8, 5, 4, 6, 5, 13, 5, 5, 4, 7, 12, 4, 9, …
#> $ Discount         <dbl> 0.0, 0.1, 0.1, 0.1, 0.0, 0.1, 0.0, 0.0, 0.2, 0.4, 0.0…
#> $ Profit           <dbl> 762.1845, -288.7650, 919.9710, -96.5400, 311.5200, 76…
#> $ `Shipping Cost`  <dbl> 933.570, 923.630, 915.490, 910.160, 903.040, 897.350,…
#> $ `Order Priority` <chr> "Critical", "Critical", "Medium", "Medium", "Critical…
```

Read from *layer 02*

``` r
laker::layer_read(
    constructor = laker::data_tableau_global_superstore,
    layer = laker::valid_data_layers("02"),
    version = "v1"
) %>% 
    dplyr::glimpse()
#> Rows: 51,290
#> Columns: 24
#> $ `Row ID`         <dbl> 32298, 26341, 25330, 13524, 47221, 22732, 30570, 3119…
#> $ `Order ID`       <chr> "CA-2012-124891", "IN-2013-77878", "IN-2013-71249", "…
#> $ `Order Date`     <dttm> 2012-07-31, 2013-02-05, 2013-10-17, 2013-01-28, 2013…
#> $ `Ship Date`      <dttm> 2012-07-31, 2013-02-07, 2013-10-18, 2013-01-30, 2013…
#> $ `Ship Mode`      <chr> "Same Day", "Second Class", "First Class", "First Cla…
#> $ `Customer ID`    <chr> "RH-19495", "JR-16210", "CR-12730", "KM-16375", "RH-9…
#> $ `Customer Name`  <chr> "Rick Hansen", "Justin Ritter", "Craig Reiter", "Kath…
#> $ Segment          <chr> "Consumer", "Corporate", "Consumer", "Home Office", "…
#> $ City             <chr> "New York City", "Wollongong", "Brisbane", "Berlin", …
#> $ State            <chr> "New York", "New South Wales", "Queensland", "Berlin"…
#> $ Country          <chr> "United States", "Australia", "Australia", "Germany",…
#> $ `Postal Code`    <chr> "10024", NA, NA, NA, NA, NA, NA, NA, "95823", "28027"…
#> $ Market           <chr> "US", "APAC", "APAC", "EU", "Africa", "APAC", "APAC",…
#> $ Region           <chr> "East", "Oceania", "Oceania", "Central", "Africa", "O…
#> $ `Product ID`     <chr> "TEC-AC-10003033", "FUR-CH-10003950", "TEC-PH-1000466…
#> $ Category         <chr> "Technology", "Furniture", "Technology", "Technology"…
#> $ `Sub-Category`   <chr> "Accessories", "Chairs", "Phones", "Phones", "Copiers…
#> $ `Product Name`   <chr> "Plantronics CS510 - Over-the-Head monaural Wireless …
#> $ Sales            <dbl> 2309.650, 3709.395, 5175.171, 2892.510, 2832.960, 286…
#> $ Quantity         <dbl> 7, 9, 9, 5, 8, 5, 4, 6, 5, 13, 5, 5, 4, 7, 12, 4, 9, …
#> $ Discount         <dbl> 0.0, 0.1, 0.1, 0.1, 0.0, 0.1, 0.0, 0.0, 0.2, 0.4, 0.0…
#> $ Profit           <dbl> 762.1845, -288.7650, 919.9710, -96.5400, 311.5200, 76…
#> $ `Shipping Cost`  <dbl> 933.570, 923.630, 915.490, 910.160, 903.040, 897.350,…
#> $ `Order Priority` <chr> "Critical", "Critical", "Medium", "Medium", "Critical…
```

## Write
