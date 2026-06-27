# panelbuild 0.1.0

* Initial development release of `panelbuild`.
* Added `audit_panel()` for summarizing panel structure, balance, missing cells, and duplicate unit-time observations.
* Added `duplicate_summary()` for identifying duplicate unit-time cells.
* Added `gap_summary()` for summarizing missing time periods by panel unit.
* Added `flag_panel_issues()` for row-level panel diagnostics.
* Added `complete_panel()` for creating complete unit-time grids without imputing observed variables.
* Added README examples and package documentation.
* Added `audit_report()` for printing a concise panel audit report with recommended next steps.
