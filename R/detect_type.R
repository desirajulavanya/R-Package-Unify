#' Detect file type
#'
#' `detect_type()` detects a file's type from its extension.
#'
#' @param file A path to a file.
#'
#' @return A lowercase character string giving the detected file extension.
#'
#' @examples
#' detect_type("data.csv")
#' detect_type("survey.DTA")
#'
#' @export
detect_type <- function(file) {
  if (missing(file) || length(file) != 1) {
    stop("`file` must be a single file path.", call. = FALSE)
  }

  if (!is.character(file)) {
    stop("`file` must be a character string.", call. = FALSE)
  }

  ext <- tools::file_ext(file)
  ext <- tolower(ext)

  if (ext == "") {
    stop(
      "Could not detect file type. Please provide a file with an extension.",
      call. = FALSE
    )
  }

  if (!ext %in% supported_types()) {
    stop(
      paste0(
        "Unsupported file type: .", ext, "\n",
        "Supported types are: ",
        paste(supported_types(), collapse = ", ")
      ),
      call. = FALSE
    )
  }

  ext
}
