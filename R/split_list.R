split_list <- function(x, i) {
  if (i < 1 || i > length(x)) {
    stop("Index i is out of range.")
  }

  result <- list(before = x[1:(i-1)], at = x[i], after = x[(i+1):length(x)])

  if (i == 1) {
    result$before <- NULL
  }

  if(i == length(x)) {
    result$after <- NULL
  }

  result
}
