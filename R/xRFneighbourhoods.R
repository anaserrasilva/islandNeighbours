#' xRFneighbourhoods Function
#'
#' This function extracts the x-RF neighbourhoods from a multiPhylo object, it generates a list of multiPhylo objects containing all trees shared between each tree's x-RF neighbourhood and the multiPhylo object.
#' At this time the package might not accurately place unresolved trees into islands.
#'
#' @param tree an object of class "multiPhylo"
#' @param verbose Prints the function's progress. Defaults to TRUE. If run in parallel set to FALSE.
#' @param threshold A numeric value setting the x-RF island threshold
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- xRFneighbourhoods(testTrees, threshold = 2)
#' islands <- neighbourhoodMerger(neighbourhoods)
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
xRFneighbourhoods<-function(tree, verbose = TRUE, threshold)
{
  tree <- ape::unroot.multiPhylo(tree)
  tree <- ape::unique.multiPhylo(tree)
  l <- length(tree)
  m <- rwty::tree.dist.matrix(tree)
  rownames(m) <- c(1:l)
  x <- threshold
  a <- list()
  RFneigh<-list()
  counter = 1
  for (i in 1:l) {
    if (verbose == TRUE) {
      print(paste("At", i, "of", l, "unique trees", sep=" "))
    }
    s <- m[m[i,] <= x,]
    n <- tree[as.numeric(rownames(s))]
    if (ape::is.binary(tree[[i]]) == FALSE) warning('You have trees with polytomies, please check island make-up to ensure all trees in the island are connected.')
    for (j in 1:length(n)) {
      for (k in 1:l) {
        #keep only the trees in the NNI neighbourhood that are also in the tree file
        if (ape::all.equal.phylo(n[[j]], tree[[k]], use.edge.length = F) == T) {
          a <- c(a, phytools::as.multiPhylo(tree[[i]]))
          a <- c(a, phytools::as.multiPhylo(n[[j]]))
        }
        else {
          a <- c(a, phytools::as.multiPhylo(tree[[i]]))
        }
      }
    }
    a <- ape::unique.multiPhylo(thacklr::as.multiPhylo.list(a), use.edge.length = F)
    RFneigh[[counter]] <- a
    a <- list()
    counter = counter + 1
  }
  RFneigh <- unique(RFneigh)
}
