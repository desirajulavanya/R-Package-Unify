# Complete a panel dataset with an audit trail

`complete_panel()` expands a panel dataset so that every observed panel
unit appears in every observed time period. Newly created unit-time
cells are flagged with audit columns, and substantive variables are left
missing.

## Usage

``` r
complete_panel(data, id, time)
```

## Arguments

- data:

  A data frame or tibble.

- id:

  Unquoted column name identifying the panel unit, such as a person,
  firm, district, county, or country.

- time:

  Unquoted column name identifying the time period, such as a year,
  month, quarter, or date.

## Value

A tibble containing the completed panel grid. The returned data include
the original columns plus the following audit columns:

- `panelbuild_original_row`:

  Logical indicator for rows present in the original data.

- `panelbuild_completed_cell`:

  Logical indicator for rows created by `complete_panel()`.

- `panelbuild_audit_action`:

  Character label describing whether a row was original or added during
  panel completion.

The returned tibble also includes attributes documenting the panel
identifier, time variable, number of completed cells, and audit note.

## Details

The function first audits the panel using
[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).
If duplicate unit-time cells are present, the function stops with an
error. This is intentional: completing a panel with duplicate unit-time
observations can produce ambiguous results.

`complete_panel()` does not impute outcomes, covariates, treatment
variables, or any other substantive variables. It only creates the
missing unit-time rows implied by the full unit-by-time grid. Newly
created rows are flagged using audit columns.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md),
[`missing_cells()`](https://desirajulavanya.github.io/panelbuild/reference/missing_cells.md),
[`gap_summary()`](https://desirajulavanya.github.io/panelbuild/reference/gap_summary.md),
[`duplicate_summary()`](https://desirajulavanya.github.io/panelbuild/reference/duplicate_summary.md)

## Examples

``` r
panel_unique <- example_panel |>
  dplyr::distinct(id, year, .keep_all = TRUE)

complete_panel(panel_unique, id = id, time = year)
#> # A tibble: 12 × 7
#>       id  year outcome treatment panelbuild_original_row panelbuild_completed_…¹
#>    <dbl> <dbl>   <dbl>     <dbl> <lgl>                   <lgl>                  
#>  1     1  2020      10         0 TRUE                    FALSE                  
#>  2     1  2021      12         1 TRUE                    FALSE                  
#>  3     1  2022      NA        NA FALSE                   TRUE                   
#>  4     1  2023      NA        NA FALSE                   TRUE                   
#>  5     2  2020      20         0 TRUE                    FALSE                  
#>  6     2  2021      NA        NA FALSE                   TRUE                   
#>  7     2  2022      25         1 TRUE                    FALSE                  
#>  8     2  2023      NA        NA FALSE                   TRUE                   
#>  9     3  2020      30         0 TRUE                    FALSE                  
#> 10     3  2021      31         0 TRUE                    FALSE                  
#> 11     3  2022      32         1 TRUE                    FALSE                  
#> 12     3  2023      33         1 TRUE                    FALSE                  
#> # ℹ abbreviated name: ¹​panelbuild_completed_cell
#> # ℹ 1 more variable: panelbuild_audit_action <chr>
```
