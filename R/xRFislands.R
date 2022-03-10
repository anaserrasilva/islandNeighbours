#' xRFislands Function
#'
#' This function recursively computes the Robinson-Foulds distance matrix for a tree distribution and extracts the x-RF islands.
#' At this time the package might not accurately place unresolved trees into islands.
#' If you are expecting your tree distribution to be made up of large numbers of very small islands, set options(expressions=500000) before analysis.
#'
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
#' rwty
#'
#' @export 
xRFislands <- function(tree, threshold, output = list(), verbose = TRUE){
  tree <- ape::unroot.multiPhylo(tree)
  tree <- ape::unique.multiPhylo(tree)
  l <- length(tree)
  x <- threshold
  islands = output
  m <- rwty::tree.dist.matrix(tree)
  rownames(m) <- c(1:l)
  counter = 1 + length(islands)
  #adding property, equivalent of colour in graph-based clustering approaches
  p <- rep(c('a'), times = l)
  p[1] <- 'b'
  s <- m[m[1,] <= x,]
  p[c( as.numeric(rownames(s)))] <- 'b'
  for (k in 2:l) {
    if (verbose == TRUE) {
      print(paste("At tree", k, sep=' '))
    }
    if (p[k] == 'b') {
      s <- m[m[k,] <= x,]
      p[c(as.numeric(rownames(s)))] <- 'b'
    }
    #recover trees within threshold missed in first go around
    for (i in 1:l) {
      if (p[i] == 'b') {
        s <- m[m[i,] <= x,]
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
  if (length(t) != l) {
    tree <- tree[-c(as.numeric(r))]
  }
  #to call recursive function
  t2 <- tree
  if (length(t2) == 1) {
    islands[[counter+1]] <- t2
    return(islands)
  }
  if (length(ape::unique.multiPhylo(c(t2,t), use.edge.length = F)) != length(t2)) {
    xRFislands(tree, threshold, islands)
  }
  else {
    return(islands)
  }
}
