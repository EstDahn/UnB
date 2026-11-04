# --- Script R: R4DS Capítulo 20 - Planilhas ---
# Código extraído do Capítulo 20 de "R para Ciência de Dados" (Tradução PT-BR)
# Autor: IA Gemini instruída por dmp
# Data: 16 de outubro de 2025

# Certifique-se de que os pacotes estão instalados. Se não, rode no console:
# install.packages(c("readxl", "tidyverse", "writexl", "googlesheets4"))

# --- 20.2 Excel ---
# --- 20.2.1 Pré-requisitos ---
library(readxl)
library(tidyverse)
library(writexl)

# --- 20.2.3 Importando arquivos do Excel ---
# Os alunos devem ter o arquivo "estudantes.xlsx" na pasta "dados/"
# O arquivo pode ser baixado de: 
# https://github.com/cienciadedatos/pt-r4ds/raw/traducao-pt-2ed/data/estudantes.xlsx

estudantes_path <- "dados/estudantes.xlsx"

# Verificando se o arquivo existe para evitar erros no script se não for fornecido
if (file.exists(estudantes_path)) {
  cat("Arquivo 'estudantes.xlsx' encontrado.")
} else {
  message("Arquivo '", estudantes_path, "' não encontrado. Não execute os exemplos de 'estudantes.xlsx' ainda.")
}

## Código a ser executado quando o arquivo 'estudantes.xlsx' for
## encontrado.

cat("--- Lendo 'estudantes.xlsx' (Importação inicial) ---\n")
estudantes <- read_excel(estudantes_path)
print(estudantes)

cat("\n--- Importando 'estudantes.xlsx' com nomes de colunas customizados ---\n")
estudantes_col_names <- read_excel(
  estudantes_path,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade")
)
print(estudantes_col_names)

cat("\n--- Importando 'estudantes.xlsx' com nomes de colunas e pulando a primeira linha de dados ---\n")
estudantes_skip <- read_excel(
  estudantes_path,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade"),
  skip = 1
)
print(estudantes_skip)

cat("\n--- Importando 'estudantes.xlsx' especificando strings para NA ---\n")
estudantes_na <- read_excel(
  estudantes_path,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade"),
  skip = 1,
  na = c("", "N/A")
)
print(estudantes_na)

cat("\n--- Importando 'estudantes.xlsx' com tipos de colunas especificados (tentativa com 'idade' como numeric) ---\n")
# Esta parte irá gerar um warning como no R4DS
estudantes_col_types_warn <- read_excel(
  estudantes_path,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "numeric")
)
print(estudantes_col_types_warn)

cat("\n--- Importando 'estudantes.xlsx' com 'idade' como texto e depois convertendo ---\n")
estudantes_processado <- read_excel(
  estudantes_path,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "text") # idade como texto
)

estudantes_processado <- estudantes_processado |>
  mutate(
    idade = if_else(tolower(idade) == "cinco", "5", idade), # Converte "cinco" para "5"
    idade = parse_number(idade) # Converte para numérico
  )
print(estudantes_processado)


# --- 20.2.4 Importando planilhas (sheets) ---
# Os alunos devem ter o arquivo "pinguins.xlsx" na pasta "dados/"
# O arquivo pode ser baixado de:
# https://github.com/cienciadedatos/pt-r4ds/raw/traducao-pt-2ed/data/pinguins.xlsx
pinguins_path <- "dados/pinguins.xlsx"

if (file.exists(pinguins_path)) {
  cat("O arquivo 'pinguins.xlsx' foi encontrado.")
} else {
  message("Arquivo '", pinguins_path, "' não encontrado. Os exemplos de 'pinguins.xlsx' serão pulados.")
}

## Código a ser executado se 'pinguins.xlsx' for encontrado.

cat("\n--- Importando uma aba específica ('Ilha Torgersen') de 'pinguins.xlsx' ---\n")
pinguins_torgersen_sheet <- read_excel(pinguins_path, sheet = "Ilha Torgersen")
# O R4DS mostra "New names: ..." - isso acontece se a primeira linha não for um bom cabeçalho
# ou se houver colunas sem nome. A saída no R4DS é:
# #> New names:
# #> • `` -> `...1`
print(pinguins_torgersen_sheet)

cat("\n--- Importando 'Ilha Torgersen' de 'pinguins.xlsx' com na = 'NA' ---\n")
pinguins_torgersen <- read_excel(pinguins_path, sheet = "Ilha Torgersen", na = "NA")
print(pinguins_torgersen)

cat("\n--- Listando todas as abas em 'pinguins.xlsx' ---\n")
print(excel_sheets(pinguins_path))

cat("\n--- Importando as outras abas e unindo os dados ---\n")
pinguins_biscoe <- read_excel(pinguins_path, sheet = "Ilha Biscoe", na = "NA")
pinguins_dream  <- read_excel(pinguins_path, sheet = "Ilha Dream", na = "NA")

cat("Dimensões de pinguins_torgersen: ", dim(pinguins_torgersen), "\n")
cat("Dimensões de pinguins_biscoe: ", dim(pinguins_biscoe), "\n")
cat("Dimensões de pinguins_dream: ", dim(pinguins_dream), "\n")

pinguins <- bind_rows(pinguins_torgersen, pinguins_biscoe, pinguins_dream)
cat("\n--- Dados dos pinguins combinados ---\n")
print(pinguins)



