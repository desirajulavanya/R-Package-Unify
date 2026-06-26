#' Example Panel Dataset
#'
#' A small example panel dataset for demonstrating panel-data auditing.
#'
#' The dataset intentionally includes one duplicate unit-time observation
#' and missing unit-time cells so that users can test `unifyr` diagnostics.
#'
#' @format A data frame with 9 rows and 4 variables:
#' \describe{
#'   \item{id}{Panel unit identifier.}
#'   \item{year}{Time period.}
#'   \item{outcome}{Example outcome variable.}
#'   \item{treatment}{Example treatment indicator.}
#' }
#'
#' @examples
#' data(example_panel)
#' audit_panel(example_panel, id = id, time = year)
"example_panel"
