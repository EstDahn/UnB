###################################################
## Aula CE2 - Simulação do álbum de figurinhas ####
###################################################

# a. Simule o sorteio de 1 pacote de figurinhas. 
#    Retorne 1 tabela com o número das figurinhas sorteadas e a quantidade de cada.
n.figuras <- 980
n.pacote <- 7
probabilidade <- rep(1/n.figuras, n.figuras)
pacote.aux <- sample(1:n.figuras, n.pacote, replace=T, prob = probabilidade)
pacote.aux <- table(pacote.aux)


# b. Simule o preenchimento de 1 álbum de figurinhas
n.figuras <- 980
n.pacote <- 7
preco <- 7
probabilidade <- rep(1/n.figuras, n.figuras)

resultado <- matrix(0, nrow = 1, ncol= n.figuras)
faltantes <- n.figuras
figuras.obtidas <- numeric(n.figuras)
while(faltantes>0){
    pacote.aux <- sample(1:n.figuras, n.pacote, replace=T, prob = probabilidade)
    pacote.aux <- table(pacote.aux)
    posicoes <- as.numeric(names(pacote.aux))
    figuras.obtidas[posicoes] <- figuras.obtidas[posicoes] + pacote.aux
    faltantes <- sum(figuras.obtidas==0)
}
figuras.obtidas


# c. Simule o preenchimento de 100 álbuns de figurinhas
n.figuras <- 980
n.pacote <- 7
preco <- 7
probabilidade <- rep(1/n.figuras, n.figuras)
n.simulacoes <- 100

resultado <- matrix(0, nrow = n.simulacoes, ncol= n.figuras)
for(i in 1:n.simulacoes){ 
  faltantes <- n.figuras
  figuras.obtidas <- numeric(n.figuras)
  while(faltantes>0){
    pacote.aux <- sample(1:n.figuras, n.pacote, replace=T, prob = probabilidade)
    pacote.aux <- table(pacote.aux)
    posicoes <- as.numeric(names(pacote.aux))
    figuras.obtidas[posicoes] <- figuras.obtidas[posicoes] + pacote.aux
    faltantes <- sum(figuras.obtidas==0)
  }
  resultado[i, ] <- figuras.obtidas
  print(i)
}
resultado <- as.data.frame(resultado)
View(resultado)

# d. Considerando que cada figurinha vale 1 real, qual é o gasto esperado com o álbum?
gastos =  apply(resultado, 1, sum)
mean(gastos)

# e. Qual é a probabilidade de ser necessário gastar pelo menos 7000 Reais para se completar o álbum?
mean(gastos>7000)


# f. Qual é a probabilidade de que, ao completar o álbum, o colecionadar tenha 10 ou mais figurinhas repetidas da
# primeira figurinha do álbum (desconsiderando a que colou no álbum).
mean(resultado[, 1]-1 >= 10)

# g. Para cada jogador, qual foi o número médio de figurinhas obtidas?
map_dbl(resultado, mean)

# h. Qual foi a média global de figurinhas repetidas?
mean(apply(resultado, 1, sum)-980)


# i. Para cada jogador, qual foi o número máximo de figurinhas repetidas pelo processo de simulação? E qual foi o número da figura mais repetida?
map_dbl(resultado, max)
max(map_dbl(resultado, max))
which.max(map_dbl(resultado, max))

# j. Para cada jogador, calcule o número médio de figurinhas obtidas excluindo a observação máxima e  mínima? 
map_dbl(resultado, ~(sum(.)-min(.)-max(.))/(length(.)-2))


# k. Suponha que o fabricante não sorteie as figurinhas aleatoriamente com igual probabilidade. Assuma que
# haja 20 figurinhas “raras” (a probabilidade de cada uma delas ser encontrada em um dado pacote seja 0.0005). 
# Considerando tal hipótese, calcule novamente os itens anteriores).
n.figuras <- 980
n.pacote <- 7
preco <- 7
n.raras <- 100
probabilidade <- c(rep(0.0005, n.raras),  rep((1-0.0005*n.raras)/(n.figuras-n.raras), (n.figuras-n.raras)))
n.simulacoes <- 100

