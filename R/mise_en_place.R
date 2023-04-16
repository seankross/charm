#' @importFrom here here
#' @export
mise_en_place <- function(path = here()) {
  file.copy(system.file("code", "_charm.R", package = "charm"), path)
}
