#remotes::install_github("cienciadedatos/dados")

# Code to not execute or include the solutions
knitr::opts_chunk$set(eval = FALSE)
knitr::opts_chunk$set(include = FALSE)

# Carregando os pacotes necessários

library(tidyverse)
library(dados)
library(scales) #Pra formatar o y como % no exemplo dos pinguins

#-----------------------------------------------

table(pinguins$especie, pinguins$ilha )



Q1c <- pinguins  %>% 
  count(ilha, especie) %>%
  ggplot() + 
  geom_col(aes(ilha, n, fill = especie), position = "fill")
Q1c

TabelaPinguins <- table( pinguins$especie, pinguins$ilha )
TabelaPinguins

n = sum(TabelaPinguins)
n

testeQq <- chisq.test(tabelaQ1d)
QQ = as.numeric(testeQq$statistic)
QQ

C <- sqrt( QQ / ( QQ + n ) )
C

CMod <- C/sqrt(3-1/3)
CMod

Phi <- sqrt(QQ/n)
Phi

Cramer <- sqrt(QQ/(n* (2) ) )
Cramer

#e)-----------------------------------------------

TabelaDiamantes <- table(diamonds$cut, diamonds$color)
TabelaDiamantes












