subgraph_to_goal <- function(start_nodes, end_nodes, goal_node) {
  if (!goal_node %in% end_nodes) {
    stop("The goal_node is not present in the end_nodes vector.")
  }

  # Initialize the subgraph
  sub_start_nodes <- character(0)
  sub_end_nodes <- character(0)

  # Recursive function to find paths leading to the goal_node
  find_paths_to_goal <- function(current_node) {
    # Get the indices of the start_nodes that lead to the current_node
    indices <- which(end_nodes == current_node)

    # Add the edges that lead to the current_node to the subgraph
    sub_start_nodes <<- append(sub_start_nodes, start_nodes[indices])
    sub_end_nodes <<- append(sub_end_nodes, end_nodes[indices])

    # Recursively find paths for each start_node that leads to the current_node
    for (node in start_nodes[indices]) {
      find_paths_to_goal(node)
    }
  }

  # Find the paths leading to the goal_node
  find_paths_to_goal(goal_node)

  # Combine sub_start_nodes and sub_end_nodes into a list
  subgraph <- list(start_nodes = sub_start_nodes, end_nodes = sub_end_nodes)
  return(subgraph)
}
