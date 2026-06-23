#' Identify duplicate id-time cells in a panel dataset
#'
#' `panel_duplicates()` returns id-time combinations that appear more than once
#' in a panel dataset.
#'
#' The function does not modify, drop, aggregate, or impute the data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble containing duplicate id-time combinations and counts.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B", "B", "B"),
#'   year = c(2020, 2021, 2020, 2021, 2021),
#'   wage = c(100, 110, 90, 95, 96)
#' )
#'
#' panel_duplicates(df, id = district, time = year)
#'
#' @export
panel_duplicates <- function(data, id, time) {
  if (!inherits(data, "data.frame")) {
    stop("`data` must be a data frame or tibble.", call. = FALSE)
  }

  id_quo <- rlang::enquo(id)
  time_quo <- rlang::enquo(time)

  audit <- audit_panel(data, id = !!id_quo, time = !!time_quo)

  duplicate_cells(audit)
}


#' Summarize duplicate id-time cells by unit
#'
#' `duplicate_summary()` reports how many duplicate id-time cells each panel
#' unit has.
#'
#' The function does not modify, drop, aggregate, or impute the data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble with one row per unit and duplicate-cell diagnostics.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B", "B", "B", "C", "C", "C"),
#'   year = c(2020, 2021, 2020, 2021, 2021, 2020, 2020, 2021),
#'   wage = c(100, 110, 90, 95, 96, 80, 81, 85)
#' )
#'
#' duplicate_summary(df, id = district, time = year)
#'
#' @export
duplicate_summary <- function(data, id, time) {
  if (!inherits(data, "data.frame")) {
    stop("`data` must be a data frame or tibble.", call. = FALSE)
  }

  id_quo <- rlang::enquo(id)
  time_quo <- rlang::enquo(time)

  id_name <- rlang::as_name(id_quo)

  duplicates <- panel_duplicates(data, id = !!id_quo, time = !!time_quo)

  if (nrow(duplicates) == 0) {
    return(
      data |>
        dplyr::distinct(!!id_quo) |>
        dplyr::mutate(
          unfiy_duplicate_cells = 0L,
          unfiy_duplicate_extra_rows = 0L
        ) |>
        dplyr::arrange(!!id_quo)
    )
  }

  duplicates |>
    dplyr::mutate(unfiy_extra_rows = .data$n - 1L) |>
    dplyr::group_by(!!id_quo) |>
    dplyr::summarise(
      unfiy_duplicate_cells = dplyr::n(),
      unfiy_duplicate_extra_rows = sum(.data$unfiy_extra_rows),
      .groups = "drop"
    ) |>
    dplyr::arrange(
      dplyr::desc(.data$unfiy_duplicate_cells),
      !!id_quo
    )
}
