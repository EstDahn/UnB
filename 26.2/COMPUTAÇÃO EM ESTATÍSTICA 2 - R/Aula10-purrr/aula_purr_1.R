######################################################
# Aula CE2 - Passing a function to another function  #
######################################################
library(tidyverse)
library(repurrrsive)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

ma <- mean(df$a)
mb <- mean(df$b)
mc <- mean(df$c)
md <- mean(df$d)

output <- numeric(ncol(df))
#output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[i] <- mean(df[[i]])          # 3. body
}
output


col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}

col_mean(df = df)
iris
col_mean(df = iris)


col_median <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- median(df[[i]])
  }
  output
}
col_mean(df)
col_median(df)





col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- sd(df[[i]])
  }
  output
}
col_sd(df)


# inputs da função
## df: dataframe...
## funcao: função que vai ser aplicada em cada coluna
col_summary <- function(df, funcao, ...) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- funcao(df[[i]], ...)
  }
  out
}
col_summary(df=df, funcao=median, na.rm=T)
col_summary(df, sd)

mean(1:100, oi = 2)
col_sd(df, oi=2)

col_summary(df, mean)
col_summary(df, sd)
col_summary(df=df, fun=median)



############################
######## Apply #############
############################
?apply
apply(df, 2, mean)  # argumento entrada: dataframe/array, argumento saída: dataframe/array
col_summary(df, mean)

?lapply
df_list <- as.list(df)
apply(df_list, 2, mean)
lapply(df_list, mean) # argumento entrada: dataframe/lista, argumento saída: lista

df_list[[1]][1] <- NA
lapply(df_list, mean) # argumento entrada: dataframe/lista, argumento saída: lista
lapply(df_list, mean, na.rm=T) # argumento entrada: dataframe/lista, argumento saída: lista
lapply(df_list, mean, nas=T) # argumento entrada: dataframe/lista, argumento saída: lista

sapply(df_list, mean, simplify = T) # argumento entrada: dataframe/lista, argumento saída: ? (simplify=T)

mean(df_list)

############################
#### purr package ##########
############################

# Extrair elementos de uma lista
a_list <- list(num = c(8, 9),
               log = TRUE,
               cha = c("a", "b", "c"))

a_list["num"]
a_list[["num"]]


# Star Wars (primeira parte do exercício do slide)
View(sw_people)
sw_people[[4]]
sw_people[[4]][["height"]]
sw_people %>% pluck(4, "height")


# Família Map
set.seed(1000)
exams <- list(
  student1 = round(runif(10,50,100)),
  student2 = round(runif(10,50,100)),
  student3 = round(runif(10,50,100)),
  student4 = round(runif(10,50,100)),
  student5 = round(runif(10,50,100))
)

x <- c("hw1","hw2","hw3","hw4","hw5","hw6","hw7","hw8","hw9","hw10")
set_names(exams, x) # note que funções do R não funcionam com listas!
mean(exams) # note que funções do R não funcionam com listas!

exams %>% map(set_names, nm = x)
exams %>% map_dfr(set_names, nm = x)
exams %>% map_dfc(set_names, nm = x)


##### Map family ###########
# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.
?map

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

map(df, median)
map_dbl(df, median)
map_chr(df, median)
map_int(df, median)
map_dbl(df, sd)
map_dbl(df, mean, na.rm=T)


# Star Wars (segunda parte do exercício do slide)
# Who was taller Anakin Skywalker or Darth Vader?
library(repurrrsive)
View(sw_people)

# Qual posição (elemento) da lista estão esses personagens?
sw_people %>% pluck('name') # note que funções do R não funcionam com listas!
sw_people %>% map_chr(pluck, 'name')
sw_people %>% 
  map_chr(pluck, 'name') %in% c("Darth Vader", "Anakin Skywalker") %>%
  which()

# Extrair as respectivas alturas
sw_people %>% pluck(4, 'height')
sw_people %>% pluck(11, 'height')
(sw_people %>% map_chr(pluck, 'height'))[c(4,11)]




