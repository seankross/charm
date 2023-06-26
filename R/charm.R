#' Create a charm
#'
#' @param goal A file path.
#' @param ingredients A vector of file paths (optional).
#' @param instructions A vector of either paths to R files or R commands, which
#' are strings that begin with a lowercase r and are followed by a space and
#' an R command. Like inline R code in R Markdown.
#' @export
charm <- function(goal, ingredients = NULL, instructions){
  setup_charm(goal, ingredients, instructions, predicate = predicate_charm)
}

setup_charm <- function(goal = NULL, ingredients = NULL,
                        instructions = NULL, predicate = NULL) {
  instructions <- gsub("^[[:space:]]+|[[:space:]]+$", "", instructions) |>
    lapply(function(x) {
      if (grepl("^r[[:space:]]+", x)) {
        list(type = "command", content = gsub("^r[[:space:]]+", "", x))
      } else if (grepl("\\.[R|r]md$", x)) {
        list(type = "rmd", content = x)
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

#' @importFrom knitr purl
#' @importFrom cli cli_abort
handle.charm <- function(x, ...) {
  args <- list(...)
  if(!is.null(args$envir)) {
    envir <- function() args$envir
  } else {
    envir <- parent.frame
  }

  lapply(x$instructions, function(instruction) {
    if(instruction$type == "command") {
      parse_exprs(instruction$content) |>
        lapply(eval, envir = envir())
    } else if(instruction$type == "file") {
      lapply(instruction$content, read_file) |>
        lapply(parse_exprs) |>
        unlist() |>
        lapply(eval, envir = envir())
    } else if(instruction$type == "rmd") {
      file_names <- lapply(instruction$content,
                           \(x) sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)) |> unlist()
      r_files <- c(paste0(file_names, ".r"), paste0(file_names, ".R"))
      existing_r_files <- r_files[file.exists(r_files)]

      if (any(file.exists(r_files))) {
        cli_abort("Rmd file already exists as R file: {existing_r_files}")
      }

      r_paths <- lapply(instruction$content, purl, documentation = 0) |> unlist()
      on.exit(unlink(r_paths, force = TRUE))

      lapply(r_paths, read_file) |>
        lapply(parse_exprs) |>
        unlist() |>
        lapply(eval, envir = envir())
    }
  })
  x$goal
}

#' @importFrom cli cli_ul cli_text cli_li cli_end
#' @export
print.charm <- function(x, ...){
  cli_ul()
  cli_text("Goal:")
  cli_li(x$goal)
  cli_end()

  if(length(x$ingredients) > 0) {
    cli_ul()
    cli_text("Ingredients:")
    cli_li(x$ingredients)
    cli_end()
  }

  cli_ul()
  cli_text("Instructions:")
  cli_li(x$instructions |> lapply(\(x) x$content) |> unlist())
  cli_end()
}
