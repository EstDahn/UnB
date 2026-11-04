# --- Script de Código R dos Slides de "Tipos de Dados com stringr" ---
# Fonte: Extraído de 12-Types-Slides-stringr.pdf (até a página 39)
# Nota: Slide com solução (página 20) foi excluído.

# --- Dependências ---
# Carrega o tidyverse (inclui dplyr, ggplot2, stringr)
library(tidyverse) 

# Carrega outros pacotes mencionados
# install.packages("babynames") # Rode uma vez se necessário
library(babynames) 
# install.packages("nycflights13") # Rode uma vez se necessário
library(nycflights13) 

# --- Página 6 ---
TRUE
typeof(TRUE)
typeof(c(TRUE, TRUE, FALSE))

# --- Página 9 ---
# Pressupõe que os dados 'flights' do nycflights13 estão carregados
flights %>%
  mutate(delayed = arr_delay > 0) %>%
  select(arr_delay, delayed)

# --- Página 12 & 13 ---
TRUE + 0

# --- Página 15 ---
sum(c(FALSE, FALSE, TRUE, FALSE))

# --- Página 16 ---

# --- Página 17 ---

# --- Página 19 ---
# Sua Vez 1 - Código a ser completado pelos alunos
# (Solução executável da Página 20 foi excluída)

# --- Página 20 ---
# (Solução Excluída)

# --- Página 22 ---
"um"
typeof("um")
# typeof("ops. Estou preso em uma string) # Exemplo de string não terminada
# + ")

# --- Página 24 ---
# library(babynames) # Já carregado acima

# --- Página 27 ---
# library(tidyverse) # Já carregado acima

# --- Página 29 & 30 ---
str_sub("Garrett", 1, 2)

# --- Página 31 & 32 ---
str_sub("Garrett", 1, 1)

# --- Página 33 & 34 ---
str_sub("Garrett", 2)

# --- Página 35 & 36 ---
str_sub("Garrett", -3)

# --- Página 37 & 38 ---
g <- "Garrett"
str_sub(g, -3) <- "eth" 
g

# --- Página 39 ---
# Sua Vez 2 - Código a ser completado pelos alunos
# (Solução executável da Página 40 foi excluída, pois dados da página 40+ não estavam disponíveis)

# --- Fim do Script ---
