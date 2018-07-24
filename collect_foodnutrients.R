mcdonalds = searchFood(searchq = "mcdonald") %>% 
  transpose_nutrients() %>% 
  mutate(group = paste(group,str_sub(naam,1,10) ))

pizzahut = searchFood(searchq = "pizza hut") %>% 
  transpose_nutrients() %>% 
  mutate(group = paste(group,str_sub(naam,1,9) ))

Veggies = searchFood(fg = "Vegetables and Vegetable Products") %>% 
  transpose_nutrients()

Fruits = searchFood(fg = "Fruits and Fruit Juices") %>% 
  transpose_nutrients()


food = bind_rows(
  mcdonalds, pizzahut, apple, broccoli, tomatoes, banana, Veggies, Fruits
) %>% 
  mutate_if(is.numeric, function(x){ifelse(is.na(x),0,x)})
