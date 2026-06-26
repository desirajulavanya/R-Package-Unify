# Getting Started with unifyr

## Introduction

`unifyr` provides tools for auditing, validating, and preparing panel
datasets before statistical analysis.

Panel datasets often contain duplicate unit-time observations, missing
time periods, irregular gaps, and imbalance. These issues can affect
fixed effects models, difference-in-differences designs, event studies,
and other panel-data methods.

The goal of `unifyr` is to help users identify these issues before
estimation.

## Load the package

``` r

library(unifyr)
```

## Example panel dataset

`unifyr` includes a small example dataset called `example_panel`.

``` r

data(example_panel)

example_panel
#>   id year outcome treatment
#> 1  1 2020      10         0
#> 2  1 2021      12         1
#> 3  1 2021      13         1
#> 4  2 2020      20         0
#> 5  2 2022      25         1
#> 6  3 2020      30         0
#> 7  3 2021      31         0
#> 8  3 2022      32         1
#> 9  3 2023      33         1
```

The dataset intentionally includes:

- a duplicate unit-time observation
- missing unit-time cells
- an unbalanced panel structure

This makes it useful for demonstrating panel-data diagnostics.

## Audit the panel

The main function is
[`audit_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_panel.md).

``` r

audit_panel(example_panel, id = id, time = year)
#> Panel audit
#> 
#> Data: example_panel
#> Unit variable: id
#> Time variable: year
#> 
#> Units: 3
#> Time periods: 4
#> Observed rows: 9
#> Observed id-time cells: 8
#> Expected id-time cells: 12
#> Missing id-time cells: 4
#> Duplicate id-time cells: 1
#> Balanced panel: No
```

This gives a quick overview of the panel structure, including whether
the panel is balanced and whether there are missing or duplicate
unit-time cells.

## Find duplicate observations

Duplicate unit-time observations are a common problem in panel datasets.

``` r

duplicate_summary(example_panel, id = id, time = year)
#> # A tibble: 1 × 3
#>      id unifyr_duplicate_cells unifyr_duplicate_extra_rows
#>   <dbl>                  <int>                       <int>
#> 1     1                      1                           1
```

## Summarize gaps

[`gap_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/gap_summary.md)
identifies missing time periods by panel unit.

``` r

gap_summary(example_panel, id = id, time = year)
#> # A tibble: 2 × 2
#>      id unifyr_missing_periods
#>   <dbl>                  <int>
#> 1     1                      2
#> 2     2                      2
```

## Flag row-level issues

[`flag_panel_issues()`](https://desirajulavanya.github.io/R-Package-Unify/reference/flag_panel_issues.md)
adds diagnostic flags to the data.

``` r

flag_panel_issues(example_panel, id = id, time = year)
#> # A tibble: 9 × 7
#>      id  year outcome treatment unifyr_row_id unifyr_id_time_n
#>   <dbl> <dbl>   <dbl>     <dbl>         <int>            <int>
#> 1     1  2020      10         0             1                1
#> 2     1  2021      12         1             2                2
#> 3     1  2021      13         1             3                2
#> 4     2  2020      20         0             4                1
#> 5     2  2022      25         1             5                1
#> 6     3  2020      30         0             6                1
#> 7     3  2021      31         0             7                1
#> 8     3  2022      32         1             8                1
#> 9     3  2023      33         1             9                1
#> # ℹ 1 more variable: unifyr_duplicate_cell <lgl>
```

## Complete a panel grid

[`complete_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/complete_panel.md)
creates a complete unit-time grid. It does not impute missing outcome
values.

Because
[`complete_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/complete_panel.md)
requires unique unit-time cells, we first remove duplicate id-time
observations from the example dataset.

``` r

example_panel_unique <- example_panel |>
  dplyr::distinct(id, year, .keep_all = TRUE)

complete_panel(example_panel_unique, id = id, time = year)
#> # A tibble: 12 × 7
#>       id  year outcome treatment unifyr_original_row unifyr_completed_cell
#>    <dbl> <dbl>   <dbl>     <dbl> <lgl>               <lgl>                
#>  1     1  2020      10         0 TRUE                FALSE                
#>  2     1  2021      12         1 TRUE                FALSE                
#>  3     1  2022      NA        NA FALSE               TRUE                 
#>  4     1  2023      NA        NA FALSE               TRUE                 
#>  5     2  2020      20         0 TRUE                FALSE                
#>  6     2  2021      NA        NA FALSE               TRUE                 
#>  7     2  2022      25         1 TRUE                FALSE                
#>  8     2  2023      NA        NA FALSE               TRUE                 
#>  9     3  2020      30         0 TRUE                FALSE                
#> 10     3  2021      31         0 TRUE                FALSE                
#> 11     3  2022      32         1 TRUE                FALSE                
#> 12     3  2023      33         1 TRUE                FALSE                
#> # ℹ 1 more variable: unifyr_audit_action <chr>
```

## Typical workflow

A typical `unifyr` workflow is:

``` r

library(unifyr)

audit_panel(my_data, id = unit_id, time = year)

duplicate_summary(my_data, id = unit_id, time = year)

gap_summary(my_data, id = unit_id, time = year)

clean_data <- my_data |>
  dplyr::distinct(unit_id, year, .keep_all = TRUE)

complete_panel(clean_data, id = unit_id, time = year)
```

## Summary

`unifyr` is designed to provide a transparent and reproducible workflow
for panel-data quality assurance.

Use it before fitting panel models, difference-in-differences designs,
event studies, or other longitudinal-data analyses.
