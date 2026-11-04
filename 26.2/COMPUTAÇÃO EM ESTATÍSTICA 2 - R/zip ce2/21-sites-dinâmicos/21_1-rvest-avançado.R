# --- Script R
# Usando seletores no site atual do IMDB

# 4. Estudo de Caso: IMDb Top 250
library(tidyverse)
library(rvest)

# URL da página
url_imdb <- "https://www.imdb.com/chart/top/"

# O IMDb bloqueia scripts. Precisamos fingir que somos um navegador
# enviando um "User-Agent".
html_imdb <- read_html(url_imdb, 
                       headers = c("User-Agent" = "Mozilla/5.0"))

# 4.1 Extraindo Títulos
# Seletor encontrado usando "Inspecionar Elemento" no navegador:
seletor_titulo <- "h3.ipc-title__text"

titulos_elementos <- html_imdb |> 
  html_elements(seletor_titulo)

titulos_texto <- titulos_elementos |> 
  html_text2()

head(titulos_texto)

## NÃO NECESSÁRIO
# # Filtramos apenas os títulos que começam com "número."
# titulos_limpos <- titulos_texto |> 
#   str_subset("^\\d+\\. ") # Regex: ^ (início) \d+ (dígito) \. (ponto)

# head(titulos_limpos)

# 4.2 Extraindo Notas
seletor_nota <- "span.ipc-rating-star.ipc-rating-star--base"

notas_elementos <- html_imdb |> 
  html_elements(seletor_nota)

notas_texto <- notas_elementos |> 
  html_text2()

head(notas_texto)

# Limpamos o texto para pegar só a nota
notas_limpas <- notas_texto |> 
  str_extract("^\\d\\.\\d") |>  # Regex: Pega "dígito.dígito" do início
  as.numeric()

head(notas_limpas)

