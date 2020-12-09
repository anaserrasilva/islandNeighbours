#' nniNeighbourhoods Function
#'
#' This function extracts the 1-NNI neighbourhoods from a multiPhylo object, it generates a list of multiPhylo objects containing all trees shared between each tree's NNI neighbourhood and the multiPhylo object.
#' At this time the package cannot place unresolved trees into islands.
#'
#' @param tree an object of class "multiPhylo"
#' @param verbose Prints the function's progress. Defaults to TRUE. If run in parallel set to FALSE.
#'
#' @return List of "multiPhylo" objects
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- neighbourhoodMerger(neighbourhoods)
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
nniNeighbourhoods<-function(tree, verbose = TRUE)
{
  tree <- ape::unroot.multiPhylo(tree)
  tree <- ape::unique.multiPhylo(tree)
  l <- length(tree)
  a <- list()
  NNIneigh<-list()
  counter = 1
  for (i in 1:l) {
    n <- phangorn::nni(tree[[i]])
	  if (ape::is.binary(tree[[i]]) == FALSE) warning('You have trees with polytomies, the package cannot place them into islands yet.')
    for (j in 1:length(n)) {
		  if (verbose == TRUE) {
			  print(paste("At", i, "of", l, "unique trees and", j, "of", length(n), "NNI trees", sep=" "))
		  }
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
    NNIneigh[[counter]] <- a
    a <- list()
    counter = counter + 1
  }
  NNIneigh <- unique(NNIneigh)
}