test_that("topological_sort works correctly", {
  start_nodes <- c("A", "A", "B", "C", "D")
  end_nodes <- c("B", "C", "D", "D", "E")
  sorted_nodes <- topological_sort(start_nodes, end_nodes)
  expect_identical(sorted_nodes, c("A", "C", "B", "D", "E"))

  start_nodes <- c("A", "B", "C", "D")
  end_nodes <- c("B", "C", "D", "E")
  sorted_nodes <- topological_sort(start_nodes, end_nodes)
  expect_identical(sorted_nodes, c("A", "B", "C", "D", "E"))

  start_nodes <- c("A", "B", "A", "C", "C")
  end_nodes <- c("B", "C", "C", "D", "E")
  sorted_nodes <- topological_sort(start_nodes, end_nodes)
  expect_identical(sorted_nodes, c("A", "B", "C", "E", "D"))

  start_nodes <- c("A", "A", "B", "C", "C")
  end_nodes <- c("B", "C", "D", "D", "E")
  sorted_nodes <- topological_sort(start_nodes, end_nodes)
  expect_identical(sorted_nodes, c("A", "C", "E", "B", "D"))
})
