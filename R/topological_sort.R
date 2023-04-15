topological_sort <- function(start_nodes, end_nodes) {
  # Create the adjacency list
  adj_list <- lapply(unique(c(start_nodes, end_nodes)), function(x) {
    list(node = x, edges = end_nodes[start_nodes == x])
  })
  names(adj_list) <- sapply(adj_list, `[[`, "node")

  # Initialize the result vector and visited set
  result <- c()
  visited <- character()

  # Helper function to perform DFS
  dfs <- function(node) {
    if (node %in% visited) {
      return()
    }

    visited <<- c(visited, node)
    for (neighbor in adj_list[[node]]$edges) {
      dfs(neighbor)
    }
    result <<- c(node, result)
  }

  # Perform DFS for each node
  for (node in names(adj_list)) {
    dfs(node)
  }

  # Return the topologically sorted result
  return(result)
}

# Example usage:
start_nodes <- c("A", "A", "B", "C", "D")
end_nodes <- c("B", "C", "D", "D", "E")
sorted_nodes <- topological_sort(start_nodes, end_nodes)
print(sorted_nodes)
