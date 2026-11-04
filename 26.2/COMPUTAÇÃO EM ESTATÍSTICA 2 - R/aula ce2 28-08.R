library(tidyverse)
library(babynames)


#tamanho de caracteres
str_length(c("a","frase"))
str_length("aula ce2 19-08.R")

#contage nuemro de caracteres dos nomes
contagem1 <- babynames |> 
  count(tamanho = str_length(name), wt = n)

contagem

#equivalente a:

contagem2 <- babynames |> 
  mutate(tamanho = str_length(name)) |> 
  count(tamanho, wt = n)

contagem2

#+15 e rank

Nomes15 <- babynames |> 
  filter(str_length(name) ==15) |> 
  group_by(name)

Nomes15


#RANK 15
rank15 = babynames |> 
  mutate(tamanho = str_length(name)) |>
  filter(tamanho == 15) |> 
  count(name, wt = n, sort  = TRUE)
  
rank15
  
#Expressão regular
x <- c("apple","banana","pear")
str_view(x, "an")
# ".a." significa qualquer caracter em qualquer lado
str_view(x, ".a.")


# "^a" significa primeira letras
str_view(x, "^a")

# "^a" significa ultima letra
str_view(x, "a$")

library(sentences)

install.packages(sentences)









