## códigos rvest de R4DS
library(tidyverse)
library(rvest)

html <- read_html("http://rvest.tidyverse.org/")
html

html <- minimal_html("
  <p>This is a paragraph</p>
  <ul>
    <li>This is a bulleted list</li>
  </ul>
")
html

##CSS selecionadores
html <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")

html |> html_elements("p")

html |> html_elements(".important")

html |> html_elements("#first")

html |> html_element("p")

html |> html_elements("b")
html |> html_element("b")

html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ")

characters <- html |> html_elements("li")
characters

characters |> html_element("b")

characters |> html_element(".weight")

# assim perde a conexão entre personagens e pesos
characters |> html_elements(".weight")


# html_text2
characters |> 
  html_element("b") |> 
  html_text2()


characters |> 
  html_element(".weight") |> 
  html_text2()

# html_attr
html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")

html |> 
  html_elements("p") |> 
  html_element("a") |> 
  html_attr("href")

## Dados em tabelas
html <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
  ")

html |> 
  html_element(".mytable") |> 
  html_table()

## Como achar o selecionador adequado?


# Selector Gadget pode ajudar (ver links em R4DS)

# Usar ferramentas de desenvolvidores do seu navegador
# Recomenda Chrome - Inspect
# Presta atenção a 'class' e 'id'
# Com botão direito em cima de um elemento,
# pode escolher "Copy as Selector"
# Veja as indicações no final de 24.5 para
# entender Selectors.

## 24.6
vignette("starwars")
# Usa Inspect Element para ver a estrutura.

url <- "https://rvest.tidyverse.org/articles/starwars.html"
html <- read_html(url)

section <- html |> html_elements("section")
section

# Títulos
section |> html_element("h2") |> html_text2()

# Diretores
section |> html_element(".director") |> html_text2()

# Tudo num tibble
tibble(
  title = section |> 
    html_element("h2") |> 
    html_text2(),
  released = section |> 
    html_element("p") |> 
    html_text2() |> 
    str_remove("Released: ") |> 
    parse_date(),
  director = section |> 
    html_element(".director") |> 
    html_text2(),
  intro = section |> 
    html_element(".crawl") |> 
    html_text2()
)

## IMDB top 250 filmes
# usaremos uma versão arquivada
# a página parece tabular, então tentará html_table
url <- "https://web.archive.org/web/20220201012049/https://www.imdb.com/chart/top/"
html <- read_html(url)

tabela <- html |> 
  html_element("table") |> 
  html_table()
tabela

# limpando
ratings <- tabela |>
  select(
    rank_title_year = `Rank & Title`,
    rating = `IMDb Rating`
  ) |> 
  mutate(
    rank_title_year = str_replace_all(rank_title_year, "\n +", " ")
  ) |> 
  separate_wider_regex(
    rank_title_year,
    patterns = c(
      rank = "\\d+", "\\. ",
      title = ".+", " +\\(",
      year = "\\d+", "\\)"
    )
  )
ratings

# Tem mais informação nos atributos do html
html |> 
  html_elements("td strong") |> 
  head() |> 
  html_attr("title")

ratings |>
  mutate(
    rating_n = html |> html_elements("td strong") |> html_attr("title")
  ) |> 
  separate_wider_regex(
    rating_n,
    patterns = c(
      "[0-9.]+ based on ",
      number = "[0-9,]+",
      " user ratings"
    )
  ) |> 
  mutate(
    number = parse_number(number)
  )

## 24.7 Sites dinâmicos
# Não tem no livro, mas já tem o pacote 'chromote' que roda Chrome
# para acessar os dados dinâmicos.
help(package="chromote")

library(chromote)

b <- ChromoteSession$new()

# In a web browser, open a viewer for the headless browser. Works best with
# Chromium-based browsers.
b$view()
b$go_to("https://www.r-project.org/")


?read_html_live
sess <- read_html_live("https://www.forbes.com/top-colleges/")
sess$view()
rows <- sess %>% html_elements(".ListTable_tableRow__P838D")
rows
# nomes e posto .ListTable_boldCol__kzBQN
rows %>% html_elements(".ListTable_boldCol__kzBQN") %>% html_text()
# outros dados .ListTable_tableData__-55i8
rows %>% html_elements(".ListTable_tableData__-55i8") %>% html_text()

# para pegar a tabela toda, precisamos extrair o corpo dele
# 
sess %>% html_elements("tbody") %>% html_table()
