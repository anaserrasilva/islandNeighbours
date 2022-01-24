#' xIslands Function
#'
#' This function recursively extracts the x-distance islands from a user supplied tree-to-tree distance matrix.
#' At this time the package might not accurately place unresolved trees into islands.
#' If you are expecting your tree distribution to be made up of large numbers of very small islands, set options(expressions=500000) before analysis.
#'
#' @param mat A distance matrix
#' @param tree An object of class "multiPhylo"
#' @param threshold A numeric value setting the x-RF island threshold
#' @param output 'Dummy' parameter required for recursive function with changing number of inputs from first to subsequent rounds of the function. Please ALWAYS add 'output = list()' as a parameter. 
#' @param verbose Prints the function's progress. Defaults to TRUE. If run in parallel set to FALSE.
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(testTrees)
#' isles <- xRFislands(testTrees, threshold = 2, output = list())
#' #write.islands(islands)
#'
#' @references Maddison, D. R. (1991) \href{https://doi.org/10.1093/sysbio/40.3.315}{The discovery and importance of multiple islands of most-parsimonious trees}. \emph{Syst. Zool.}, 40:315-328 
#'
#' @import ape
#' phangorn
#' phytools
#' thacklr
#'
#' @export 
xIslands <- function(mat, tree, threshold, output = list(), verbose = TRUE){
  tree <- tree
  l <- length(tree)
  mat <- mat
  if (any(mat == -1)){
    mat[mat == -1] = NA
  }
  x <- threshold
  islands <- output
  counter = 1 + length(islands)
  #extract singleton islands
  u = list()
  for (y in 1:l) {
    if (length(which(mat[y,] <= x)) == 1){
      islands[[counter]] <- phytools::as.multiPhylo(tree[[y]])
      u[counter] <- as.numeric(y)
      counter = counter + 1
    }
  }
  if (length(u) != 0) {
    tree <- tree[-c(as.numeric(u))]
    l <- length(tree)
    mat <- mat[-c(as.numeric(u)),-c(as.numeric(u))]
    rownames(mat) <- c(1:l)
  }
  #adding property, equivalent of colour in graph-based clustering approaches
  p <- rep(c('a'), times = l)
  p[1] <- 'b'
  s <- mat[mat[1,] <= x,]
  p[c( as.numeric(rownames(s)))] <- 'b'
  for (k in 2:l) {
    if (verbose == TRUE) {
      print(paste("At tree", k, sep=' '))
    }
    if (p[k] == 'b') {
      s <- mat[mat[k,] <= x,]
      p[c(as.numeric(rownames(s)))] <- 'b'
    }
    #recover trees within threshold missed in first go around
    for (i in 1:l) {
      if (p[i] == 'b') {
        s <- mat[mat[i,] <= x,]
        p[c(as.numeric(rownames(s)))] <- 'b'
      }
      r <- c(which(p == 'b'))
      t <- tree[c(as.numeric(r))]
    }
  }
  if (length(t) != 1) {
    t <- ape::unique.multiPhylo(thacklr::as.multiPhylo.list(t), use.edge.length = F)
  }
  islands[[counter]] <- t
  #counter = counter + 1
  mat <- mat[-c(as.numeric(r)),-c(as.numeric(r))]
  #to call recursive function
  if (dim(mat)[1] != 0) {
    tree <- tree[-c(as.numeric(r))]
    rownames(mat) <- c(1:length(mat))
    xIslands(mat, tree, threshold, islands)
  }
  else {
    return(islands)
  }
}
