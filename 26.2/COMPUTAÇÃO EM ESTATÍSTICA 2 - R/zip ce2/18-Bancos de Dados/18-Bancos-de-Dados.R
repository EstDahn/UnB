# --- Script R: R4DS Capítulo 21 - Bancos de Dados ---
# Código extraído da apresentação Quarto "R4DS Capítulo 21: Bancos de Dados"
# Autor: IA Gemini instruída por dmp
# Data: 04 de junho de 2025 (Data de criação do script)

# --- Slide: 21.1.1 Pré-requisitos ---
# Carregando os pacotes necessários
library(DBI)
library(dbplyr)
library(tidyverse)
library(dados) # Para os datasets de exemplo

# --- Slide: 21.3.1 Neste Livro: Usando `duckdb` ---
# Conexão a um banco de dados duckdb temporário em memória
con <- DBI::dbConnect(duckdb::duckdb())
print(con)

# Conexão a um banco de dados duckdb persistente (exemplo conceitual)
# Em um projeto real, você usaria um caminho de arquivo específico.
# Para este script, o tempdir() é usado para evitar criar arquivos permanentes não intencionais.
db_file_path <- file.path(tempdir(), "meu_banco_r4ds_script.duckdb")
# con_persistente <- DBI::dbConnect(duckdb::duckdb(), dbdir = db_file_path)
# print(con_persistente)
# Nota: Para os exemplos seguintes, usaremos a conexão em memória `con`.

# --- Slide: 21.3.2 Carregando Alguns Dados ---
# Adicionando os datasets `milhas` e `diamante` ao banco de dados em memória
dbWriteTable(con, "milhas", dados::milhas)
dbWriteTable(con, "diamante", dados::diamante)

# --- Slide: 21.3.3 O Básico do DBI ---
# Listando tabelas no banco de dados
print(dbListTables(con))

# Lendo a tabela "diamante" inteira para o R e convertendo para tibble
con |> 
  dbReadTable("diamante") |> 
  as_tibble() |>
  head() |>
  print()

# Executando uma consulta SQL diretamente com dbGetQuery()
sql_exemplo <- "
  SELECT quilate, corte, transparencia, cor, preco 
  FROM diamante 
  WHERE preco > 15000
"
as_tibble(dbGetQuery(con, sql_exemplo)) |> head() |> print()

# --- Slide: 21.4 O Básico do `dbplyr` ---
# Criando um objeto tbl que representa a tabela "diamante" no banco de dados
diamantes_bd <- tbl(con, "diamante")
print(diamantes_bd)

# --- Slide: Avaliação Preguiçosa (Lazy Evaluation) ---
# Operações dplyr em um objeto tbl de banco de dados são "preguiçosas"
grandes_diamantes_bd <- diamantes_bd |> 
  filter(preco > 15000) |> 
  select(quilate:transparencia, preco)
print(grandes_diamantes_bd)

# --- Slide: Vendo o SQL Gerado com `show_query()` ---
grandes_diamantes_bd |>
  show_query()

# --- Slide: Trazendo Dados para o R com `collect()` ---
# collect() executa a consulta e traz os dados para o R como um tibble
grandes_diamantes <- grandes_diamantes_bd |> 
  collect()
print(head(grandes_diamantes))
print(class(grandes_diamantes))

# --- Slide: 21.5 SQL (através do `dbplyr`) ---
# Copiando os datasets `voos` e `avioes` para o banco de dados
dbWriteTable(con, name = "voos", value = dados::voos, overwrite = TRUE)
dbWriteTable(con, name = "avioes", value = dados::avioes, overwrite = TRUE)

# Criando objetos tbl para estas tabelas
voos_bd <- tbl(con, "voos")
avioes_bd <- tbl(con, "avioes")

# --- Slide: 21.5.1 O Básico do SQL ---
# SELECT * FROM tabela
voos_bd |> show_query()
avioes_bd |> show_query()

# --- Slide: `WHERE` e `ORDER BY` ---
voos_bd |> 
  filter(destino == "IAH") |> 
  arrange(atraso_saida) |>
  show_query()

# --- Slide: `GROUP BY` ---
voos_bd |> 
  group_by(destino) |> 
  summarize(atraso_medio_saida = mean(atraso_saida, na.rm = TRUE)) |> 
  show_query()

# --- Slide: 21.5.2 `SELECT` (Cláusula SQL) ---
# Tradução de `select()`, `rename()`, `relocate()`
avioes_bd |> 
  select(codigo_cauda, tipo, fabricante, modelo, ano) |> 
  show_query()

avioes_bd |> 
  select(codigo_cauda, tipo, fabricante, modelo, ano) |> 
  rename(ano_construcao = ano) |> 
  show_query()

avioes_bd |> 
  select(codigo_cauda, tipo, fabricante, modelo, ano) |> 
  relocate(fabricante, modelo, .before = tipo) |> 
  show_query()

# Tradução de `mutate()`
voos_bd |> 
  mutate(
    velocidade = distancia / (tempo_voo / 60)
  ) |> 
  show_query()

# --- Slide: 21.5.4 `GROUP BY` --- (já demonstrado acima)
# Relembrando a tradução de group_by() e summarize()
diamantes_bd |> 
  group_by(corte) |> 
  summarize(
    n = n(),
    avg_price = mean(preco, na.rm = TRUE)
  ) |> 
  show_query()

