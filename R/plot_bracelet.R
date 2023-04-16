#' @importFrom graphics arrows text
plot.bracelet <- function(start_nodes, end_nodes) {
  # Create the adjacency list
  adj_list <- lapply(unique(c(start_nodes, end_nodes)), function(x) {
    list(node = x, edges = end_nodes[start_nodes == x])
  })
  names(adj_list) <- sapply(adj_list, `[[`, "node")

  # Define the positions of the nodes
  n <- length(adj_list)
  node_positions <- data.frame(
    node = names(adj_list),
    x = cos(seq(0, 2 * pi, length.out = n + 1)[-1]),
    y = sin(seq(0, 2 * pi, length.out = n + 1)[-1])
  )

  # Plot the edges
  plot(NULL, type = "n", xlim = range(node_positions$x) * 1.3,
       ylim = range(node_positions$y) * 1.3, xlab = "", ylab = "",
       main = "Bracelet", axes = FALSE, asp = 1)

  arrow_scale <- 0.9
  text_scale <- 1.15

  for (node in names(adj_list)) {
    for (neighbor in adj_list[[node]]$edges) {
      start_pos <- node_positions[node_positions$node == node, c("x", "y")]
      end_pos <- node_positions[node_positions$node == neighbor, c("x", "y")]

      start_x <- start_pos$x + (end_pos$x - start_pos$x) * (1 - arrow_scale)
      start_y <- start_pos$y + (end_pos$y - start_pos$y) * (1 - arrow_scale)
      end_x <- end_pos$x - (end_pos$x - start_pos$x) * (1 - arrow_scale)
      end_y <- end_pos$y - (end_pos$y - start_pos$y) * (1 - arrow_scale)

      arrows(start_x, start_y, end_x, end_y, length = 0.15, angle = 30)
    }
  }

  # Plot the nodes
  text(node_positions$x * text_scale, node_positions$y * text_scale, node_positions$node, cex = 1.5, col = "blue")
}