resultado <- matrix(0, nrow = n.simulacoes, ncol= n.figuras)
for(i in 1:n.simulacoes){ 
  faltantes <- n.figuras
  figuras.obtidas <- numeric(n.figuras)
  while(faltantes>0){
    pacote.aux <- sample(1:n.figuras, n.pacote, replace=T, prob = probabilidade)
    pacote.aux <- table(pacote.aux)
    posicoes <- as.numeric(names(pacote.aux))
    figuras.obtidas[posicoes] <- figuras.obtidas[posicoes] + pacote.aux
    faltantes <- sum(figuras.obtidas==0)
  }
  resultado[i, ] <- figuras.obtidas
  print(i)
}

gastos =  apply(resultado, 1, sum)
mean(gastos)
mean(gastos>7000)
mean(resultado[, 1]-1 >= 10)




# l. Considerando que as figurinhas de 182:187 são do time do Brasil, selecione apenas essas figurinhas e faça um boxplot de cada.
# Use par(mfrow=c(3,2)) antes de fazer os gráficos.
brasil = resultado[,182:187]
names(brasil)
par(mfrow=c(3,2))
map(brasil, boxplot)


# m. Coloque rótulo no eixo y dos gráficos anteriores com o número da figurinha
brasil = resultado[,182:187]
nomes = names(brasil)
par(mfrow=c(3,2))
map2(brasil,nomes, ~boxplot(.x, ylab=.y))


# n. Imprima os valores dos outliers de cada boxplot do brasil
map(map(brasil, boxplot), ~.$out)


# DESAFIO! Suponha que o comprador tente trocar todas as figurinhas repetidas 1 vez a cada 5 pacotes de figurinhas adquiridas.
# E a chance de troca com sucesso é de 30% para cada troca. Simule o preenchimento do álbum. 
n.figuras <- 980
n.pacote <- 7
preco <- 7
probabilidade <- rep(1/n.figuras, n.figuras)
n.simulacoes <- 100
n.times <- 5
prob.troca <- 0.3

resultado <- matrix(0, nrow = n.simulacoes, ncol = n.figuras)
for(i in 1:n.simulacoes){ 
  faltantes <- n.figuras
  figuras.obtidas <- numeric(n.figuras)
  while(faltantes > 0){
    pacote.aux <- sample(1:n.figuras, n.pacote * n.times, replace = TRUE, prob = probabilidade)
    pacote.aux <- table(pacote.aux)
    posicoes <- as.numeric(names(pacote.aux))
    figuras.obtidas[posicoes] <- figuras.obtidas[posicoes] + pacote.aux
    faltantes <- sum(figuras.obtidas == 0)
    repetidas <- (figuras.obtidas - 1) > 0
    posicoes.repetidas <- which(repetidas)
    if(length(posicoes.repetidas) > 0){
      posicoes.repetidas.num <- (figuras.obtidas - 1)[posicoes.repetidas]
      repetidas.lista <- rep(posicoes.repetidas,times = posicoes.repetidas.num)
      n.repetidas <- length(repetidas.lista)
      if(n.repetidas > 0 & faltantes > 0){
        sucessos <- sample(c(FALSE, TRUE),n.repetidas,replace = TRUE,prob = c(1 - prob.troca, prob.troca))
        numero.trocas <- min(sum(sucessos), faltantes)
        if(numero.trocas > 0){
          posicao.faltantes <- which(figuras.obtidas == 0)
          posicoes.recebidas <- sample(posicao.faltantes,numero.trocas,replace = FALSE)
          repetidas.sucesso <- repetidas.lista[sucessos]
          posicoes.trocadas <- sample(repetidas.sucesso,numero.trocas,replace = FALSE)
          figuras.obtidas[posicoes.recebidas] <- figuras.obtidas[posicoes.recebidas] + 1
          for(fig in posicoes.trocadas){
            figuras.obtidas[fig] <- figuras.obtidas[fig] - 1
          }
          faltantes <- sum(figuras.obtidas == 0)
        }
      }
    }
  }
  resultado[i, ] <- figuras.obtidas
  print(i)
}

mean(apply(resultado, 1, sum))

