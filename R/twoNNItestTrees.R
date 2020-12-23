#' Example trees for 2-NNI island extraction
#'
#' Three phylogenetic trees, all more than 1 NNI away from each other. Trees correspond to x-NNI example in Serra Silva and Wilkinson(202x).
#' Running the example should yield 2 islands, one with 2 trees and one with a single tree.
#'
#' @docType data
#'
#' @usage data(twoNNItestTrees)
#'
#' @format An object of class "multiPhylo".
#'
#' @keywords datasets
#'
#' @examples
#' data(twoNNItestTrees)
#' neighbourhoods <- nniNeighbourhoods(twoNNItestTrees)
#' islands <- neighbourhoodMerger(neighbourhoods)
#' #write.islands(islands)
"twoNNItestTrees"