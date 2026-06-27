#' Create a panel audit report
#'
#' `audit_report()` prints a concise, human-readable report from an audit object
#' created by [audit_panel()].
#'
#' @details
#' The report summarizes the panel structure, balance status, missing unit-time
#' cells, duplicate unit-time cells, and recommended next steps. This is a
#' lightweight console report and does not create files or modify the data.
#'
#' @param x An object created by [audit_panel()].
#'
#' @return
#' Invisibly returns `x`, the input audit object.
#'
#' @seealso
#' [audit_panel()], [audit_summary()], [missing_cells()], [duplicate_cells()]
#'
#' @examples
#' audit <- audit_panel(example_panel, id = id, time = year)
#' audit_report(audit)
#'
#' @export
audit_report <- function(x) {
  if (!inherits(x, "unifyr_panel_audit")) {
    stop("`x` must be an object created by `audit_panel()`.", call. = FALSE)
  }

  cat("unifyr Panel Audit Report\n")
  cat("==========================\n\n")

  cat("Dataset\n")
  cat("-------\n")
  cat("Data: ", x$data_name, "\n", sep = "")
  cat("Unit variable: ", x$id, "\n", sep = "")
  cat("Time variable: ", x$time, "\n\n", sep = "")

  cat("Panel structure\n")
  cat("---------------\n")
  cat("Units: ", x$n_units, "\n", sep = "")
  cat("Time periods: ", x$n_periods, "\n", sep = "")
  cat("Observed rows: ", x$observed_rows, "\n", sep = "")
  cat("Observed unit-time cells: ", x$observed_id_time_cells, "\n", sep = "")
  cat("Expected unit-time cells: ", x$expected_cells, "\n", sep = "")
  cat("Missing unit-time cells: ", x$missing_cells, "\n", sep = "")
  cat("Duplicate unit-time cells: ", x$duplicate_cells, "\n", sep = "")
  cat("Balanced panel: ", ifelse(x$balanced, "Yes", "No"), "\n\n", sep = "")

  cat("Recommended next steps\n")
  cat("----------------------\n")

  if (x$balanced) {
    cat("* No missing or duplicate unit-time cells detected.\n")
    cat("* The panel appears balanced under the observed unit-time grid.\n")
  } else {
    if (x$duplicate_cells > 0) {
      cat("* Resolve duplicate unit-time observations before completing the panel.\n")
      cat("* Use `duplicate_cells(audit)` or `duplicate_summary()` to inspect duplicates.\n")
    }

    if (x$missing_cells > 0) {
      cat("* Inspect missing unit-time cells before estimation.\n")
      cat("* Use `missing_cells(audit)` or `gap_summary()` to review panel gaps.\n")
      cat("* Use `complete_panel()` only after duplicate unit-time cells are resolved.\n")
    }
  }

  invisible(x)
}
