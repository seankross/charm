library(charm)

#Sys.setenv(CHARM_TEST_PATH = "inst/test/charms-out-of-order")

file.path_ <- function(...) {
  file.path(Sys.getenv("CHARM_TEST_PATH"), ...)
}

bracelet(
  charm(
    goal = "three.txt" |> file.path_(),
    ingredients = c("one.txt", "two.txt") |> file.path_(),
    instructions = "r (as.numeric(readLines('one.txt' |> file.path_()))*as.numeric(readLines('two.txt' |> file.path_()))) |> as.character() |> writeLines('three.txt' |> file.path_())"
  ),
  charm(
    goal = "mtcars.csv" |> file.path_(),
    instructions = "r write.csv(mtcars, 'mtcars.csv' |> file.path_())"
  ),
  charm(
    goal = "two.txt" |> file.path_(),
    instructions = "r writeLines('2', 'two.txt' |> file.path_())"
  ),
  charm(
    goal = "one.txt" |> file.path_(),
    ingredients = "mtcars.csv" |> file.path_(),
    instructions = "r nrow(read.csv('mtcars.csv' |> file.path_())) |> as.character() |> writeLines('one.txt' |> file.path_())"
  )
)
