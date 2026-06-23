#' Complete a panel dataset with an audit trail
#'
#' `complete_panel()` expands a panel dataset so that every observed unit has
#' every observed time period. Newly created id-time cells are explicitly
#' flagged. The function does not impute values for substantive variables.
#'
#' @param data A data frame or tibble.
#' @param id Unquoted column name identifying the panel unit.
#' @param time Unquoted column name identifying the time period.
#'
#' @return A tibble with completed id-time cells and audit columns:
#'   `unfiy_original_row`, `unfiy_completed_cell`, and `unfiy_audit_action`.
#'
#' @examples
#' df <- tibble::tibble(
#'   district = c("A", "A", "B"),
#'   year = c(2020, 2021, 2020),
#'   wage = c(100, 110, 90)
#' )
#'
#' complete_panel(df, id = district, time = year)
#'
#' @export
complete_panel <- function(data, id, time) {
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

  audit <- audit_panel(data, id = !!id_quo, time = !!time_quo)

  if (audit$duplicate_cells > 0) {
    stop(
      paste0(
        "`complete_panel()` cannot complete a panel with duplicate id-time cells.\n",
        "Resolve duplicates first. Use `duplicate_cells(audit_panel(data, id, time))` ",
        "to inspect them."
      ),
      call. = FALSE
    )
  }

  original <- data |>
    tibble::as_tibble() |>
    dplyr::mutate(
      unfiy_original_row = TRUE
    )

  completed <- original |>
    tidyr::complete(
      !!id_quo,
      !!time_quo
    ) |>
    dplyr::mutate(
      unfiy_original_row = dplyr::coalesce(.data$unfiy_original_row, FALSE),
      unfiy_completed_cell = !.data$unfiy_original_row,
      unfiy_audit_action = dplyr::if_else(
        .data$unfiy_completed_cell,
        "added_missing_id_time_cell_no_imputation",
        "original_observation"
      )
    )

  attr(completed, "unfiy_id") <- id_name
  attr(completed, "unfiy_time") <- time_name
  attr(completed, "unfiy_completed_cells") <- sum(completed$unfiy_completed_cell)
  attr(completed, "unfiy_audit_note") <- paste0(
    "`complete_panel()` completed the id-time grid using id = ",
    id_name,
    " and time = ",
    time_name,
    ". Newly created rows are flagged with `unfiy_completed_cell = TRUE`. ",
    "No substantive variables were imputed."
  )

  completed
}
