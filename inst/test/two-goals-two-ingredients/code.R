file.path_ <- function(...) {
  file.path(Sys.getenv("CHARM_TEST_PATH"), ...)
}

readLines("A.txt" |> file.path_()) |> nchar() |> as.character() |>
  writeLines("X.txt" |> file.path_())
readLines("B.txt" |> file.path_()) |> nchar() |> as.character() |>
  writeLines("Y.txt" |> file.path_())
