#' Create a bracelet from charms
#'
#' @param ... A series of charms.
#' @export
bracelet <- function(...) {
  result <- list(...)
  class(result) <- "bracelet"
  result
}
