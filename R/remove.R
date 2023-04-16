#' @importFrom readr read_file
#' @importFrom rlang parse_exprs
#' @export
clean_slate <- function(path = here("_charm.R")) {
  charm_r <- read_file(path)
  charm_r_exprs <- parse_exprs(charm_r)
  bracelet_index <- lapply(charm_r_exprs, \(x) as.character(x[[1]])) |>
    unlist() |>
    (\(x) which(x == "bracelet"))()
  exprs_split <- split_list(charm_r_exprs, bracelet_index)

  charms <- eval(exprs_split$at[[1]])

  charms |> lapply(\(x) x$goal) |> unlist() |> unique() |>
    lapply(\(x) unlink(x, recursive = TRUE, force = TRUE))
  invisible()
}
