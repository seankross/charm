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

setup_charm <- function(goal, ingredients, instructions, predicate) {
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

#' @importFrom cli cli_ul cli_text cli_li
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

extend_charm <- function(goal = NULL, ingredients = NULL,
         instructions = NULL, predicate = NULL){
  #if(predicate(goal, ingredients)) {
    setup_charm(goal, ingredients, instructions, predicate)
  #}
}

charm <- function(goal, ingredients, instructions){
  extend_charm(goal, ingredients, instructions, predicate = predicate_charm)
}

bracelet <- function(...) {
  # Check that goals are all unique

  lapply(list, function)
}

z = charm("x.csv", "y.csv", 'r readr::write_csv(readr::read_csv("y.csv"), "x.csv")')
z
z$predicate(z$goal, z$ingredients)