# --- Slide: 21.5.5 `WHERE` ---
# Tradução de filter() para WHERE
voos_bd |> 
  filter(destino == "IAH" | destino == "HOU") |> 
  show_query()

voos_bd |> 
  filter(atraso_chegada > 0 & atraso_chegada < 20) |> 
  show_query()

# Operador IN
voos_bd |> 
  filter(destino %in% c("IAH", "HOU")) |> 
  show_query()

# --- Slide: `NULL` vs `NA` ---
# Comportamento de NULL em sumarizações SQL
# O warning sobre "Missing values are always removed..." é esperado aqui.
voos_bd |> 
  group_by(destino) |> 
  summarize(atraso = mean(atraso_chegada)) |> # na.rm = TRUE é implicitamente aplicado por muitos SGBDs
  head(3) |> 
  collect() |>
  print()

# Filtrando NULLs (equivalente a !is.na())
voos_bd |> 
  filter(!is.na(atraso_saida)) |> 
  show_query()

# --- Slide: Cláusula `HAVING` ---
# filter() após summarize() traduz para HAVING
diamantes_bd |> 
  group_by(corte) |> 
  summarize(n = n()) |> 
  filter(n > 100) |> 
  show_query()

# --- Slide: 21.5.6 `ORDER BY` ---
# arrange() traduz para ORDER BY
voos_bd |> 
  arrange(ano, mes, dia, desc(atraso_saida)) |> 
  show_query()

# --- Slide: 21.5.7 Subconsultas (Subqueries) ---
# Mutate referenciando coluna recém-criada
voos_bd |> 
  mutate(
    ano1 = ano + 1,
    ano2 = ano1 + 1 
  ) |> 
  show_query()

# Filter referenciando coluna recém-criada
voos_bd |> 
  mutate(ano1 = ano + 1) |> 
  filter(ano1 == 2014) |> 
  show_query()

# --- Slide: 21.5.8 Uniões (Joins) ---
# left_join() e a tradução para LEFT JOIN ... ON ...
# Corrigido para usar "numero_cauda" de voos_bd e "codigo_cauda" de avioes_bd
voos_bd |> 
  left_join(avioes_bd |> rename(ano_construcao = ano), 
            by = c("cauda" = "codigo_cauda")) |> 
  show_query()

# --- Slide: 21.6 Tradução de Funções do R para SQL ---
# Funções de Ajuda (para demonstração)
consulta_summarize <- function(df, ...) {
  df |> 
    summarize(...) |> 
    show_query()
}
consulta_mutate <- function(df, ..., .keep = "none") {
  df |> 
    mutate(..., .keep = .keep) |> 
    show_query()
}

# --- Slide: Funções de Sumarização ---
# O warning sobre .groups é esperado aqui.
voos_bd |> 
  group_by(ano, mes, dia) |>  
  consulta_summarize(
    media = mean(atraso_chegada, na.rm = TRUE),
    mediana = median(atraso_chegada, na.rm = TRUE) 
  )

# --- Slide: Funções de Janela (Window Functions) ---
# Funções de sumarização em mutate() -> funções de janela com OVER
voos_bd |> 
  group_by(ano, mes, dia) |>  
  consulta_mutate(
    media = mean(atraso_chegada, na.rm = TRUE),
    .keep = "used" 
  )

# --- Slide: Funções `lead()` e `lag()` ---
voos_bd |> 
  group_by(destino) |>  
  arrange(ano, mes, dia, horario_saida) |> 
  consulta_mutate(
    lead_atraso = lead(atraso_chegada), 
    lag_atraso = lag(atraso_chegada),   
    .keep = "used"
  )

# --- Slide: `if_else()` e `case_when()` -> `CASE WHEN` ---
voos_bd |> 
  consulta_mutate(
    descricao_atraso = if_else(atraso_chegada > 0, "atrasado", "no horario") 
  )

voos_bd |> 
  consulta_mutate(
    descricao_detalhada = 
      case_when(
        atraso_chegada < -5 ~ "adiantado", 
        atraso_chegada < 5 ~ "no horario",
        atraso_chegada >= 5 ~ "atrasado",
        TRUE ~ "status desconhecido" 
      )
  )

# --- Slide: `cut()` -> `CASE WHEN` ---
voos_bd |> 
  consulta_mutate(
    categoria_atraso =  cut( 
      atraso_chegada, 
      breaks = c(-Inf, -5, 5, Inf), 
      labels = c("adiantado", "no horario", "atrasado")
    )
  )

# --- Desconectar do Banco de Dados ---
# É uma boa prática desconectar do banco de dados quando terminar.
# O argumento shutdown = TRUE é específico para duckdb em memória para liberar recursos.
DBI::dbDisconnect(con, shutdown = TRUE)
if (exists("con_persistente")) { # Se a conexão persistente foi criada
  DBI::dbDisconnect(con_persistente, shutdown = TRUE)
  # Opcional: remover o arquivo de banco de dados temporário se foi criado com tempdir()
   if(file.exists(db_file_path)) {
     unlink(db_file_path, force = TRUE)
     # Tentar remover o diretório se ele estiver vazio (duckdb pode criar arquivos .wal)
     try(unlink(dirname(db_file_path), recursive = FALSE), silent = TRUE)
   }
}

cat("\n\n--- Fim do Script R4DS Capítulo 21 ---\n")
