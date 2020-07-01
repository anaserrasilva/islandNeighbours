# islandNeighbours
## R package to extract NNI islands from phylogenetic tree distributions

The functions in this package were originally described in Serra Silva and Wilkinson (202#).

### What does *islandNeighbours* do?

*islandNeighbours* is an R package that allows you to extract NNI islands from sets of multiple trees. At the moment it can only deal with fully resolved trees, so trees containing polytomies may not be sorted into the correct NNI islands.

### Installing *islandNeighbours*
At the moment the package is only available from GitHub.

```r
library(devtools)
install_github("anaserrasilva/islandNeighbours")
library(islandNeighbours)
```

If this fails, try:

```r
library(devtools)
install_github("thackl/thacklr")
install_github("anaserrasilva/islandNeighbours")
library(islandNeighbours)
```

### Using *islandNeighbours*

```r
#load example file provided in package
data(testTrees) #multiPhylo with 10 trees

#extract NNI neighbourhoods
neighbourhoods <- nniNeighbourhoods(testTrees) #outputs list with 10 multiPhylo objects

#merge neighbourhoods with shared trees to obtain NNI islands
islands <- nniIslands(neighbourhoods) #outputs list with 2 multiPhylo objects, each with 5 trees

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre
```

There are two additional examples in the [supplementary materials](https://github.com/anaserrasilva/MajorityRuleAndTreeIslands/tree/master/PardoBayes_islands) for Serra Silva and Wilkinson (202#).

### Planned additions to *islandNeighbours*

- Adding the capacity to deal with polytomies
- Expand *nniNeighbours* to deal with *x*-NNI islands, described in Serra Silva and Wilkinson (202#)
- Allow user to choose treefile format when using *write.islands*

### Citation

If you use *islandNeighbours* please cite:

Serra Silva, A. and Wilkinson, M. (202#). On defining islands of trees and their effects on consensus. *In prep.*


### Useful readings

Hendy, M. D., Steel, M. A., Penny, D. and Henderson, I. M. (1988). [Families of trees and consensus](http://citeseerx.ist.psu.edu/viewdoc/versions?doi=10.1.1.638.6890) *in* Classification and Related Methods of Data Analysis (H. H. Block, ed.). Elsevier, New York.

Maddison, D. R. (1991) [The discovery and importance of multiple islands of most-parsimonious trees](https://doi.org/10.1093/sysbio/40.3.315). Syst. Zool., 40:315-328
