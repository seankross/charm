has_cycle <- function(start_nodes, end_nodes) {
  # Create the adjacency list
  adj_list <- lapply(unique(c(start_nodes, end_nodes)), function(x) {
    list(node = x, edges = end_nodes[start_nodes == x])
  })
  names(adj_list) <- sapply(adj_list, `[[`, "node")

  # Initialize the visited set and the recursion stack
  visited <- character()
  rec_stack <- character()

  # Helper function to perform DFS
  dfs_cycle <- function(node) {
    if (node %in% rec_stack) {
      return(TRUE)
    }
    if (node %in% visited) {
      return(FALSE)
    }

    visited <<- c(visited, node)
    rec_stack <<- c(rec_stack, node)
    for (neighbor in adj_list[[node]]$edges) {
      if (dfs_cycle(neighbor)) {
        return(TRUE)
      }
    }
    rec_stack <<- rec_stack[rec_stack != node]
    return(FALSE)
  }

  # Perform DFS for each node and check for cycles
  for (node in names(adj_list)) {
    if (dfs_cycle(node)) {
      return(TRUE)
    }
  }

  # Return FALSE if no cycle is detected
  return(FALSE)
}
