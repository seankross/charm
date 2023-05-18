library(charm)
library(readr)

x <- 0

# Sys.setenv(CHARM_TEST_PATH = "inst/test/mtcars-formaldehyde")

file.path_ <- function(...) {
  file.path(Sys.getenv("CHARM_TEST_PATH"), ...)
}

bracelet(
  charm(
    goal = file.path_("data", "Formaldehyde.csv"),
    instructions = "r write_csv(Formaldehyde, file.path_('data', 'Formaldehyde.csv'))"
  ),
  charm(
    goal = file.path_("data", "mtcars.csv"),
    instructions = "r write_csv(mtcars, file.path_('data', 'mtcars.csv'))"
  ),
  charm(
    goal = file.path_("data", "mtfo.txt"),
    ingredients = c(file.path_("data", "mtcars.csv"), file.path_("data", "Formaldehyde.csv")),
    instructions = file.path_("code", "mtform.R")
  )
)

y <- 1
