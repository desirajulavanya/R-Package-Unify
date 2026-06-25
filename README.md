
# unifyr

`unifyr` provides tools for auditing, validating, and preparing panel
datasets before statistical analysis.

## Installation

You can install the development version of `unifyr` from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("desirajulavanya/R-Package-Unify")
```

## Why unifyr?

Panel datasets often contain missing unit-time cells, duplicate
observations, irregular time gaps, and imbalance. These issues can
affect fixed effects models, difference-in-differences designs, event
studies, and other panel-data methods.

`unifyr` helps researchers identify and document these problems before
estimation.

## Basic example

``` r
library(unifyr)

panel_data <- data.frame(
  id = c(1, 1, 1, 2, 2, 3, 3, 3, 3),
  year = c(2020, 2021, 2021, 2020, 2022, 2020, 2021, 2022, 2023),
  outcome = c(10, 12, 13, 20, 25, 30, 31, 32, 33)
)

panel_data
```

    ##   id year outcome
    ## 1  1 2020      10
    ## 2  1 2021      12
    ## 3  1 2021      13
    ## 4  2 2020      20
    ## 5  2 2022      25
    ## 6  3 2020      30
    ## 7  3 2021      31
    ## 8  3 2022      32
    ## 9  3 2023      33

## Audit a panel dataset

``` r
audit_panel(panel_data, id = id, time = year)
```

    ## Panel audit
    ## 
    ## Data: panel_data
    ## Unit variable: id
    ## Time variable: year
    ## 
    ## Units: 3
    ## Time periods: 4
    ## Observed rows: 9
    ## Observed id-time cells: 8
    ## Expected id-time cells: 12
    ## Missing id-time cells: 4
    ## Duplicate id-time cells: 1
    ## Balanced panel: No

## Find duplicate unit-time observations

``` r
duplicate_summary(panel_data, id = id, time = year)
```

    ## # A tibble: 1 × 3
    ##      id unfiy_duplicate_cells unfiy_duplicate_extra_rows
    ##   <dbl>                 <int>                      <int>
    ## 1     1                     1                          1

## Summarize panel gaps

``` r
gap_summary(panel_data, id = id, time = year)
```

    ## # A tibble: 2 × 2
    ##      id unfiy_missing_periods
    ##   <dbl>                 <int>
    ## 1     1                     2
    ## 2     2                     2

## Flag row-level panel issues

``` r
flag_panel_issues(panel_data, id = id, time = year)
```

    ## # A tibble: 9 × 6
    ##      id  year outcome unfiy_row_id unfiy_id_time_n unfiy_duplicate_cell
    ##   <dbl> <dbl>   <dbl>        <int>           <int> <lgl>               
    ## 1     1  2020      10            1               1 FALSE               
    ## 2     1  2021      12            2               2 TRUE                
    ## 3     1  2021      13            3               2 TRUE                
    ## 4     2  2020      20            4               1 FALSE               
    ## 5     2  2022      25            5               1 FALSE               
    ## 6     3  2020      30            6               1 FALSE               
    ## 7     3  2021      31            7               1 FALSE               
    ## 8     3  2022      32            8               1 FALSE               
    ## 9     3  2023      33            9               1 FALSE

## Complete the panel grid

`complete_panel()` creates a full unit-time grid while preserving
observed values. It does not impute missing outcomes.

Because `complete_panel()` requires unique id-time cells, we first
create a version of the example data without duplicates.

``` r
panel_data_unique <- panel_data |>
  dplyr::distinct(id, year, .keep_all = TRUE)

complete_panel(panel_data_unique, id = id, time = year)
```

    ## # A tibble: 12 × 6
    ##       id  year outcome unfiy_original_row unfiy_completed_cell
    ##    <dbl> <dbl>   <dbl> <lgl>              <lgl>               
    ##  1     1  2020      10 TRUE               FALSE               
    ##  2     1  2021      12 TRUE               FALSE               
    ##  3     1  2022      NA FALSE              TRUE                
    ##  4     1  2023      NA FALSE              TRUE                
    ##  5     2  2020      20 TRUE               FALSE               
    ##  6     2  2021      NA FALSE              TRUE                
    ##  7     2  2022      25 TRUE               FALSE               
    ##  8     2  2023      NA FALSE              TRUE                
    ##  9     3  2020      30 TRUE               FALSE               
    ## 10     3  2021      31 TRUE               FALSE               
    ## 11     3  2022      32 TRUE               FALSE               
    ## 12     3  2023      33 TRUE               FALSE               
    ## # ℹ 1 more variable: unfiy_audit_action <chr>

## Main functions

- `audit_panel()` gives a full panel diagnostic summary.
- `duplicate_summary()` finds duplicate unit-time observations.
- `gap_summary()` summarizes missing time periods by unit.
- `flag_panel_issues()` flags row-level panel problems.
- `complete_panel()` creates a complete panel grid without imputing
  observed variables.

## Package goal

The goal of `unifyr` is to provide a transparent and reproducible
workflow for panel-data quality assurance before statistical modeling.
