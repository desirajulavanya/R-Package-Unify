#' List supported file types
#'
#' `supported_types()` returns the file extensions currently supported by
#' `unfiy`.
#'
#' @return A character vector of supported file extensions.
#'
#' @examples
#' supported_types()
#'
#' @export
supported_types <- function() {
  c(
    "csv",
    "tsv",
    "xlsx",
    "xls",
    "dta",
    "sav",
    "rds",
    "json"
  )
}
