#' Assemble your charm bracelet
#'
#' @param path The path to a _charm.R file.
#' @importFrom readr read_file
#' @importFrom rlang parse_exprs global_env
#' @export
assemble <- function(path = here("_charm.R")) {
  charm_r <- read_file(path)
  charm_r_exprs <- parse_exprs(charm_r)
  bracelet_index <- lapply(charm_r_exprs, \(x) as.character(x[[1]])) |>
    unlist() |>
    (\(x) which(x == "bracelet"))()
  exprs_split <- split_list(charm_r_exprs, bracelet_index)

  if(!is.null(exprs_split$before)) {
    lapply(exprs_split$before, eval, envir = global_env())
  }

  charms <- eval(exprs_split$at[[1]])
  charmed <- c()

  no_ingredients <- Filter(\(x) is.null(x$ingredients), charms)
  yes_ingredients <- Filter(\(x) !is.null(x$ingredients), charms)

  no_ingredients_eval <- Filter(\(x) x$predicate(x$goal, x$ingredients), no_ingredients)
  lapply(no_ingredients_eval, handle, envir = global_env())
  charmed <- no_ingredients |> lapply(\(x) x$goal) |> unlist() |> union(charmed)

  graph <- yes_ingredients |>
    lapply(\(x) list(from = rep(x$goal, length(x$ingredients)),
                     to = x$ingredients))
  start_nodes <- graph |> lapply(\(x) x$from) |> unlist()
  end_nodes <- graph |> lapply(\(x) x$to) |> unlist()

  if(has_cycle(start_nodes, end_nodes)) {
    cli_abort("Cycle detected in goals and ingredients.")
  }

  goal_order <- setdiff(topological_sort(start_nodes, end_nodes) |> rev(), charmed)
  charm_index <- lapply(goal_order, function(x) {
    lapply(charms, function(y) {
      x %in% y$goal
    }) |> unlist() |> which()
  }) |> unlist()

  for (i in charm_index) {
    if (charms[[i]]$predicate(charms[[i]]$goal, charms[[i]]$ingredients)) {
      handle(charms[[i]], envir = global_env())
    }
  }

  if(!is.null(exprs_split$after)) {
    lapply(exprs_split$after, eval, envir = global_env())
  }
  invisible(TRUE)
}
