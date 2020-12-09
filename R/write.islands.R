#' write.islands Function
#'
#' This function writes the NNI islands identified by \code{\link{nniIslands}} to individual Newick format tree files.
#'
#' @param islands list of objects of class "multiPhylo"
#'
#' @return None
#'
#' @import ape
#' phytools
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- neighbourhoodMerger(neighbourhoods)
#' #write.islands(islands)
#'
#' @references Maddison, D. R. (1991) \href{https://doi.org/10.1093/sysbio/40.3.315}{The discovery and importance of multiple islands of most-parsimonious trees}. \emph{Syst. Zool.}, 40:315-328 
#'
#' @export 
write.islands <- function(islands) 
{
 l <- length(islands)
 for (i in 1:l) {
   ape::write.tree(phytools::as.multiPhylo(islands[[i]]), paste("island_", i, ".tre", sep = ""), append = F)
 }
}