#' Example trees for islandNeighbours package
#'
#' Selection of ten phylogenetic trees from the set of most parsimonious trees recovered from Pardo et al.'s (2017) datamatrix.
#' Running the example should yield 2 islands, each with 5 trees.
#'
#' @docType data
#'
#' @usage data(testTrees)
#'
#' @format An object of class "multiPhylo".
#'
#' @keywords datasets
#'
#' @references Pardo et al. (2017) \href{https://pubmed.ncbi.nlm.nih.gov/28630337/}{Stem caecilian from the Triassic of Colorado sheds light on the origins of Lissamphibia}. \emph{PNAS}, 114:5389-5395
#'
#' Maddison, D. R. (1991) \href{https://doi.org/10.1093/sysbio/40.3.315}{The discovery and importance of multiple islands of most-parsimonious trees}. \emph{Syst. Zool.}, 40:315-328
#'
#' @source \href{https://github.com/anaserrasilva/MajorityRuleAndTreeIslands}{https://github.com/anaserrasilva/MajorityRuleAndTreeIslands}
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- neighbourhoodMerger(neighbourhoods)
#' #write.islands(islands)
"testTrees"
