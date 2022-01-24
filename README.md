# islandNeighbours
## R package to extract NNI, RF and QD islands from phylogenetic tree distributions

The functions in this package were originally described in Serra Silva and Wilkinson (2021).

### What does *islandNeighbours* do?

*islandNeighbours* is an R package that allows you to extract NNI and SD/RF islands from sets of multiple trees. At the moment it can only deal with fully resolved trees, so trees containing polytomies will not be sorted into the correct NNI islands. For SD islands, if non-binary trees are present the islands will have to be inspected after extraction to ensure the trees were not missorted.

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

For 1-NNI islands
```r
#load example file provided in package
data(testTrees) #multiPhylo with 10 trees

#extract NNI neighbourhoods
neighbourhoods <- nniNeighbourhoods(testTrees) #outputs list with 10 multiPhylo objects

#merge neighbourhoods with shared trees to obtain NNI islands
islands <- neighbourhoodMerger(neighbourhoods) #outputs list with 2 multiPhylo objects, each with 5 trees

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre
```

For 2-NNI islands
```r
#load example file provided in package
data(twoNNItestTrees) #multiPhylo with 3 trees

#extract 2-NNI neighbourhoods
neighbourhoods <- two_nniNeighbourhoods(twoNNItestTrees) #outputs list with 3 multiPhylo objects

#merge neighbourhoods with shared trees to obtain NNI islands
islands <- neighbourhoodMerger(neighbourhoods) #outputs list with 2 multiPhylo objects, one with 2 trees and one with 1 tree

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre
```

For x-RF islands
```r
#load example file provided in package
data(testTrees) #multiPhylo with 10 trees

##using property algorithm analogous to graph colouring
#We recommend you use this function, since this is the faster method
#WARNING Always add output = list() parameter, this is needed for the recursion to work!
islands <- xRFislands(testTrees, threshold = 2, output = list()) #outputs list with 2 multiPhylo objects, each with 5 trees

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre

##using neighbourhood extraction and merging
#this approach is slower
#extract NNI neighbourhoods
neighbourhoods <- xRFneighbourhoods(testTrees, threshold = 2) #outputs list with 10 multiPhylo objects

#merge neighbourhoods with shared trees to obtain NNI islands
islands <- neighbourhoodMerger(neighbourhoods) #outputs list with 2 multiPhylo objects, each with 5 trees

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre

```

For x-QD islands
```r
#load example file provided in package
data(testTrees) #multiPhylo with 10 trees

##using property algorithm analogous to graph colouring
#We recommend you use this function, since this is the faster method
#WARNING Always add output = list() parameter, this is needed for the recursion to work!
islands <- xQDislands(testTrees, threshold = 6552, output = list()) #outputs list with 2 multiPhylo objects, each with 5 trees

#save each island to an individual tree file
write.islands(islands) #outputs 2 Newick formatted tree files, island_1.tre and island_2.tre
```

For large tree distributions (>500 trees) it is advisable to run the neighbourhood extraction in parallel, please set verbose = FALSE.

There are two additional examples in the [supplementary materials](https://github.com/anaserrasilva/MajorityRuleAndTreeIslands/tree/master/PardoBayes_islands) for Serra Silva and Wilkinson (2021).


### Planned additions to *islandNeighbours*

- Adding the capacity to deal with polytomies
- Expand *nniNeighbours* to deal with *x*-NNI islands, described in Serra Silva and Wilkinson (2021)
- Allow user to choose treefile format when using *write.islands*
- Generalise the x-RF function to allow for other tree-to-tree distance, e.g. quartet distances
- Add the capacity to extract SPR and TBR islands

### Potential additions/modifications based on user input

Current functions unroot trees and ignore branch lengths, if there is enough interest functions that sort rooted trees and/or take branch lengths into account might be added.

### Citation

If you use *islandNeighbours* please cite:

Serra Silva, Ana and Wilkinson, Mark (2021). [On Defining and Finding Islands of Trees and Mitigating Large Island Bias](https://doi.org/10.1093/sysbio/syab015). Systematic Biology, 70(6), 1282-1294.

### Author contributions

Serra Silva, A. implemented all functions and developed the x-NNI extraction algorithm

Wilkinson, M. developed the property algorithm 


### Useful readings

Hendy, M. D., Steel, M. A., Penny, D. and Henderson, I. M. (1988). [Families of trees and consensus](http://citeseerx.ist.psu.edu/viewdoc/versions?doi=10.1.1.638.6890) *in* Classification and Related Methods of Data Analysis (H. H. Block, ed.). Elsevier, New York.

Maddison, D. R. (1991) [The discovery and importance of multiple islands of most-parsimonious trees](https://doi.org/10.1093/sysbio/40.3.315). Syst. Zool., 40:315-328
