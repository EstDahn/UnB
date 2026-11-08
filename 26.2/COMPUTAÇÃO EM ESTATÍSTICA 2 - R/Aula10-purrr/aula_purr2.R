#################################
#### LISTAS E PURRR #############
#################################
library(repurrrsive)
library(tidyverse)

set.seed(1000)
exams <- list(
  student1 = round(runif(10,50,100)),
  student2 = round(runif(10,50,100)),
  student3 = round(runif(10,50,100)),
  student4 = round(runif(10,50,100)),
  student5 = round(runif(10,50,100))
)


## Família map com funções elaboradas pelo usuário
fun1 <- function(x) {length(x)==10}
map_lgl(exams, fun1)
fun1(exams[[1]])
fun1(exams[[2]])
fun1(exams[[3]])
...

map_lgl(exams, function(x) length(x) ==10)
map_lgl(exams, ~length(.) == 10)

exams %>%
  map(length) 

exams %>%
  map(length) %>%
  map_lgl(all.equal, 10)


# exercício do slide
fun2 <- function(x) (sum(x)-min(x))/9
exams %>% map_dbl(fun2)

exams %>% map_dbl(~(sum(.) - min(.)) / 9)
(sum(exams[[1]])-min(exams[[1]]))/9

# outro exemplo
fun1 <- function(x) mean(x[x!=min(x)])
exams %>% map_df(fun1)
exams %>% map_df(~ mean(.[.!=min(.)]))


# map2
extra <- list(0,0,1,1,.5)
mean(exams[[1]]) + extra[[1]]

map2_dbl(exams, extra, ~ mean(.x) + .y )

exams %>% map2_dbl(extra, ~ mean(.x) + .y )

# exemplo pmap
x <- list(1, 1, 1)
y <- list(10, 20, 30)
z <- list(100, 200, 300)
View(list(x, y, z))
pmap(list(x, y, z), sum, na.rm=T)


# Map aplicado a um dataframe
# Compute the mean of every column in mtcars
View(mtcars)
map_dbl(mtcars, mean)


# Map aplicado a um vetor 
## From random normals with means of -10, 0, 10, and 100, generate 10 samples each.
rnorm(10, -10, 1)
rnorm(10, 0, 1)
rnorm(10, 10, 1)
rnorm(10, 100, 1)
map_dfc(c(-10,0,10,100), ~rnorm(10, ., 1))


# Exercícios:

# Calcule a nota mediana de cada aluno


# Calcule para cada aluno as estatísticas resumo: min/max, quartis, média/mediana


# A partir do resultado anterior, extraia a mediana.



# Códigos
exams %>% map_dbl(quantile, prob=0.5)

exams %>% 
  map(summary)

exams %>% 
  map(summary) %>% 
  map_dbl(~.['Median'])


exams2 <- exams %>% map(summary) 
map_dbl(exams2, function(x) x['Median'])

exams$student1 %>% summary %>% .['Median']


## Exercícios - família MAP #####
# Write code that uses one of the map functions to:

## 1. Determine the type of each column in nycflights13::flights.
library(nycflights13)
View(nycflights13::flights)

## 2. Compute the number of unique values in each column of iris.
View(iris)

## 3. From random normals with means of -10, 0, 10, and 100 and variances c(1, 5, 10, 15), 
##    generate 10 samples each using the map family.


## 4. Check if each column of diamonds is a factor.

