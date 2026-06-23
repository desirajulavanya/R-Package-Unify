#' Summarize a panel audit as a tibble
#'
#' `audit_summary()` converts an `unfiy_panel_audit` object into a one-row
#' tibble. This is useful for storing audit results, comparing datasets, and
#' building reproducible data reports.
#'
#' @param x An object created by [audit_panel()].
#'
#' @return A one-row tibble with panel audit statistics.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B"),
#'   year = c(2020, 2021, 2020),
#'   wage = c(100, 110, 90)
#' )
#'
#' audit <- audit_panel(df, id = district, time = year)
#' audit_summary(audit)
#'
#' @export
audit_summary <- function(x) {
  if (!inherits(x, "unfiy_panel_audit")) {
    stop("`x` must be an object created by `audit_panel()`.", call. = FALSE)
  }

  tibble::tibble(
    data = x$data_name,
    id = x$id,
    time = x$time,
    n_units = x$n_units,
    n_periods = x$n_periods,
    observed_rows = x$observed_rows,
    observed_id_time_cells = x$observed_id_time_cells,
    expected_cells = x$expected_cells,
    missing_cells = x$missing_cells,
    duplicate_cells = x$duplicate_cells,
    balanced = x$balanced
  )
}
