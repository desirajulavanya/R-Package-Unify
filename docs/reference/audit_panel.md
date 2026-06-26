# Audit a panel dataset

`audit_panel()` checks whether a dataset has the expected structure of a
panel dataset. It reports the number of panel units, time periods,
observed rows, unique unit-time cells, expected unit-time cells, missing
unit-time cells, duplicate unit-time cells, and whether the panel is
balanced.

## Usage

``` r
audit_panel(data, id, time)
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

An object of class `unifyr_panel_audit`. The object is a list containing
panel metadata, balance information, counts of missing and duplicate
unit-time cells, and data frames containing the missing and duplicate
cells.

## Details

A panel is treated as balanced when every observed panel unit appears in
every observed time period exactly once. Missing cells are unit-time
combinations that are implied by the full unit-by-time grid but are not
present in the data. Duplicate cells are unit-time combinations that
appear more than once.

`audit_panel()` does not modify the input data. It returns an audit
object that can be summarized with
[`audit_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_summary.md)
and inspected with accessor functions such as
[`missing_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/missing_cells.md)
and
[`duplicate_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/duplicate_cells.md).

## See also

[`audit_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/audit_summary.md),
[`missing_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/missing_cells.md),
[`duplicate_cells()`](https://desirajulavanya.github.io/R-Package-Unify/reference/duplicate_cells.md),
[`duplicate_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/duplicate_summary.md),
[`gap_summary()`](https://desirajulavanya.github.io/R-Package-Unify/reference/gap_summary.md),
[`complete_panel()`](https://desirajulavanya.github.io/R-Package-Unify/reference/complete_panel.md)

## Examples

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
