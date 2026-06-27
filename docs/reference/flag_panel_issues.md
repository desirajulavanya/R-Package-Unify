# Flag row-level panel data issues

`flag_panel_issues()` adds row-level audit flags to a panel dataset. It
identifies duplicate unit-time observations while preserving the
original data structure.

## Usage

``` r
flag_panel_issues(data, id, time)
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

A tibble containing the original data plus row-level audit columns:

- `panelbuild_row_id`:

  Integer row identifier based on the original row order.

- `panelbuild_id_time_n`:

  Number of rows with the same unit-time combination.

- `panelbuild_duplicate_cell`:

  Logical indicator for rows that belong to a duplicate unit-time cell.

The returned tibble also includes attributes documenting the panel
identifier, time variable, and audit note.

## Details

This function is useful when users want to inspect problematic rows
directly rather than only receiving a summary table. It adds diagnostic
columns that indicate how many times each unit-time cell appears and
whether the row is part of a duplicate cell.

`flag_panel_issues()` does not add rows, remove rows, complete the
panel, or impute missing values.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md),
[`duplicate_summary()`](https://desirajulavanya.github.io/panelbuild/reference/duplicate_summary.md),
[`duplicate_cells()`](https://desirajulavanya.github.io/panelbuild/reference/duplicate_cells.md),
[`complete_panel()`](https://desirajulavanya.github.io/panelbuild/reference/complete_panel.md)

## Examples

``` r
flag_panel_issues(example_panel, id = id, time = year)
#> # A tibble: 9 × 7
#>      id  year outcome treatment panelbuild_row_id panelbuild_id_time_n
#>   <dbl> <dbl>   <dbl>     <dbl>             <int>                <int>
#> 1     1  2020      10         0                 1                    1
#> 2     1  2021      12         1                 2                    2
#> 3     1  2021      13         1                 3                    2
#> 4     2  2020      20         0                 4                    1
#> 5     2  2022      25         1                 5                    1
#> 6     3  2020      30         0                 6                    1
#> 7     3  2021      31         0                 7                    1
#> 8     3  2022      32         1                 8                    1
#> 9     3  2023      33         1                 9                    1
#> # ℹ 1 more variable: panelbuild_duplicate_cell <lgl>
```
