library(httr)
library(rvest)
library(purrr)
library(tibble)
library(dplyr)

mykey = "fY3aMpfVj2FE8nTEVQWPoP09Xs7dngEVvrLZKUh2"

##########  search API to retrieve ndbno's ###############################

foodURL =  "https://api.nal.usda.gov/ndb/search"
searchq =  "mcDonald"

searchout  = GET(
  url = foodURL,
  query = list(
    api_key = mykey ,
    format = "json",
    q = searchq
  )
) %>% 
  content()

## in search out there is a list with search results
## we return it as data frame per componenet using purrr

mcdonalds = map_df(searchout[["list"]][["item"]], as.tibble)


############################ food nutrient report for one ndbno ##############################
ndbno_in = 21238
getnutr_values = function(ndbno_in)
{
  nutrientsURL =  "https://api.nal.usda.gov/ndb/reports/"

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
    nutrdata %>% select(naam,ndbno,name,group, unit, value)
  }

  nutrientdata(x=ntr[["report"]][["food"]])
}

getnutr_values(21238)


####  get values for all mcdonalds products

mcdonalds_nutr = map_df( mcdonalds$ndbno, getnutr_values) %>%  distinct()


mcdondalds_nutr %>% group_by(ndbno) %>%  summarise(n=n())
