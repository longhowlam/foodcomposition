library(httr)
library(rvest)
library(purrr)
library(tibble)
library(dplyr)
library(tidyr)
library(stringr)

mykey = readRDS("mykey.RDS")
foodURL =  "https://api.nal.usda.gov/ndb/search"
nutrientsURL =  "https://api.nal.usda.gov/ndb/reports/"

##########  search API to retrieve ndbno's ###############################
searchq = "raw broccoli"
searchFood = function(searchq = "", fg = "", maxr = 200){

  searchout  = GET(
    url = foodURL,
    query = list(
      api_key = mykey ,
      format = "json",
      max = as.character(maxr),
      q = searchq,
      fg = fg
    )
  ) %>% 
  content()

  ## in search out there is a list with search results
  ## we return it as data frame per componenet using purrr
  map_df(searchout[["list"]][["item"]], as.tibble)
}

## example call
# mcdonalds = searchFood(searchq = "mcdonald")


############################ food nutrient report for one ndbno ##############################
getnutr_values = function(ndbno_in)
{
  ntr = GET(
    url = nutrientsURL,
    query = list(
      api_key = mykey ,
      format = "json",
      ndbno = ndbno_in
    )
  ) %>%  content()

  nutrientdata = function(x)
  {
    nutrdata = map_df(x$nutrients, function(x){x[1:6] %>% as.tibble})
    nutrdata$ndbno = x$ndbno
    nutrdata$naam = x$name
    nutrdata %>% select(naam,ndbno,name,group, unit, value) %>% mutate(value = as.numeric(value))
  }

  nutrientdata(x=ntr[["report"]][["food"]])
}

## example call
## getnutr_values(21238)


#### get values for all searched products and 
#### transpose so that different nutrient values are in columns
transpose_nutrients = function(x){
 out = map_df( x$ndbno, getnutr_values) %>% 
    distinct() %>% 
    select(naam, ndbno, name, value) %>%  
    spread(key = name, value = value ) %>% 
    mutate_if(is.numeric, function(x){ifelse(is.na(x),0,x)})
 out %>% mutate(group = x$group)
}


