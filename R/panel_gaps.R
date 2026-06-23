#' Identify gaps in a panel dataset
#'
#' `panel_gaps()` returns the missing id-time combinations in a panel dataset.
#' It is a direct data-frame interface to the missing-cell information produced
#' by [audit_panel()].
#'
#' The function does not modify, complete, or impute the data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble containing missing id-time combinations.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B"),
#'   year = c(2020, 2021, 2020),
#'   wage = c(100, 110, 90)
#' )
#'
#' panel_gaps(df, id = district, time = year)
#'
#' @export
panel_gaps <- function(data, id, time) {
  if (!inherits(data, "data.frame")) {
    stop("`data` must be a data frame or tibble.", call. = FALSE)
  }

  id_quo <- rlang::enquo(id)
  time_quo <- rlang::enquo(time)

  audit <- audit_panel(data, id = !!id_quo, time = !!time_quo)

  missing_cells(audit)
}



#' Summarize panel gaps by unit
#'
#' `gap_summary()` reports how many time periods are missing for each panel
#' unit.
#'
#' The function does not modify, complete, or impute the data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble with one row per unit and the number of missing periods.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B", "C", "C"),
#'   year = c(2020, 2021, 2020, 2020, 2022),
#'   wage = c(100, 110, 90, 80, 85)
#' )
#'
#' gap_summary(df, id = district, time = year)
#'
#' @export
gap_summary <- function(data, id, time) {
  if (!inherits(data, "data.frame")) {
    stop("`data` must be a data frame or tibble.", call. = FALSE)
  }

  id_quo <- rlang::enquo(id)

  gaps <- panel_gaps(data, id = !!id_quo, time = {{ time }})

  if (nrow(gaps) == 0) {
    id_name <- rlang::as_name(id_quo)

    ids <- data |>
      dplyr::distinct(!!id_quo)

    return(
      ids |>
        dplyr::mutate(unfiy_missing_periods = 0L) |>
        dplyr::arrange(!!id_quo)
    )
  }

  gaps |>
    dplyr::count(!!id_quo, name = "unfiy_missing_periods") |>
    dplyr::arrange(dplyr::desc(.data$unfiy_missing_periods), !!id_quo)
}
