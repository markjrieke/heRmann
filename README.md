
<!-- README.md is generated from README.Rmd. Please edit that file -->

# heRmann <img src="man/figures/logo.png" align="right" width="120" />

**Author**: [Mark Rieke](https://www.thedatadiary.net/about/about) <br/>
**License**:
[MIT](https://github.com/markjrieke/heRmann/blob/main/LICENSE)

## Overview

`{heRmann}` is a collection of functions for the Consumer Experience
Analytics (CXA) team at Memorial Hermann Health System. The package
provides convenience functions for interacting with Qualtrics’ API and
performing common survey-specific data manipulation tasks.

## Installation

This package is intentionally not available on CRAN. You can install the
most up-to-date version from github with the
[devtools](https://devtools.r-lib.org/) package.

``` r
devtools::install_github("markjrieke/heRmann")
```

## Usage

A typical workflow involves extracting survey responses from Qualtrics
and prepping for analysis. Below is an example using fake data for the
Inpatient, Pediatric Inpatient, and Inpatient Rehab surveys. To import
real responses, however, we can pass a vector of survey names as they
appear in the Qualtrics UI to `fetch_surveys()`.

``` r
library(heRmann)

surveys <- 
  c("Live - Inpatient",
    "Live - Pediatric Inpatient",
    "Live - Adult Inpatient Rehab") |>
  fetch_surveys()

surveys
```

    #> # A tibble: 3 × 2
    #>   survey_name                  responses       
    #>   <chr>                        <list>          
    #> 1 Live - Inpatient             <tibble [6 × 3]>
    #> 2 Live - Pediatric Inpatient   <tibble [1 × 3]>
    #> 3 Live - Adult Inpatient Rehab <tibble [2 × 3]>

The survey names in the UI, however, are lengthy and annoying. Further,
because of Qualtrics’ HCAHPS sampling engine, the Inpatient survey
contains duplicate responses from the Pediatric Inpatient and Inpatient
Rehab surveys. `fix_survey_names()` and `deduplicate_ip()` address these
issues, respectively.

``` r
surveys <- 
  surveys |>
  fix_survey_names() |>
  deduplicate_ip()

surveys
#> # A tibble: 3 × 2
#>   survey_name     responses       
#>   <chr>           <list>          
#> 1 Pedi Inpatient  <tibble [1 × 3]>
#> 2 Inpatient Rehab <tibble [2 × 3]>
#> 3 Inpatient       <tibble [3 × 3]>
```

Finally, unnesting reveals that the default recodes for campus are
similarly lengthy and annoying. `fix_campus_names()` reformats to a more
intuitive description:

``` r
surveys <- 
  surveys |>
  tidyr::unnest(responses)

surveys
#> # A tibble: 6 × 4
#>   survey_name     UNIQUE_ID campus                                  response 
#>   <chr>           <chr>     <chr>                                   <chr>    
#> 1 Pedi Inpatient  12345     Children's Memorial Hermann Hospital    Promoter 
#> 2 Inpatient Rehab 23456     Memorial Hermann - Texas Medical Center Passive  
#> 3 Inpatient Rehab 34567     Memorial Hermann - Texas Medical Center Promoter 
#> 4 Inpatient       45678     Memorial Hermann - Texas Medical Center Passive  
#> 5 Inpatient       56789     Memorial Hermann - Texas Medical Center Detractor
#> 6 Inpatient       67890     Memorial Hermann - Texas Medical Center Promoter

surveys |>
  fix_campus_names()
#> # A tibble: 6 × 4
#>   survey_name     UNIQUE_ID campus response 
#>   <chr>           <chr>     <chr>  <chr>    
#> 1 Pedi Inpatient  12345     CMHH   Promoter 
#> 2 Inpatient Rehab 23456     TMC    Passive  
#> 3 Inpatient Rehab 34567     TMC    Promoter 
#> 4 Inpatient       45678     TMC    Passive  
#> 5 Inpatient       56789     TMC    Detractor
#> 6 Inpatient       67890     TMC    Promoter
```
