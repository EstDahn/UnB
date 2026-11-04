# --- Script R: R4DS Capítulo 07 - Problemas de Análise Sintática ---
# Foco no Exemplo de Valores Ausentes Não Padrão (R4DS 7.3.2)
# Código extraído da apresentação Quarto correspondente.
# Autor: IA Gemini instruída por dmp
# Data: 02 de junho de 2025 (Data da criação deste script)

# --- Carregar Pacotes Necessários ---
# Certifique-se de que o tidyverse está instalado:
# install.packages("tidyverse")
library(tidyverse) # readr é parte do tidyverse

# --- Slide: Exemplo (Baseado em R4DS 7.3.2): Valores Ausentes e Tipos de Coluna ---
# Configuração da string CSV de exemplo.
# Para que read_csv interprete "x" como cabeçalho e as linhas subsequentes como dados,
# precisamos de quebras de linha (\n) na string.
simple_csv_string <- "x\n10\n.\n20\n30"

# Tentativa inicial de leitura:
# 'x' se torna uma coluna de caracteres porque o '.' não é reconhecido 
# como número nem como o NA padrão.
cat("--- Leitura inicial de 'simple_csv_string' ---\n")
print(read_csv(simple_csv_string))


# --- Slide: Diagnosticando com `col_types` e `problems()` ---
# Forçando a coluna 'x' a ser numérica (double) para ver os problemas.
cat("\n--- Forçando 'x' para col_double() e verificando problemas ---\n")
df <- read_csv(
  simple_csv_string, 
  col_types = list(x = col_double()) # ou col_types = cols(x = col_double())
)
# O comando acima gera um warning sobre problemas de parsing.

# Usando problems() para detalhar os erros.
cat("Problemas reportados por readr:\n")
print(problems(df))
# Isso deve mostrar que na linha 3, coluna 'x', esperava-se 'a double' mas encontrou-se '.'.

# --- Slide: Corrigindo com o Argumento `na` ---
# Definindo '.' como um marcador de valor ausente (NA).
cat("\n--- Corrigindo a leitura com na = '.' ---\n")
print(read_csv(simple_csv_string, na = "."))

# Especificando o tipo E o 'na' explicitamente:
cat("\n--- Corrigindo com na = '.' e col_types explicitamente ---\n")
dados_corrigidos <- read_csv(
  simple_csv_string, 
  na = ".",
  col_types = list(x = col_double()) # ou cols(x = col_double())
)
print(dados_corrigidos)
cat("Problemas após correção (deve ser um tibble vazio):\n")
print(problems(dados_corrigidos)) # Nenhum problema de parsing reportado agora

# --- Slide: Estratégias Comuns para Corrigir Problemas de Parsing ---
# (Estes são exemplos de sintaxe, requerem um 'arquivo' real para rodar)

# Aumentar guess_max (se as primeiras 1000 linhas não são representativas):
# Suponha que 'meu_arquivo.csv' é o nome do seu arquivo
# read_csv("caminho/para/meu_arquivo.csv", guess_max = 5000)

# Ler todas as colunas como caractere para inspeção e conversão manual:
# read_csv("caminho/para/meu_arquivo.csv", col_types = cols(.default = col_character()))
# Depois, você usaria parse_*() functions:
# dados_char <- read_csv("caminho/para/meu_arquivo.csv", col_types = cols(.default = col_character()))
# dados_convertidos <- dados_char %>%
#   mutate(
#     coluna_numerica = parse_double(nome_da_coluna_numerica_lida_como_char),
#     outra_coluna = parse_integer(nome_de_outra_coluna_lida_como_char)
#     # etc.
#   )

cat("\nLembre-se de inspecionar seus dados após a importação com glimpse(), head(), summary()\n")
cat("e prestar atenção aos warnings do readr.\n")

# --- Fim do Script ---
