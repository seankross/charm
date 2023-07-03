library(charm)

file.path_ <- function(...) {
  file.path(Sys.getenv("CHARM_TEST_PATH"), ...)
}

bracelet(
  charm(
    goal = c("X.txt", "Y.txt") |> file.path_(),
    ingredients = c("A.txt", "B.txt") |> file.path_(),
    instructions = "code.R" |> file.path_()
  )
)
