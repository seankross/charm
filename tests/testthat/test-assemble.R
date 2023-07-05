test_that("Assemble correctly makes charm bracelets 1", {
  skip_on_os("windows")
  temp_dir <- tempdir()
  mtcf_dir <- system.file("test", "mtcars-formaldehyde", package = "charm")
  file.copy(mtcf_dir, temp_dir, recursive = TRUE)
  temp_mtcf <- file.path(temp_dir, "mtcars-formaldehyde")
  Sys.setenv(CHARM_TEST_PATH = temp_mtcf)
  assemble(path = file.path(temp_mtcf, "_charm.R"))
  form <- file.path(temp_mtcf, "data", "Formaldehyde.csv")
  mt <- file.path(temp_mtcf, "data", "mtcars.csv")
  mtfo <- file.path(temp_mtcf, "data", "mtfo.txt")

  expect_true(all(c(form, mt, mtfo) |> sapply(file.exists)))

  unlink(temp_mtcf, recursive = TRUE, force = TRUE)
  Sys.unsetenv("CHARM_TEST_PATH")
})

test_that("Assemble correctly makes charm bracelets 2", {
  skip_on_os("windows")
  temp_dir <- tempdir()
  mtcf_dir <- system.file("test", "charms-out-of-order", package = "charm")
  file.copy(mtcf_dir, temp_dir, recursive = TRUE)
  temp_mtcf <- file.path(temp_dir, "charms-out-of-order")
  Sys.setenv(CHARM_TEST_PATH = temp_mtcf)
  assemble(path = file.path(temp_mtcf, "_charm.R"))
  txt <- file.path(temp_mtcf, c("one.txt", "two.txt", "three.txt"))
  mt <- file.path(temp_mtcf, "mtcars.csv")

  expect_true(all(c(txt, mt) |> sapply(file.exists)))

  unlink(temp_mtcf, recursive = TRUE, force = TRUE)
  Sys.unsetenv("CHARM_TEST_PATH")
})

test_that("Assemble correctly makes charm bracelets 3", {
  skip_on_os("windows")
  temp_dir <- tempdir()
  mtcf_dir <- system.file("test", "two-goals-two-ingredients", package = "charm")
  file.copy(mtcf_dir, temp_dir, recursive = TRUE)
  temp_mtcf <- file.path(temp_dir, "two-goals-two-ingredients")
  Sys.setenv(CHARM_TEST_PATH = temp_mtcf)
  assemble(path = file.path(temp_mtcf, "_charm.R"))
  txt <- file.path(temp_mtcf, c("X.txt", "Y.txt"))

  expect_true(all(c(txt) |> sapply(file.exists)))

  unlink(temp_mtcf, recursive = TRUE, force = TRUE)
  Sys.unsetenv("CHARM_TEST_PATH")
})
