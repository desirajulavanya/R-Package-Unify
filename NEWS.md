# panelbuild 0.1.0

## Initial CRAN release

### New features

* Initial release of **panelbuild**, a package for auditing, validating, and preparing panel datasets.
* Added `audit_panel()` to summarize panel structure, balance, missing unit-time cells, and duplicate unit-time cells.
* Added `audit_report()` to generate a concise, human-readable audit report with recommended next steps.
* Added `panel_gaps()` and `gap_summary()` to identify and summarize missing unit-time cells.
* Added `panel_duplicates()` and `duplicate_summary()` to identify and summarize duplicate unit-time cells.
* Added `flag_panel_issues()` to create row-level audit flags without modifying the original data.
* Added `complete_panel()` to construct a complete unit-time panel while preserving an explicit audit trail.
* Added helper functions `audit_summary()`, `missing_cells()`, and `duplicate_cells()` for working with audit objects.
* Included the `example_panel` dataset for documentation, examples, and testing.
* Added a getting-started vignette, comprehensive function documentation, unit tests, and a pkgdown website.
