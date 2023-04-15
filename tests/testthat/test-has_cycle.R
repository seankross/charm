test_that("has_cycle works correctly", {
  start_nodes <- c("A", "A", "B", "C", "D")
  end_nodes <- c("B", "C", "D", "D", "E")
  cycle_detected <- has_cycle(start_nodes, end_nodes)
  expect_false(cycle_detected)

  start_nodes <- c("A", "B", "C", "D")
  end_nodes <- c("B", "C", "D", "A")
  cycle_detected <- has_cycle(start_nodes, end_nodes)
  expect_true(cycle_detected)

  start_nodes <- c("A", "B", "A", "C", "C")
  end_nodes <- c("B", "C", "C", "D", "E")
  cycle_detected <- has_cycle(start_nodes, end_nodes)
  expect_false(cycle_detected)

  start_nodes <- c("A", "B", "C", "D", "E")
  end_nodes <- c("B", "C", "D", "E", "A")
  cycle_detected <- has_cycle(start_nodes, end_nodes)
  expect_true(cycle_detected)
})
