#' nniIslands Function
#'
#' This function merges the 1-NNI neighbourhoods outputted by \code{\link{nniNeighbourhoods}} with shared trees, until only the NNI islands are left.
#'
#' @param neighbourhoods list of objects of class "multiphylo"
#' @param verbose Prints the function's progress. Defaults to TRUE
#'
#' @return List of "multiphylo" objects
#'
#' @import ape
#' phytools
#' thacklr
#'
#' @examples
#' data(testTrees)
#' neighbourhoods <- nniNeighbourhoods(testTrees)
#' islands <- nniIslands(neighbourhoods)
#' #write.islands(islands)
#'
#' @export 
nniIslands<-function(neighbourhoods, verbose = TRUE) 
{
  l <- length(neighbourhoods)
  m <- matrix(data=0, nrow=l, ncol=l)
  island <- list()
  islands <- list()
  index <- vector()
  for (i in 1:l) {
	if (verbose == TRUE) {
		print(paste("At", i, "of", l, "NNI neighbourhoods", sep=" "))
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
    nniIslands(islands)
  }
  else {
    return(islands)
    break
  }
}