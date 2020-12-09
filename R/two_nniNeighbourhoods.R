#' two_nniNeighbourhoods Function
#'
#' This function extracts the 2-NNI neighbourhoods from a multiPhylo object, it generates a list of multiPhylo objects containing all trees shared between each tree's NNI neighbourhood and the multiPhylo object.
#' At this time the package cannot place unresolved trees into islands.
#'
#' @param tree an object of class "multiPhylo"
#' @param verbose Prints the function's progress. Defaults to TRUE. If run in parallel set to FALSE.
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(twoNNItestTrees)
#' neighbourhoods <- nniNeighbourhoods(twoNNItestTrees)
#' islands <- neighbourhoodMerger(neighbourhoods)
#' #write.islands(islands)
#'
#' @import ape
#' phangorn
#' phytools
#' thacklr
#'
#' @export 
two_nniNeighbourhoods<-function(tree, verbose = TRUE)
{
  tree <- ape::unroot.multiPhylo(tree)
  tree <- ape::unique.multiPhylo(tree)
  l <- length(tree)
  a <- list()
  NNIneigh<-list()
  counter = 1
  for (i in 1:l) {
    n <- phangorn::nni(tree[[i]])
    m <- list()
    for (p in 1:length(n)) {
      if (verbose == TRUE) {
        print(paste("At", p, "of", length(n), "neighbourhoods of unique tree", i))
      }
      o <- phangorn::nni(n[[p]])
      for (q in 1:length(o)) {
         m <- c(m, phytools::as.multiPhylo(n[[p]]))
         m <- c(m, phytools::as.multiPhylo(o[[q]]))
         # if (length(m) != 1) {
         #   #m <- thacklr::as.multiPhylo.list(m)
         #   m <- ape::unique.multiPhylo(m)
         # }
      }
      m <- ape::unique.multiPhylo(thacklr::as.multiPhylo.list(m), use.edge.length = F)
    }
    

    for (j in 1:length(m)) {
      if (verbose == TRUE) {
        print(paste("At", i, "of", l, "unique trees and", j, "of", length(m), "NNI trees", sep=" "))
      }
      for (k in 1:l) {
        #keep only the trees in the NNI neighbourhood that are also in the tree file
        if (ape::all.equal.phylo(m[[j]], tree[[k]], use.edge.length = F) == T) {
          a <- c(a, phytools::as.multiPhylo(tree[[i]]))
          a <- c(a, phytools::as.multiPhylo(m[[j]]))
        }
        else {
          a <- c(a, phytools::as.multiPhylo(tree[[i]]))
        }
      }
    }
    a <- ape::unique.multiPhylo(thacklr::as.multiPhylo.list(a), use.edge.length = F)
    NNIneigh[[counter]] <- a
    a <- list()
    counter = counter + 1
  }
  NNIneigh <- unique(NNIneigh)
}
