##############################
## Aula CE 2 #################
##############################
library(tidyverse)

############################
######## While loops #######
############################
while (condition) {
  # body
}


for (i in 1:seq_along(x)){
  # body
}


## Example 

## Find how many tries (on average) it takes to get three heads in a row


## 1. Write a function that simulates a coin flip and returns "T" for tails or "H" for heads.
flip <- function() sample(c("T", "H"), 1, prob=c(0.5,0.5))
flip()


## 2. How many tries it takes to get three heads in a row (simulate it once).
flips <- 0  # contador do número de repetições do experim. (jogar moeda pra cima)
nheads <- 0 # contador do número de caras em sequência
while (nheads < 3) {
  if (flip() == "H") { 
    nheads <- nheads + 1
  } else {
    nheads <- 0 
  }
  flips <- flips + 1 
}
flips


## 3. Simulate it 1000 times and calculate how many tries (on average) it takes to get three heads in a row
nvezes <- 1000
flips2 <- numeric(nvezes)
for(j in 1:nvezes){ # número de repetições do experimento com sucesso
  flips <- 0 # contador do número vezes (jogar moeda pra cima)
  nheads <- 0 # contador do número de caras em sequência
  while (nheads < 10) {
    if (flip() == "H") {
      nheads <- nheads + 1
    } else {
      nheads <- 0
    }
    flips <- flips + 1
  }
  flips2[j] <- flips
  print(j)
}
mean(flips2)