# --- 20.2.5 Importando parte de uma planilha (range) ---
# Este exemplo usa um arquivo que vem com o pacote readxl
cat("\n--- Importando o arquivo de exemplo 'deaths.xlsx' (inteiro) ---\n")
obitos_caminho <- readxl_example("deaths.xlsx") # Localiza o arquivo de exemplo no pacote

if (!is.null(obitos_caminho) && file.exists(obitos_caminho)) {
  obitos <- read_excel(obitos_caminho)
  # O R4DS mostra "New names: ..."
  print(obitos)
  
  cat("\n--- Importando um intervalo específico ('A5:F15') de 'deaths.xlsx' ---\n")
  obitos_range <- read_excel(obitos_caminho, range = "A5:F15")
  print(obitos_range)
} else {
  message("Arquivo de exemplo 'deaths.xlsx' do pacote readxl não encontrado. Este exemplo será pulado.")
}

# --- 20.2.7 Exportando para Excel ---
cat("\n--- Criando um tibble para exportar ---\n")
doces_vendas <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantidade = c(10, 5, 8)
)
print(doces_vendas)

# Certifique-se de que a pasta "dados/" existe
if (!dir.exists("dados")) {
  dir.create("dados", recursive = TRUE)
  message("Pasta 'dados/' criada.")
}
doces_vendas_path_out <- "dados/doces-vendas.xlsx"

cat("\n--- Exportando o tibble para 'doces-vendas.xlsx' ---\n")
write_xlsx(doces_vendas, path = doces_vendas_path_out)
message("Arquivo '", doces_vendas_path_out, "' salvo.")

cat("\n--- Lendo de volta o arquivo Excel exportado ---\n")
# Verifica se o arquivo foi realmente escrito antes de tentar ler
if (file.exists(doces_vendas_path_out)) {
  doces_relido <- read_excel(doces_vendas_path_out)
  print(doces_relido)
} else {
  message("Arquivo '", doces_vendas_path_out, "' não foi encontrado para releitura.")
}


# --- 20.3 Planilhas Google (Google Sheets) ---
# --- 20.3.1 Pré-requisitos ---
library(googlesheets4)
# library(tidyverse) # Já carregado

# --- 20.3.3 Importando do Planilhas Google ---
# Desautenticar para usar acesso público ou forçar novo login se necessário
gs4_deauth() 

cat("\n--- Importando planilha 'estudantes' do Google Sheets por ID ---\n")
estudantes_planilha_id <- "1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w" # ID da planilha de exemplo R4DS

estudantes_gs <- read_sheet(estudantes_planilha_id)
print(estudantes_gs)

cat("\n--- Importando planilha 'estudantes' com argumentos ---\n")
estudantes_gs_args <- read_sheet(
  estudantes_planilha_id,
  col_names = c("estudante_id", "nome_completo", "comida_favorita", "refeicao_plano", "idade"),
  skip = 1,
  na = c("", "N/A"),
  col_types = "dcccc" # d=double, c=character
)
print(estudantes_gs_args)

cat("\n--- Importando uma aba específica ('Torgersen Island') da planilha 'pinguins' do Google Sheets ---\n")
pinguins_planilha_id <- "1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY" # ID da planilha de pinguins R4DS
pinguins_torgersen_gs <- read_sheet(pinguins_planilha_id, sheet = "Torgersen Island", na = "NA")
print(head(pinguins_torgersen_gs)) # Mostrando apenas o head para brevidade

cat("\n--- Listando nomes das abas da planilha 'pinguins' ---\n")
print(sheet_names(pinguins_planilha_id))

cat("\n--- Importando um intervalo específico da planilha de exemplo 'deaths' do Google Sheets ---\n")
obitos_gs_exemplo_url <- gs4_example("deaths") # Obtém o objeto gs_id para o exemplo
obitos_gs_range <- read_sheet(obitos_gs_exemplo_url, range = "A5:F15")
print(obitos_gs_range)

# --- 20.3.4 Exportando para o Planilhas Google ---
# Estes comandos tentam criar/escrever em Google Sheets e requerem autenticação.
# Podem abrir uma janela do navegador para login.
# Eles não são executados automaticamente aqui para evitar interatividade não desejada no script.
# Para testar, descomente e execute interativamente no RStudio.

gs4_auth() # Tenta autenticar
cat("\n--- Exportando 'doces_vendas' para uma nova Planilha Google chamada 'doces-vendas-r4ds-script' ---\n")
# Usaremos um nome diferente para não colidir com exemplos do livro que possam criar "doces-vendas"
ss_nova <- write_sheet(doces_vendas, ss = "doces-vendas-r4ds-script-exemplo")
message("Planilha criada/escrita: ", ss_nova)

cat("\n--- Exportando 'doces_vendas' para uma aba específica ('VendasAnuais') em uma nova planilha ---\n")
ss_com_aba <- write_sheet(doces_vendas, ss = "doces-vendas-com-aba-r4ds-script-exemplo", sheet = "VendasAnuais")
message("Planilha com aba específica criada/escrita: ", ss_com_aba)

# Lembre-se de que você pode precisar limpar essas planilhas
cat("\n\n--- Fim do Script R4DS Capítulo 20 ---\n")

