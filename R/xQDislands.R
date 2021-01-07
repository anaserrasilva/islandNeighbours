#' xQDislands Function
#'
#' This function recursively computes the quartet distance matrix for a tree distribution and extracts the x-QD islands.
#' At this time the package might not accurately place unresolved trees into islands.
#'
#' @param tree An object of class "multiPhylo"
#' @param threshold A numeric value setting the x-QD island threshold
#' @param output 'Dummy' parameter required for recursive function with changing number of inputs from first to subsequent rounds of the function. Please ALWAYS add 'output = list()' as a parameter. 
#' @param verbose Prints the function's progress. Defaults to TRUE. If run in parallel set to FALSE.
#' @param checkUnique Parameter to check tree distribution is made up of unique trees. Defaults to TRUE for first round of recursion.
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(testTrees)
#' isles <- xQDislands(testTrees, threshold = 6552, output = list())
#' #write.islands(islands)
#'
#' @references Maddison, D. R. (1991) \href{https://doi.org/10.1093/sysbio/40.3.315}{The discovery and importance of multiple islands of most-parsimonious trees}. \emph{Syst. Zool.}, 40:315-328 
#'
#' @import ape
#' phangorn
#' phytools
#' thacklr
#' Quartet
#'
#' @export 
xQDislands <- function(tree, threshold, output = list(), verbose = TRUE, checkUnique = TRUE){
  tree <- ape::unroot.multiPhylo(tree)
  if (checkUnique == TRUE) {
    tree <- ape::unique.multiPhylo(tree)
  }
  l <- length(tree)
  x <- threshold
  islands = output
  m <- Quartet::TQDist(tree)
  rownames(m) <- c(1:l)
  #test<-sort(unique(as.vector(m[1,])))
  counter = length(islands) + 1
  #extract singleton islands
  u = list()
  for (y in 1:l) {
    if (length(which(m[y,] <= x)) == 1){
      islands[[counter]] <- islands[[counter]] <- phytools::as.multiPhylo(tree[[y]])
      u[counter] <- as.numeric(y)
      counter = counter + 1
    }
  }
  if (length(u) != 0) {
    tree <- tree[-c(as.numeric(u))]
    l <- length(tree)
    m <- Quartet::TQDist(tree)
    rownames(m) <- c(1:l)
  }
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
  # t2 <- tree
  # if (length(t2) == 1) {
  #   islands[[counter+1]] <- t2
  #   return(islands)
  # }
  if (length(ape::unique.multiPhylo(c(tree,t), use.edge.length = F)) != length(tree)) {
    xQDislands(tree, threshold, islands, checkUnique = FALSE)
  }
  else {
    return(islands)
  }
}
