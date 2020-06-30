#' Example trees for islandNeighbours package
#'
#' Selection of ten phylogenetic trees from the set of most parsimonious trees recovered from Pardo et al.'s (2017) datamatrix.
#'
#' @docType data
#'
#' @usage data(testTrees)
#'
#' @format An object of class "multiPhylo".
#'
#' @keywords datasets
#'
#' @references Pardo et al. (2017) PNAS 114:5389-5395
#' (\href{https://pubmed.ncbi.nlm.nih.gov/28630337/}{PubMed}) 
#'
#' @source \href{https://github.com/anaserrasilva/MajorityRuleAndTreeIslands}{GitHub}
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- nniIslands(neighbourhoods)
#' #write.islands(islands)
"testTrees"