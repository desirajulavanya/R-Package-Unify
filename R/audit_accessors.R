#' Extract missing panel cells
#'
#' `missing_cells()` extracts the missing id-time combinations from an
#' `unfiy_panel_audit` object.
#'
#' @param x An object created by [audit_panel()].
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
#' audit <- audit_panel(df, id = district, time = year)
#' missing_cells(audit)
#'
#' @export
missing_cells <- function(x) {
  if (!inherits(x, "unfiy_panel_audit")) {
    stop("`x` must be an object created by `audit_panel()`.", call. = FALSE)
  }

  x$missing_data
}


#' Extract duplicate panel cells
#'
#' `duplicate_cells()` extracts duplicate id-time combinations from an
#' `unfiy_panel_audit` object.
#'
#' @param x An object created by [audit_panel()].
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
#' audit <- audit_panel(df, id = district, time = year)
#' duplicate_cells(audit)
#'
#' @export
duplicate_cells <- function(x) {
  if (!inherits(x, "unfiy_panel_audit")) {
    stop("`x` must be an object created by `audit_panel()`.", call. = FALSE)
  }

  x$duplicate_data
}
