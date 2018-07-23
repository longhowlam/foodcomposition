library(httr)
library(rvest)
library(purrr)
library(tibble)

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


############################ food nutrient report ##############################

nutrientsURL =  "https://api.nal.usda.gov/ndb/reports/"

resp2 = GET(
  url = nutrientsURL,
  query = list(
    api_key = mykey ,
    format = "json",
    ndbno = "01009"
  )
)

ntr = content(resp2)
