# Example Panel Dataset

A small example panel dataset for demonstrating panel-data auditing.

## Usage

``` r
example_panel
```

## Format

A data frame with 9 rows and 4 variables:

- id:

  Panel unit identifier.

- year:

  Time period.

- outcome:

  Example outcome variable.

- treatment:

  Example treatment indicator.

## Details

The dataset intentionally includes one duplicate unit-time observation
and missing unit-time cells so that users can test `unifyr` diagnostics.

## Examples

``` r
data(example_panel)
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
