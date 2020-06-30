#' write.islands Function
#'
#' This function writes the NNI islands identified by \code{\link{nniIslands}} to individual Newick format tree files.
#'
#' @param islands list of objects of class "multiphylo"
#'
#' @return None
#'
#' @import ape
#' phytools
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- nniIslands(neighbourhoods)
#' #write.islands(islands)
#'
#' @references Maddison (1991) Syst Zool 40:315-328
#' (\href{https://doi.org/10.1093/sysbio/40.3.315}{OUP}) 
#'
#' @export 
write.islands <- function(islands) 
{
 l <- length(islands)
 for (i in 1:l) {
   ape::write.tree(phytools::as.multiPhylo(islands[[i]]), paste("island_", i, ".tre", sep = ""), append = F)
 }
}