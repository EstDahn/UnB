# --- Script R: Workflow Seguro para Consultar BigQuery ---
# Autor: IA Gemini instruída por dmp
# Data: 22 de outubro de 2025
# Objetivo: Demonstrar um fluxo de trabalho que gera o SQL primeiro,
#           permitindo a estimativa de custo antes da execução, e comparar
#           o comportamento de tabelas particionadas e não particionadas.

# --- 1. Carregar Pacotes ---
library(DBI)
library(bigrquery)
library(dbplyr)
library(tidyverse)
library(basedosdados) # <--- para read_sql()
## Se você não quiser carregar ou instalar o pacote
## basedosdados, você pode substituir o comando pela
## sequência de funções do pacote bigrquery:
## bq_project_query(billing_project_id, query = query) %>%
## bq_table_download(bigint = "integer64")

# --- 2. Configurações Iniciais ---
# Autenticação usando bigrquery::bq_auth()
# (deve ser feita uma vez por sessão, se necessário)
# Pelo e-mail pessoal
# bq_auth(email = "seu-email@google.com")
# Ou para alunos com um arquivo de chave:
bq_auth(path = "gcp-credentials.json")

# Definir seu billing project id para o pacote basedosdados
# Se você usou seu e-mail coloca o id do seu projeto e descomente
# set_billing_id("SEU-ID-DE-PROJETO-AQUI")
# Se você usou uma chave usa meu projeto
set_billing_id("ce2r20251")


# --- 3. Conectar ao BigQuery via DBI (Método Robusto) ---
con <- dbConnect(
  bigrquery::bigquery(),
  project = "basedosdados",
  billing = "ce2r20251"
)
# Conexão via DBI estabelecida.

# Os conjuntos de dados do projeto basedosdados aparecem na aba
# Connections (Conexões). Você pode pegar uma lista dos
# conjuntos de dados (cds) disponíveis neste projeto:
bd_cds_list <- bq_project_datasets("basedosdados", page_size = 200)
bd_cds_chr <- purrr::map_chr(bd_cds_list, "dataset")
head(bd_cds_chr)

# Listar as tabelas disponíveis dentro do conjunto de dados
# "br_ibge_censo_demografico".
# Crie um objeto que representa o conjunto de dados.
bd_cds_censo_dem <- bq_dataset("basedosdados","br_ibge_censo_demografico")
# Consulta as tabelas (tbls) disponíveis nele.
bd_tbls_censo_dem_list <- bq_dataset_tables(bd_cds_censo_dem)
bd_tbls_censo_dem_chr <- purrr::map_chr(bd_tbls_censo_dem_list,
                                        "table")
head(bd_tbls_censo_dem_chr)

# Listar as variáveis (fields/campos) disponíveis na tabela 
# "microdados_domicilio_2010".
# Crie um objeto que representa a tabela.
bd_tbl_dom_2010 <- bq_table("basedosdados", "br_ibge_censo_demografico",
                            "microdados_domicilio_2010")
# Consulta as variáveis nela.
bd_vars_dom_2010_list <- bq_table_fields(bd_tbl_dom_2010)
bd_vars_dom_2010_df <- map_dfr(bd_vars_dom_2010_list, ~ tibble(
  name        = .x$name,
  type        = .x$type,
  mode        = .x$mode,
  description = .x$description
))
head(bd_vars_dom_2010_df)

# --------------------------------------------------------------------------
# --- EXEMPLO 1: Tabela NÃO PARTICIONADA (Censo 2010) ---
# --------------------------------------------------------------------------
# Com tabelas não particionadas, a única forma de reduzir o custo é
# selecionar menos colunas. Filtros (WHERE) não reduzem o custo
# porque o BigQuery precisa ler a tabela inteira para encontrar as linhas.

# --- ETAPA DE CONSTRUÇÃO DA CONSULTA ---
# --- Exemplo 1: Tabela Não Particionada ---
# Construindo a consulta para o Censo 2010 com dbplyr...

consulta_censo_lazy <- tbl(con, 
                           Id(catalog = "basedosdados", 
                              schema = "br_ibge_censo_demografico", 
                              table = "microdados_domicilio_2010")
) #|>
#  filter(sigla_uf == "DF") |>
#  select(id_microrregiao, v2011, v6532)

# --- ETAPA DE VERIFICAÇÃO DE CUSTO ---
# --- SQL Gerado para Verificação de Custo (Censo 2010) ---
show_query(consulta_censo_lazy)
# -----------------------------------------------------------

# Verificação programática com bq_perform_query_dry_run()
# Executando dry run para estimar o custo programaticamente...
query_censo_string <- sql_render(consulta_censo_lazy)
custo_estimado_censo <- bq_perform_query_dry_run(query_censo_string, billing = "ce2r20251")
# Custo estimado para a consulta do Censo (dry run):
print(custo_estimado_censo)


