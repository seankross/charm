library(charm)
library(readr)

x <- 0

path_ <- Sys.getenv("CHARM_TEST_PATH")

bracelet(
  charm(
    goal = file.path(path_, "data", "Formaldehyde.csv"),
    instructions = "r write_csv(Formaldehyde, file.path(path_, 'data', 'Formaldehyde.csv'))"
  ),
  charm(
    goal = file.path(path_, "data", "mtcars.csv"),
    instructions = "r write_csv(mtcars, file.path(path_, 'data', 'mtcars.csv'))"
  ),
  charm(
    goal = file.path(path_, "data", "mtfo.txt"),
    ingredients = c(file.path(path_, "data", "mtcars.csv"), file.path(path_, "data", "Formaldehyde.csv")),
    instructions = file.path(path_, "code", "mtform.R")
  )
)

y <- 1
