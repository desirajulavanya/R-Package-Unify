#' Flag panel data issues
#'
#' `flag_panel_issues()` adds transparent row-level audit flags to a panel
#' dataset. It does not modify, complete, or impute the data.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble with additional audit columns:
#'   `unfiy_row_id`, `unfiy_id_time_n`, and `unfiy_duplicate_cell`.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B", "B", "B"),
#'   year = c(2020, 2021, 2020, 2021, 2021),
#'   wage = c(100, 110, 90, 95, 96)
#' )
#'
#' flag_panel_issues(df, id = district, time = year)
#'
#' @export
flag_panel_issues <- function(data, id, time) {
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

  flagged <- data |>
    tibble::as_tibble() |>
    dplyr::mutate(unfiy_row_id = dplyr::row_number()) |>
    dplyr::group_by(!!id_quo, !!time_quo) |>
    dplyr::mutate(
      unfiy_id_time_n = dplyr::n(),
      unfiy_duplicate_cell = .data$unfiy_id_time_n > 1
    ) |>
    dplyr::ungroup()

  attr(flagged, "unfiy_id") <- id_name
  attr(flagged, "unfiy_time") <- time_name
  attr(flagged, "unfiy_audit_note") <- paste0(
    "Rows were flagged by `flag_panel_issues()` using id = ",
    id_name,
    " and time = ",
    time_name,
    ". No rows were added, removed, completed, or imputed."
  )

  flagged
}
