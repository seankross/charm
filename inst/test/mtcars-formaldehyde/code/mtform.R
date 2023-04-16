path_ <- Sys.getenv("CHARM_TEST_PATH")

mt <- read_csv(file.path(path_, "data", "mtcars.csv"))
form <- read_csv(file.path(path_, "data", "Formaldehyde.csv"))
writeLines(c(as.character(mt), as.character(form)),
           file.path(path_, "data", "mtfo.txt"))
