# --- Script R (Aula 1): A Mecânica do rvest (Corrigido) ---
# Este script acompanha o 23-Web-Scraping-Aula-1.qmd
# Ele usa o ficheiro local "starwars.html"

# 1. Pré-requisitos
# install.packages("tidyverse")
# install.packages("rvest")
library(tidyverse)
library(rvest)

# 3.1 Ler HTML
html <- read_html("https://rvest.tidyverse.org/articles/starwars.html")
html

# 3.2 Selecionar Nós com html_elements()
# O seletor "h2" é muito genérico e captura "On this page"
titulos_elementos_ruim <- html |> 
  html_elements("h2")
titulos_elementos_ruim |> html_text2()

# 3.3 Extrair Texto (Forma Correta)
# O seletor "h2[data-id]" é mais específico
seletor_titulo_correto <- "h2[data-id]"
titulos_elementos <- html |> 
  html_elements(seletor_titulo_correto)

titulos_texto <- titulos_elementos |> 
  html_text2()

titulos_texto

# 4. Estudo de Caso: Filmes Star Wars
# 4.1 Títulos
titulos <- html |> 
  html_elements("h2[data-id]") |> 
  html_text2()

titulos

# 4.2 Datas e Diretores
# O seletor "section > p" pega os <p> de data e diretor,
# mas ignora o <p> do "crawl" (que está dentro de um <div>)
paragrafos_texto <- html |> 
  html_elements("section > p") |> 
  html_text2()

paragrafos_texto

# 4.2.2 Separar Datas e Diretores
# Usamos stringr para filtrar o vetor de texto

# Filtrar apenas as datas e limpar
datas <- paragrafos_texto |> 
  str_subset("^Released: ") |> 
  str_remove("Released: ") |> 
  str_trim()

datas

# Filtrar apenas os diretores e limpar
diretores <- paragrafos_texto |> 
  str_subset("^Director: ") |> 
  str_remove("Director: ") |> 
  str_trim()

diretores

# 4.3 Juntar Tudo num Tibble
star_wars_df <- tibble(
  titulo = titulos,
  diretor = diretores,
  data_lancamento = as.Date(datas)
)

star_wars_df

