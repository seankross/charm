#' @export
charm <- function(goal, ingredients = NULL, instructions){
  setup_charm(goal, ingredients, instructions, predicate = predicate_charm)
}

setup_charm <- function(goal = NULL, ingredients = NULL,
                        instructions = NULL, predicate = NULL) {
  instructions <- gsub("^[[:space:]]+|[[:space:]]+$", "", instructions) |>
    lapply(function(x) {
      if(grepl("^r[[:space:]]+", x)) {
        list(type = "command", content = gsub("^r[[:space:]]+", "", x))
      } else {
        list(type = "file", content = x)
      }
    })

  result <- list(goal = goal, ingredients = ingredients,
                 instructions = instructions, predicate = predicate)
  class(result) <- "charm"
  result
}

#' @importFrom cli cli_abort
predicate_charm <- function(goal, ingredients) {
  if(length(ingredients) > 0 && any(!file.exists(ingredients))){
    missing_ingredients <- ingredients[!file.exists(ingredients)]
    cli_abort("Charm is missing ingredients: {missing_ingredients}")
  }

  if(any(!file.exists(goal))) {
    return(TRUE)
  }

  ingredient_mod_times <- sapply(ingredients, function(file) file.info(file)$mtime)
  goal_mod_times <- sapply(goal, function(file) file.info(file)$mtime)
  any(ingredient_mod_times > min(goal_mod_times))
}

#' @export
handle.charm <- function(x, envir) {
  lapply(x$instructions, function(instruction) {
    if(instruction$type == "command") {
      parse_exprs(instruction$content) |>
        lapply(eval, envir = envir)
    } else if(instruction$type == "file") {
      lapply(instruction$content, read_file) |>
        lapply(parse_exprs) |>
        unlist() |>
        lapply(eval, envir = envir)
    }
  })
  x$goal
}

#' @importFrom cli cli_ul cli_text cli_li cli_end
#' @export
print.charm <- function(x){
  cli_ul()
  cli_text("Goal:")
  cli_li(x$goal)
  cli_end()
  cli_ul()
  cli_text("Ingredients:")
  cli_li(x$ingredients)
  cli_end()
  #cli_text("Instructions:")
}
