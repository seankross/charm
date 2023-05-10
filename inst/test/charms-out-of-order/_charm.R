library(charm)

bracelet(
  charm(
    goal = "three.txt",
    ingredients = c("one.txt", "two.txt"),
    instructions = "r (as.numeric(readLines('one.txt'))*as.numeric(readLines('two.txt'))) |> as.character() |> writeLines('three.txt')"
  ),
  charm(
    goal = "mtcars.csv",
    instructions = "r write.csv(mtcars, 'mtcars.csv')"
  ),
  charm(
    goal = "two.txt",
    instructions = "r writeLines('2', 'two.txt')"
  ),
  charm(
    goal = "one.txt",
    ingredients = "mtcars.csv",
    instructions = "r nrow(read.csv('mtcars.csv')) |> as.character() |> writeLines('one.txt')"
  )
)
