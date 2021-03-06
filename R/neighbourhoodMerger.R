#' neighbourhoodMerger Function
#'
#' This function merges the 1-NNI, 2-NNI or x-SD neighbourhoods outputted by \code{\link{nniNeighbourhoods}}, \code{\link{two_nniNeighbourhoods}} and \code{\link{xRFneighbourhoods}} with shared trees, until only the tree islands are left.
#'
#' @param neighbourhoods list of objects of class "multiPhylo"
#' @param verbose Prints the function's progress. Defaults to TRUE
#'
#' @return List of "multiPhylo" objects
#'
#' @import ape
#' phytools
#' thacklr
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
neighbourhoodMerger<-function(neighbourhoods, verbose = TRUE) 
{
  l <- length(neighbourhoods)
  m <- matrix(data=0, nrow=l, ncol=l)
  island <- list()
  islands <- list()
  index <- vector()
  for (i in 1:l) {
	if (verbose == TRUE) {
		print(paste("At", i, "of", l, "neighbourhoods", sep=" "))
	}
    for (j in 1:l) {
      #build matrix showing neighbourhoods with shared trees (TRUE stored as 1)
      if (i != j & m[i,j] == 0) {
        if (length(ape::unique.multiPhylo(c(neighbourhoods[[i]], neighbourhoods[[j]]), use.edge.length = F)) < length(c(neighbourhoods[[i]], neighbourhoods[[j]]))) {
          m[i,j] = m[j,i] <- TRUE
        }
        else {
          m[i,j] = m[j,i] <- FALSE
        }
      }
      if (i == j) {
        m[i,j] <- 0
      }
    }
  }
  m <- as.data.frame(m)
  counter = 1
  for (row in 1:nrow(m)) { #separate from merge/replace loop, because number of all-zero rows will change
    #extract singleton islands and islands that no longer share trees with any remaining neighbourhood
    if (length(which(m[row,] == 1)) == 0) {
      islands[[counter]] <- phytools::as.multiPhylo(neighbourhoods[[row]])
      counter = counter + 1
    }
  }
  counter = 1 + length(islands)
  for (row in 1:nrow(m)) { #try to optimise
    if (length(which(m[row,] == 1)) > 0) {
      #merge neighbourhoods and recode merged pairs as 0s to prevent duplicate merged neighbourhoods
      index <- c(index, which(m[row,] == 1))
      for (j in 1:length(index)) {
        #print(index[j])
        m[row,index[j]] = m[index[j],row] <- 0
        island <- c(island, phytools::as.multiPhylo(neighbourhoods[[row]]))
        island <- c(island, thacklr::as.multiPhylo.list(neighbourhoods[[index[j]]]))
        #print(m)
      }
      island <- ape::unique.multiPhylo(as.multiPhylo.list(island), , use.edge.length = F)
      islands[[counter]] <- island
      island <- list()
      index <- vector()
      counter = counter + 1
    }
  }
  y <- islands
  li <- length(y)
  n <- matrix(data=0, nrow=li, ncol=li) #same as m but used to inform call of recursive function
  for (i in 1:li) {
    for (j in 1:li) {
      if (i != j & n[i,j] == 0) {
        if (length(ape::unique.multiPhylo(c(y[[i]], y[[j]]), use.edge.length = F)) < length(c(y[[i]], y[[j]]))) {
          n[i,j] = n[j,i] <- TRUE
        }
        else {
          n[i,j] = n[j,i] <- FALSE
        }
      }
      if (i == j) {
        n[i,j] <- 0
      }
    }
  }
  if (any(n == 1) == T) {
    neighbourhoodMerger(islands, verbose)
  }
  else {
    return(islands)
  }
}