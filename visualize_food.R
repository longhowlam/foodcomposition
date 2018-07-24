##### Use the reticulate package to call the python UMAP package ##############

library(reticulate)
library(dplyr)
library(plotly)
library(irlba)

##### umap package is in test_lhl conda environment ###########################
## remove the vgg_notop object, for some reason it points to 
## conda r-tensorflow env where there is no umpa module

use_condaenv(condaenv = "test_lhl")
umap = import("umap")

embedding = umap$UMAP(
  n_neighbors = 5L,
  n_components = 2L,
  min_dist = 0.51
)

## compute UMAP with 3 components
M = as.matrix(food %>% select(-naam, -ndbno, - group ))
embedding_out = embedding$fit_transform(M)

##### Plot the embeddings with plotly #########################################
plotdata = data.frame(embedding_out)
plotdata$naam = food$naam
plotdata$group = food$group
plot_ly(
  plotdata, 
  x = ~X1,
  y = ~X2, 
  color = ~group,
  text = ~naam,
  size = 3, sizes = c(5,10) 
) 


############# plot using truncated SVD ######################
M = as.matrix(food %>% select(-naam, -ndbno, - group ))

out = irlba(M,2)
p = out$u %*% diag(out$d)
plotdata = data.frame(p)
plotdata$naam = food$naam
plotdata$group = food$group
plot_ly(
  plotdata, 
  x = ~X1,
  y = ~X2,
  color = ~group,
  text = ~naam,
  size = 3, sizes = c(5,10) 
) %>% 
  layout(title = "Different food")



