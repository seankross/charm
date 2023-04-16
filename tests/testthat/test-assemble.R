test_that("Assemble correctly makes charm bracelets.", {
  temp_dir <- tempdir()
  mtcf_dir <- system.file("test", "mtcars-formaldehyde", package = "charm")
  file.copy(mtcf_dir, temp_dir, recursive = TRUE)
  temp_mtcf <- file.path(temp_dir, "mtcars-formaldehyde")
  Sys.setenv(CHARM_TEST_PATH = temp_mtcf)
  assemble(file.path(temp_mtcf, "_charm.R"))
  form <- file.path(temp_mtcf, "data", "Formaldehyde.csv")
  mt <- file.path(temp_mtcf, "data", "mtcars.csv")
  mtfo <- file.path(temp_mtcf, "data", "mtfo.txt")

  expect_true(all(c(form, mt, mtfo) |> sapply(file.exists)))

  unlink(temp_mtcf, recursive = TRUE, force = TRUE)
  Sys.unsetenv("CHARM_TEST_PATH")
})
