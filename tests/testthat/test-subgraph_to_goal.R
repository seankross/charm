test_that("subgraph_to_goal returns the correct subgraph 1", {
  start_nodes <- c("A", "B", "C")
  end_nodes <- c("C", "C", "D")
  goal_node <- "C"

  subgraph <- subgraph_to_goal(start_nodes, end_nodes, goal_node)

  expect_identical(subgraph$start_nodes, c("A", "B"))
  expect_identical(subgraph$end_nodes, c("C", "C"))
})

test_that("subgraph_to_goal returns the correct subgraph 2", {
  start_nodes <- c("A", "A", "B", "C", "D", "E")
  end_nodes <- c("B", "C", "D", "D", "E", "F")
  goal_node <- "E"

  subgraph <- subgraph_to_goal(start_nodes, end_nodes, goal_node)

  expect_identical(subgraph$start_nodes, c("D", "B", "C", "A", "A"))
  expect_identical(subgraph$end_nodes, c("E", "D", "D", "B", "C"))
})

test_that("subgraph_to_goal returns the correct subgraph 3", {
  start_nodes <- c("A", "A", "B", "C", "D", "E")
  end_nodes <- c("B", "C", "D", "D", "E", "F")
  goal_node <- "C"

  subgraph <- subgraph_to_goal(start_nodes, end_nodes, goal_node)

  expect_equal(subgraph$start_nodes, c("A"))
  expect_equal(subgraph$end_nodes, c("C"))
})

test_that("subgraph_to_goal raises an error when goal_node is not in end_nodes", {
  start_nodes <- c("A", "B", "C")
  end_nodes <- c("B", "C", "D")
  goal_node <- "E"

  expect_error(subgraph_to_goal(start_nodes, end_nodes, goal_node),
               "The goal_node is not present in the end_nodes vector.")
})
