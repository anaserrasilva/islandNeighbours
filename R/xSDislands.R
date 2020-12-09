#' xSDislands Function
#'
#' This function recursively computes the Robinson-Foulds/Symmetric Difference on Full Splits distance matrix for a tree distribution and extracts the x-SD islands.
#' The 
#' At this time the package might not accurately place unresolved trees into islands.
#'
#' @param tree An object of class "multiPhylo"
#' @param threshold A numeric value setting the x-SD island threshold
#' @param output 'Dummy' parameter required for recursive function with changing number of inputs from first to subsequent rounds of the function. Please ALWAYS add 'output = list()' as a parameter. 
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(testTrees)
#' isles <- xSDislands(testTrees, threshold = 2, output = list())
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
xSDislands <- function(tree, threshold, output = list()){
  tree <- ape::unroot.multiPhylo(tree)
  tree <- ape::unique.multiPhylo(tree)
  l <- length(tree)
  x <- threshold
  islands = output
  m <- phytools::multiRF(tree)
  rownames(m) <- c(1:l)
  counter = 1 + length(islands)
  #adding property, equivalent of colour in graph-based clustering approaches
  p <- rep(c('a'), times = l)
  p[1] <- 'b'
  s <- m[m[1,] <= x,]
  p[c( as.numeric(rownames(s)))] <- 'b'
  for (k in 2:l) {
    print(paste("At tree", k, sep=' '))
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
  t <- ape::unique.multiPhylo(thacklr::as.multiPhylo.list(t), use.edge.length = F)
  islands[[counter]] <- t
  #counter = counter + 1
  if (length(t) != length(tree)) {
    tree <- tree[-c(as.numeric(r))]
  }
  #to call recursive function
  t2 <- tree
  if (length(t2) == length(t)) {
    if (length(ape::unique.multiPhylo(c(t2,t), use.edge.length = F)) != length(t)) {
      xSDislands(t2, threshold, islands)
    }
  }
  if (length(t2) != length (t)) {
    xSDislands(t2, threshold, islands)
  }
  else {
    return(islands)
  }
}
