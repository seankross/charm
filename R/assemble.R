#' Assemble your charm bracelet
#'
#' @param goals Charms to be assembled in the `_charm.R` file, specified by
#' their respective goals. Charms can be specified with only the
#' [base::basename()] of a goal for that charm if no other goals share the same
#' [base::basename()]. Goals in charms that share a [base::basename()] with
#' another goal can always be specified by the path to a goal. You only need to
#' specify one goal in a charm for the charm to be assembled. The default value
#' `NULL` indicates all charms should assembled (this is the default).
#' @param path The path to a `_charm.R` file.
#' @importFrom here here
#' @importFrom readr read_file
#' @importFrom rlang parse_exprs global_env
#' @importFrom fs path_abs
#' @export
assemble <- function(goals = NULL, path = here("_charm.R")) {
  charm_r_exprs <- parse_exprs(read_file(path))
  bracelet_index <- lapply(charm_r_exprs, \(x) as.character(x[[1]])) |>
    unlist() |>
    (\(x) which(x == "bracelet"))()
  exprs_split <- split_list(charm_r_exprs, bracelet_index)

  # Run all expressions before the bracelet
  if(!is.null(exprs_split$before)) {
    lapply(exprs_split$before, eval, envir = global_env())
  }

  # Assign absolute paths as much as possible
  charms <- eval(exprs_split$at[[1]]) |>
    lapply(function(x){
      if(!is.null(x$goal)) {
        x$goal <- path_abs(x$goal)
      }

      if(!is.null(x$ingredients)) {
        x$ingredients <- path_abs(x$ingredients)
      }

      if(is.null(x$instructions)) return(x)
      x$instructions <- x$instructions |> lapply(
        function(y){
          if(y$type %in% c("file", "rmd")){
            y$content <- path_abs(y$content)
          }
          y
        }
      )

      x
    })

  # Check to make sure that goals are unique to each charm
  all_goals <- lapply(charms, \(x) x$goal) |> unlist()
  if(any(duplicated(all_goals))){
    duplicated_goals <- all_goals[duplicated(all_goals)]
    cli_abort("Goals must correspond to only one charm. The following goals are set for more than one charm: {duplicated_goals}")
  }

  assembled <- c()

  # Which charms need to be assembled? First check if goals were specified
  if(!is.null(goals)){
    # Check if there is basename duplication

  }

  no_ingredients <- Filter(\(x) is.null(x$ingredients), charms)
  yes_ingredients <- Filter(\(x) !is.null(x$ingredients), charms)

  no_ingredients_eval <- Filter(\(x) x$predicate(x$goal, x$ingredients), no_ingredients)
  lapply(no_ingredients_eval, handle, envir = global_env())
  assembled <- no_ingredients |> lapply(\(x) x$goal) |> unlist() |> union(assembled)

  graph <- yes_ingredients |>
    lapply(\(x) list(from = rep(x$goal, length(x$ingredients)) |> sort(),
                     to = rep(x$ingredients, length(x$goal))))
  start_nodes <- graph |> lapply(\(x) x$from) |> unlist()
  end_nodes <- graph |> lapply(\(x) x$to) |> unlist()

  if(has_cycle(start_nodes, end_nodes)) {
    cli_abort("Cycle detected in goals and ingredients.")
  }

  goal_order <- setdiff(topological_sort(start_nodes, end_nodes) |> rev(), assembled)
  charm_index <- lapply(goal_order, function(x) {
    lapply(charms, function(y) {
      x %in% y$goal
    }) |> unlist() |> which()
  }) |> unlist() |> unique()

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
