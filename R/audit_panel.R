#' Audit a panel dataset
#'
#' `audit_panel()` checks the basic structure of a panel dataset. It reports
#' the number of units, time periods, observed rows, expected rows, missing
#' id-time cells, duplicate id-time cells, and whether the panel is balanced.
#'
#' The function does not modify the input data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return An object of class `unfiy_panel_audit`.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B", "B", "B"),
#'   year = c(2020, 2021, 2020, 2021, 2021),
#'   wage = c(100, 110, 90, 95, 96)
#' )
#'
#' audit_panel(df, id = district, time = year)
#'
#' @export
audit_panel <- function(data, id, time) {
  if (!inherits(data, "data.frame")) {
    stop("`data` must be a data frame or tibble.", call. = FALSE)
  }

  id_quo <- rlang::enquo(id)
  time_quo <- rlang::enquo(time)

  id_name <- rlang::as_name(id_quo)
  time_name <- rlang::as_name(time_quo)

  if (!id_name %in% names(data)) {
    stop("`id` column not found in `data`.", call. = FALSE)
  }

  if (!time_name %in% names(data)) {
    stop("`time` column not found in `data`.", call. = FALSE)
  }

  panel_keys <- data |>
    dplyr::select(!!id_quo, !!time_quo)

  duplicate_cells <- panel_keys |>
    dplyr::count(!!id_quo, !!time_quo, name = "n") |>
    dplyr::filter(.data$n > 1)

  unique_keys <- panel_keys |>
    dplyr::distinct()

  ids <- unique_keys |>
    dplyr::distinct(!!id_quo)

  times <- unique_keys |>
    dplyr::distinct(!!time_quo)

  expected_grid <- tidyr::expand_grid(
    ids,
    times
  )

  missing_cells <- expected_grid |>
    dplyr::anti_join(unique_keys, by = c(id_name, time_name))

  observed_rows <- nrow(data)
  observed_id_time_cells <- nrow(unique_keys)
  n_units <- nrow(ids)
  n_periods <- nrow(times)
  expected_cells <- n_units * n_periods
  n_missing_cells <- nrow(missing_cells)
  n_duplicate_cells <- nrow(duplicate_cells)

  balanced <- n_missing_cells == 0 && n_duplicate_cells == 0

  out <- list(
    data_name = deparse(substitute(data)),
    id = id_name,
    time = time_name,
    n_units = n_units,
    n_periods = n_periods,
    observed_rows = observed_rows,
    observed_id_time_cells = observed_id_time_cells,
    expected_cells = expected_cells,
    missing_cells = n_missing_cells,
    duplicate_cells = n_duplicate_cells,
    balanced = balanced,
    missing_data = missing_cells,
    duplicate_data = duplicate_cells
  )

  class(out) <- "unfiy_panel_audit"

  out
}

#' @export
print.unfiy_panel_audit <- function(x, ...) {
  cat("Panel audit\n")
  cat("\n")
  cat("Data: ", x$data_name, "\n", sep = "")
  cat("Unit variable: ", x$id, "\n", sep = "")
  cat("Time variable: ", x$time, "\n", sep = "")
  cat("\n")
  cat("Units: ", x$n_units, "\n", sep = "")
  cat("Time periods: ", x$n_periods, "\n", sep = "")
  cat("Observed rows: ", x$observed_rows, "\n", sep = "")
  cat("Observed id-time cells: ", x$observed_id_time_cells, "\n", sep = "")
  cat("Expected id-time cells: ", x$expected_cells, "\n", sep = "")
  cat("Missing id-time cells: ", x$missing_cells, "\n", sep = "")
  cat("Duplicate id-time cells: ", x$duplicate_cells, "\n", sep = "")
  cat("Balanced panel: ", ifelse(x$balanced, "Yes", "No"), "\n", sep = "")

  invisible(x)
}

