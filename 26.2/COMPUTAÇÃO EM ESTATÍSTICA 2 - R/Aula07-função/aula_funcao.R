##############################################
####### Aula CE2 - Prof. Thais ###############
##############################################


# Exemplo do slide - padronização
x <- rnorm(10)
remove.na <- F
(x - min(x, na.rm= T))/ (max(x, na.rm=T ) - min(x, na.rm=T))
(x - min(x, na.rm= remove.na))/ (max(x, na.rm=remove.na ) - min(x, na.rm=remove.na))



padronizar <- function(x, remove.na=F ){
  (x - min(x, na.rm= remove.na))/ (max(x, na.rm=remove.na ) - min(x, na.rm=remove.na))
}

library(tidyverse)
rnorm(10)
df <- tibble(
  a = rnorm(10), b = rnorm(10),
  c = rnorm(10), d = rnorm(10))
padronizar(x = df$a, remove.na= T)
df$a = padronizar(df$a, T)
df$b = padronizar(df$b, T)
df$c = padronizar(df$c, T)
df$d = padronizar(df$d, T)


# testando a função padronizar
padronizar(c(1, 2, 3, NA, 5), remove.na=F)
padronizar(c(0, 0.1, 0.2, 0.7, 1), remove.na=T)

x = c(1, 2, 3, NA, 5)
remove.na = T
(x - min(x, na.rm= remove.na))/ (max(x, na.rm=remove.na ) - min(x, na.rm=remove.na))


x = c(1, 2, 3, NA, 5)
remove.na = T
(x - min(x, na.rm = remove.na)) / (max(x, na.rm = remove.na) - 
                                     min(x, na.rm = remove.na))


## Outra opção: função padronizar01
padronizar01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
padronizar01(c(0, 5, 10))
padronizar01(c(-10, 0, 10))
padronizar01(c(1, 2, 3, NA, 5))


## Exercise 2
## Write your own function to cumpute the variance of a vector 

variance <- function(x, remover.na){
  (sum((x-mean(x, na.rm = remover.na))^2))/(length(x)-1)
}

z <- -100:100
var(z)
variance(z, remover.na=F)


# Função padronizar e RETURN
df <- tibble(
  a = rnorm(10), b = rnorm(10),
  c = rnorm(10), d = rnorm(10))

padronizar <- function (x, retirada = F){
  y <- x-min(x, na.rm = retirada)
  z <- max(x, na.rm = retirada) -  min(x, na.rm = retirada)
  w <- y/z
  return(list(y,z,w))
}
padronizar(df$a, retirada=T)


## Return 
complicated_function <- function(x, y, z) {
  if (length(x) == 0 || length(y) == 0) {
    return(0)
  }
  
  # Complicated code here
}


## Environment

# Caso 1
z <- 0
f <- function(x) {
  z <- 1000
  j <- x^2
  x + z + j 
} 

f(10)
y <- 100
f(y)
z

# Caso 2
z <- 0
f <- function(x) {
  j <- x^2
  x + z + j 
} 

f(10)
z

# Caso 3
rm(z)
f <- function(x) {
  j <- x^2
  x + z + j 
} 

f(10)
z


## Exercício: Escrever uma função que retorna o seguinte texto para a data que o usuário escolher
"Bom dia, hoje é quarta-feira dia 07 de outubro de 2026!"
paste("Boa tarde", "Thais!")

library(lubridate)
mensagem <- function(x = today()){
  semana <- lubridate::wday(x, label=T, abbr = F)
  paste0("Boa tarde, hoje é ", semana,
         " dia ", lubridate::day(x), " de ", lubridate::month(x, label=T, abbr = F), 
         " de ", lubridate::year(x), "!")
}
mensagem()
z <- "10/05/2027"
mensagem(dmy(z))

