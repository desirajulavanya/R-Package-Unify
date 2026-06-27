# Extract missing unit-time cells from a panel audit

`missing_cells()` extracts the missing unit-time combinations stored in
an audit object created by
[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).

## Usage

``` r
missing_cells(x)
```

## Arguments

- x:

  An object created by
  [`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).

## Value

A tibble containing missing unit-time combinations.

## Details

Missing cells are unit-time combinations that are implied by the full
unit-by-time grid but are not present in the original data.

This function does not re-audit the original dataset. It simply extracts
the missing-cell table already stored in the audit object.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md),
[`panel_gaps()`](https://desirajulavanya.github.io/panelbuild/reference/panel_gaps.md),
[`gap_summary()`](https://desirajulavanya.github.io/panelbuild/reference/gap_summary.md),
[`complete_panel()`](https://desirajulavanya.github.io/panelbuild/reference/complete_panel.md)

## Examples

``` r
audit <- audit_panel(example_panel, id = id, time = year)
missing_cells(audit)
#> # A tibble: 4 × 2
#>      id  year
#>   <dbl> <dbl>
#> 1     1  2022
#> 2     1  2023
#> 3     2  2021
#> 4     2  2023
```
