# Summarize a panel audit

`audit_summary()` converts an audit object created by
[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md)
into a one-row tibble of panel diagnostics.

## Usage

``` r
audit_summary(x)
```

## Arguments

- x:

  An object created by
  [`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md).

## Value

A one-row tibble with the following columns:

- `data`:

  Name of the audited object.

- `id`:

  Name of the panel unit column.

- `time`:

  Name of the time column.

- `n_units`:

  Number of unique panel units.

- `n_periods`:

  Number of unique time periods.

- `observed_rows`:

  Number of rows in the original data.

- `observed_id_time_cells`:

  Number of unique observed unit-time cells.

- `expected_cells`:

  Number of cells in the full unit-by-time grid.

- `missing_cells`:

  Number of missing unit-time cells.

- `duplicate_cells`:

  Number of duplicate unit-time cells.

- `balanced`:

  Logical indicator for whether the panel is balanced.

## Details

This function is useful when users want a compact, tabular summary of a
panel audit. The resulting tibble can be printed, saved, joined with
other metadata, or combined across multiple datasets.

The summary includes the number of units, number of time periods,
observed rows, observed unit-time cells, expected unit-time cells,
missing cells, duplicate cells, and a logical indicator for whether the
panel is balanced.

## See also

[`audit_panel()`](https://desirajulavanya.github.io/panelbuild/reference/audit_panel.md),
[`missing_cells()`](https://desirajulavanya.github.io/panelbuild/reference/missing_cells.md),
[`duplicate_cells()`](https://desirajulavanya.github.io/panelbuild/reference/duplicate_cells.md)

## Examples

``` r
audit <- audit_panel(example_panel, id = id, time = year)
audit_summary(audit)
#> # A tibble: 1 × 11
#>   data        id    time  n_units n_periods observed_rows observed_id_time_cells
#>   <chr>       <chr> <chr>   <int>     <int>         <int>                  <int>
#> 1 example_pa… id    year        3         4             9                      8
#> # ℹ 4 more variables: expected_cells <int>, missing_cells <int>,
#> #   duplicate_cells <int>, balanced <lgl>
```
