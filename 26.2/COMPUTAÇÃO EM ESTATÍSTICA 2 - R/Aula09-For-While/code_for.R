###################################################
## Cálculos iterativos e criação de Funções no R ##
###################################################
library(tidyverse)

### For loops
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

median(df$a)
median(df$b)
median(df$c)
median(df$d)


# Comments: 
### 1. Before you start the loop, you must always allocate 
### sufficient space for the output

### 2. The sequence: 1:length(df) is the same as seq_along(df)

### 3. The body 
output <- numeric(ncol(df))          # 1. output
for (i in 1:length(df)) {            # 2. sequence
  output[i] <- median(unlist(df[,i])) 
  # output[i] <- median(df[[i]])   # 3. body
}
output


1:length(df)
seq_along(df)
seq(1, length(df), 2)


output <- numeric(ncol(df))           # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[i] <- median(df[[i]])        # 3. body
}
output


output[1] <- median(df[[1]])
output[2] <- median(df[[2]])
output[3] <- median(df[[3]])
output[4] <- median(df[[4]])


# outro exemplo: contadores diferentes
rescale <- function (x, remove.na = F){
  (x - min(x, na.rm = remove.na)) / diff(range(x, na.rm = remove.na))
}


sequencia <- seq(2, ncol(df), by=2 )
output <- as.data.frame(matrix(NA, nrow= nrow(df), ncol= length(sequencia) ))
j <- 1
for (i in sequencia) {
  output[,j] <- rescale(df[,i]) 
  j <- j +1
}
output



###############################################
###Estimando a área de um círculo de raio r ###
###############################################

### Implementação 1: Código R para o cálculo iterativo da área de um círculo de raio r.
n.pontos <- 10000  # Número de pontos simulados
r <- 1  # Raio do círculo
x <- y <- numeric(n.pontos)
dentro <- logical(n.pontos)
for(i in 1:n.pontos) {
  x[i] <- runif(1, -r, r)  # Coordenada do i-ésimo ponto simulado
  y[i] <- runif(1, -r, r)  # Ordenada do i-ésimo ponto simulado
  dentro[i] <- x[i]^2 + y[i]^2 < r^2  # Variável indicadora: o ponto está dentro do círculo?
}

(2*r)^2*mean(dentro)
pi*r^2


### Implementação 2: Código R para o cálculo vetorizado da área de um círculo de raio r.
n.pontos <- 100  # Número de pontos simulados
r <- 1 # Raio do círculo
x <- runif(n.pontos, -r, r)  # Coordenada do i-ésimo ponto simulado
y <- runif(n.pontos, -r, r)  # Ordenada do i-ésimo ponto simulado
dentro <- x^2 + y^2 < r^2  # Variável indicadora: o ponto está dentro do círculo?
dados <- data.frame(x=x, y=y, Dentro=dentro)

(2*r)^2*mean(dados$Dentro)
pi*r^2


### Plot
ggplot() +
  coord_cartesian(xlim = c(-r, r), ylim = c(-r, r), expand = F) +
  coord_fixed() + 
  geom_point(aes(x=x, y=y), dados, color=as.numeric(dentro)+1, show.legend=T)



## Exercício
#### Crie uma função R para calcular a área de um círculo 
#### de raio r via simulação estocástica.
### Inputs da função:
# raio: valor numerico não-negativo com o raio do círculo
# n.pontos: número de pontos simulados usados para a a aproximação numérica.
# semente: Valor numérico indicando a semente do gerador de números aleatórios.
# retornar.dados: Valor lógico indicando se a matriz de dados deve ser retornada.
# grafico: Valor lógico indicando se o gráfico deve ser retornado.
### Inclua mensagem de aviso no começo da função
