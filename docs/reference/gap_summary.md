# Summarize missing panel periods by unit

`gap_summary()` reports how many time periods are missing for each panel
unit.

## Usage

``` r
gap_summary(data, id, time)
```

## Arguments

- data:

  A data frame or tibble.

- id:

  Unquoted column name identifying the panel unit.

- time:

  Unquoted column name identifying the time period.

## Value

A tibble with one row per panel unit and a column
`unifyr_missing_periods` giving the number of missing time periods for
that unit. If no gaps are present, all units are returned with zero
missing periods.

## Details

This function summarizes the missing unit-time cells returned by
[`panel_gaps()`](https://desirajulavanya.github.io/R-Package-Unify/reference/panel_gaps.md)
at the panel-unit level. It is useful for identifying which units
contribute most to panel imbalance.

The function does not modify, complete, or impute the input data.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_panel.md),
[`panel_gaps()`](https://desirajulavanya.github.io/R-Package-Unify/reference/panel_gaps.md),
[`missing_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/missing_cells.md),
[`complete_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/complete_panel.md)

## Examples

``` r
gap_summary(example_panel, id = id, time = year)
#> # A tibble: 2 × 2
#>      id unifyr_missing_periods
#>   <dbl>                  <int>
#> 1     1                      2
#> 2     2                      2
```
