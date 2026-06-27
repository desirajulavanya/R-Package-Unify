# Extract duplicate unit-time cells from a panel audit

`duplicate_cells()` extracts duplicate unit-time combinations stored in
an audit object created by
[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).

## Usage

``` r
duplicate_cells(x)
```

## Arguments

- x:

  An object created by
  [`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).

## Value

A tibble containing duplicate unit-time combinations and a count column
`n`.

## Details

Duplicate cells are unit-time combinations that appear more than once in
the original data. The returned table includes a count column `n`
showing how many rows are present for each duplicated unit-time cell.

This function does not re-audit the original dataset. It simply extracts
the duplicate-cell table already stored in the audit object.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md),
[`panel_duplicates()`](https://desirajulavanya.github.io/panelbuild/reference/panel_duplicates.md),
[`duplicate_summary()`](https://desirajulavanya.github.io/panelbuild/reference/duplicate_summary.md),
[`flag_panel_issues()`](https://desirajulavanya.github.io/panelbuild/reference/flag_panel_issues.md)

## Examples

``` r
audit <- audit_panel(example_panel, id = id, time = year)
duplicate_cells(audit)
#>   id year n
#> 1  1 2021 2
```
