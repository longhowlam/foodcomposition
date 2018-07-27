##### Use the reticulate package to call the python UMAP package ##############

library(reticulate)
library(dplyr)
library(plotly)
library(umap)
library(stringr)

##### umap package is in test_lhl conda environment ###########################

use_condaenv(condaenv = "test_lhl")
umap = import("umap")

embedding = umap$UMAP(
  n_neighbors = 10L,
  n_components = 2L,
  min_dist = 0.6
)

## compute UMAP with k components
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
  text = ~naam
) %>% 
  layout(title = "For 1400 food products the 33 dimensional nutrient values projected onto 2 dimensions using UMAP")

######### R implementation, which is much slower but has no external dependencies ##########################
custom.config = umap.defaults
custom.config$n_neighbors = 10
custom.config$min_dist = 0.6

umapfit = umap(M, custom.config)
embedding_out = umapfit$layout

### given an embedding you can score new food products on this embedding
cucumber = food %>% 
  filter( str_detect(naam, "Cucumber" )) %>% 
  select(-naam, -ndbno, - group ) %>% 
  as.matrix()
cucumber_umap = predict(umapfit, cucumber)
head(iris.wnoise.umap, 3)











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



