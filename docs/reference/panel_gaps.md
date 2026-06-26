# Identify missing unit-time cells

`panel_gaps()` returns the missing unit-time combinations implied by the
full panel grid.

## Usage

``` r
panel_gaps(data, id, time)
```

## Arguments

- data:

  A data frame or tibble.

- id:

  Unquoted column name identifying the panel unit.

- time:

  Unquoted column name identifying the time period.

## Value

A tibble containing missing unit-time combinations.

## Details

A missing unit-time cell is a combination of an observed panel unit and
an observed time period that does not appear in the data. For example,
if unit `A` appears in 2020 and 2022, and 2021 is an observed time
period elsewhere in the dataset, then `A`-2021 is treated as a missing
unit-time cell.

This function is a data-frame interface to the missing-cell information
produced by
[`audit_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_panel.md).
It does not modify, complete, or impute the input data.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_panel.md),
[`missing_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/missing_cells.md),
[`gap_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/gap_summary.md),
[`complete_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/complete_panel.md)

## Examples

``` r
panel_gaps(example_panel, id = id, time = year)
#> # A tibble: 4 × 2
#>      id  year
#>   <dbl> <dbl>
#> 1     1  2022
#> 2     1  2023
#> 3     2  2021
#> 4     2  2023
```