# (Opcional) Você também pode copiar o SQL acima e colar no Editor do BigQuery
# para ver a estimativa de custo na interface web, que é uma boa prática.
# Você verá que o custo estimado é alto (~1.77 GB, sem o select) porque
# a tabela não é particionada.


# --------------------------------------------------------------------------
# --- EXEMPLO 2: Tabela PARTICIONADA (Mortalidade - SIM) ---
# --------------------------------------------------------------------------
# Esta tabela é particionada por 'ano' e 'sigla_uf'.
# Se filtrarmos por essas colunas com o tipo de dado correto,
# o BigQuery lê apenas os dados daquela partição específica.

# --- ETAPA DE CONSTRUÇÃO DA CONSULTA ---
# --- Exemplo 2: Tabela Particionada ---
# Construindo a consulta para Mortalidade (SIM) com dbplyr...

consulta_mortalidade_lazy <- tbl(con, 
                                 Id(catalog = "basedosdados", 
                                    schema = "br_ms_sim", 
                                    table = "microdados")
) |>
  filter(ano == 2001L, sigla_uf == "DF") |>
  select(causa_basica, idade, sexo)

# --- ETAPA DE VERIFICAÇÃO DE CUSTO ---
# --- SQL Gerado para Verificação de Custo (Mortalidade) ---
show_query(consulta_mortalidade_lazy)
# ------------------------------------------------------------

# Verificação programática com bq_perform_query_dry_run()
# Executando dry run para estimar o custo programaticamente...
query_mortalidade_string <- sql_render(consulta_mortalidade_lazy)
custo_estimado_mortalidade <- bq_perform_query_dry_run(query_mortalidade_string, billing = "ce2r20251")
# Custo estimado para a consulta de Mortalidade (dry run):
print(custo_estimado_mortalidade)

# Você verá que o custo estimado é MUITO BAIXO (alguns MBs) porque a consulta usa os filtros de partição.


# --- ETAPA DE EXECUÇÃO (APÓS VERIFICAÇÃO) ---

# Executaremos a consulta de mortalidade, que é barata.
# Executando a consulta de baixo custo (Mortalidade) para baixar os dados...

tryCatch({
  dados_mortalidade_df <- read_sql(query_mortalidade_string)
  
  # Salvar o resultado
  if (!dir.exists("dados_output")) dir.create("dados_output")
  write_csv(dados_mortalidade_df, "dados_output/mortalidade_2001_df.csv")
  
  # Download da consulta de mortalidade concluído com sucesso!
  glimpse(dados_mortalidade_df)
  
  # Quais as causas básicas mais frequentes no DF?
  dados_mortalidade_df |> 
    group_by(causa_basica) |> 
    summarize(mortes = n()) |> 
    arrange(-mortes)
  # CID X959: 'Agressão por meio de disparo de outra arma de fogoou de arma não especificada, local não especificado'")
  
}, error = function(e) {
  message("A execução da consulta foi interrompida ou falhou.")
  message(e$message)
})


# --------------------------------------------------------------------------
# --- DESAFIO EM AULA (se houver tempo) ---
# --------------------------------------------------------------------------
# --- DESAFIO EM AULA ---

# --- Parte 1: Total de Óbitos por UF em 2021 ---
#
# Tarefa: Crie um pipeline dplyr para calcular 
# o número total de óbitos
# para cada estado (sigla_uf) no ano de 2021.
#
# Dicas:
# 1. Comece referenciando a tabela `basedosdados.br_ms_sim.microdados`.
# 2. Filtre para `ano == 2021L`.
# 3. Agrupe por `sigla_uf`.
# 4. Use summarize() para contar as linhas (n()).
# 5. Use o workflow "Look Before You Leap": gere o SQL, estime o custo com 
#    `bq_perform_query_dry_run()`, e só então execute com `read_sql()` se o custo for aceitável.
# 6. Armazene o resultado em um tibble chamado `obitos_por_uf_2021`.

# --- Desafio - Parte 1: Total de óbitos por UF em 2021 ---

# SEU CÓDIGO AQUI

# --- Parte 2: Taxa de Mortalidade por UF em 2021 ---
#
# Tarefa: Calcule a taxa de mortalidade (óbitos por 100.000 habitantes) para cada estado.
#
# Dicas:
# 1. Você precisará da população de 2021 da tabela `basedosdados.br_ibge_populacao.uf`.
# 2. Crie uma consulta separada para obter essa população.
# 3. Use `left_join()` para combinar seu tibble `obitos_por_uf_2021` com os dados de população.
# 4. Use `mutate()` para criar a coluna `taxa_mortalidade`.
# 5. Use `arrange()` para ordenar os resultados.

# --- Desafio - Parte 2: Taxa de mortalidade por UF em 2021 ---

# SEU CÓDIGO AQUI


# --- Fim do Desafio ---


# --- 8. Desconectar ---
dbDisconnect(con)
# Conexão via DBI encerrada.
