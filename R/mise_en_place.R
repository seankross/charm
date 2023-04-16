#' Set up your charm bracelet
#'
#' @param path A path to a directory where you want to start your charm bracelet.
#' @importFrom here here
#' @export
mise_en_place <- function(path = here()) {
  file.copy(system.file("code", "_charm.R", package = "charm"), path)
}
