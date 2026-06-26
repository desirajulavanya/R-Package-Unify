# Identify duplicate unit-time cells

`panel_duplicates()` returns unit-time combinations that appear more
than once in a panel dataset.

## Usage

``` r
panel_duplicates(data, id, time)
```

## Arguments

- data:

  A data frame or tibble.

- id:

  Unquoted column name identifying the panel unit.

- time:

  Unquoted column name identifying the time period.

## Value

A tibble containing duplicate unit-time combinations and a count column
`n`.

## Details

Duplicate unit-time cells occur when the same panel unit appears more
than once in the same time period. These duplicates can create problems
for panel completion, fixed effects models, difference-in-differences
designs, and other longitudinal-data workflows.

The function does not modify, drop, aggregate, or impute the data.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_panel.md),
[`duplicate_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/duplicate_summary.md),
[`duplicate_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/duplicate_cells.md),
[`flag_panel_issues()`](https://desirajulavanya.github.io/R-Package-Unify/reference/flag_panel_issues.md)

## Examples

``` r
panel_duplicates(example_panel, id = id, time = year)
#>   id year n
#> 1  1 2021 2
```
