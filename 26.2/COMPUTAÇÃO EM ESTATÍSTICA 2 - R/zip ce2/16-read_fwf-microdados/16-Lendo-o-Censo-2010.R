# --- Script R: Lendo Microdados do IBGE (Método Manual) ---
# Código extraído da apresentação Quarto "Lendo Microdados do IBGE: O Método Manual (Censo 2010)"
# Autor: IA Gemini instruída por dmp
# Data: 12 de junho de 2025

# --- Carregando Pacotes Necessários ---
# Certifique-se de que os pacotes estão instalados. Se não, rode no Console:
# install.packages("readxl")
# install.packages("tidyverse")

library(readxl)
library(tidyverse)


# --- Slide 2: Download e Descompactação ---
# Esta etapa deve ser feita manualmente pelos alunos antes de rodar este script.
# 1. Baixar os arquivos .zip de dados e de documentação do FTP do IBGE.
# 2. Descompactar os arquivos.
# 3. Organizar os arquivos nas pastas do projeto, garantindo que os seguintes caminhos sejam válidos:
#    - "Documentacao/Layout/Layout_microdados_Amostra.xls"
#    - "dados/DF/Amostra_Domicilios_53.txt"
qmd_path <- "19-Microdados/"

# --- Slide 3: Entendendo o Dicionário (Layout) ---
# Ler o arquivo de layout (dicionário) e selecionar as colunas de interesse.

# Caminho para o arquivo de layout
layout_path <- paste0(qmd_path,"Documentacao/Layout/Layout_microdados_Amostra.xls")

# Ler a aba "DOMI", pulando a primeira linha que é um título mesclado
if (file.exists(layout_path)) {
  layout_domicilios_raw <- read_excel(layout_path, sheet = "DOMI", skip = 1)
  
  # Selecionar e renomear as colunas de interesse para facilitar o uso
  layout_domicilios <- layout_domicilios_raw |>
    select(
      VAR, 
      NOME,
      INICIO = `POSIÇÃO INICIAL`,
      FIM = `POSIÇÃO FINAL`,
      INT, 
      DEC,
      TIPO
    )
  
  cat("--- Dicionário de Layout (DOMI) Carregado e Limpo ---\n")
  glimpse(layout_domicilios)
  
} else {
  stop("Arquivo de layout não encontrado em: '", layout_path, "'. Por favor, complete a etapa de download e organização dos arquivos.")
}


# --- Slide 4: Preparando para a Leitura FWF ---
# Usar o dicionário para criar os argumentos para a função read_fwf().

# Nomes das colunas vêm da coluna 'VAR' do layout
col_names <- layout_domicilios$VAR

# Posições das colunas (início e fim)
col_positions <- readr::fwf_positions(
  start = layout_domicilios$INICIO,
  end = layout_domicilios$FIM,
  col_names = col_names
)

cat("\n--- Nomes das primeiras 10 colunas para importação ---\n")
print(head(col_names, 10))

cat("\n--- Posições das primeiras 5 colunas para importação ---\n")
print(head(col_positions))


# --- Slide 5: Lendo o Arquivo de Largura Fixa (FWF) ---
# Ler os microdados brutos usando as especificações criadas.

# Caminho para o arquivo de dados dos domicílios
dados_path <- paste0(qmd_path,"dados/DF/Amostra_Domicilios_53.txt")

if (file.exists(dados_path)) {
  # Ler o arquivo usando read_fwf com as posições e nomes que definimos
  domicilios_raw <- read_fwf(
    dados_path,
    col_positions = col_positions,
    col_types = cols(.default = "c") # Ler tudo como caractere inicialmente
  )
  
  cat("\n--- Dados Brutos Importados ---\n")
  cat("Dimensões dos dados brutos importados:", dim(domicilios_raw), "\n")
  cat("Visualização dos dados brutos (primeiras linhas e colunas):\n")
  glimpse(domicilios_raw |> select(1:6))
  
} else {
  stop("Arquivo de dados não encontrado em: '", dados_path, "'. Por favor, complete a etapa de download e organização dos arquivos.")
}


# --- Slide 6.1: Corrigindo Variáveis Numéricas ---
# Converter colunas numéricas e ajustar valores com base nas casas decimais.

if (exists("domicilios_raw") && nrow(domicilios_raw) > 0) {
  # Identificar variáveis numéricas (aquelas com TIPO == 'N')
  vars_numericas <- layout_domicilios |>
    filter(TIPO == 'N') |>
    pull(VAR) # Puxa apenas a coluna VAR como um vetor
  
  domicilios_proc <- domicilios_raw |>
    mutate(across(all_of(vars_numericas), as.numeric)) # Converte para numérico
  
  # Agora, aplicar a divisão decimal para cada variável que precisa
  for (var in vars_numericas) {
    decimais <- layout_domicilios |> filter(VAR == var) |> pull(DEC)
    if (!is.na(decimais) && decimais > 0) {
      domicilios_proc <- domicilios_proc |>
        mutate(!!sym(var) := .data[[var]] / (10^decimais))
    }
  }
  
  cat("\n--- Pós-processamento de Variáveis Numéricas ---\n")
  cat("Exemplo de variável numérica corrigida (V2011 - Valor do Aluguel (em Reais)):\n")
  print(summary(domicilios_proc$V2011))
}


# --- Slide 6.2: Criando Fatores (Factors) ---
# Converter variáveis categóricas em fatores com rótulos apropriados.

# --- Slide 6.2: Criando Fatores (Factors) - Alternative with forcats ---

if (exists("domicilios_proc") && nrow(domicilios_proc) > 0) {
  
  # --- Step 1: Parsear as informações de rótulos do layout (sem alterações) ---
  rotulos_df <- layout_domicilios |>
    filter((TIPO == 'C' | VAR == 'V0001') & !is.na(NOME)) |>
    select(VAR, NOME) |>
    separate_longer_delim(NOME, delim = "\n") |>
    filter(str_detect(NOME, regex("^\\s*\\d+\\s*-"))) |>
    extract(
      col = NOME,
      into = c("codigo", "rotulo"),
      regex = "^\\s*(\\d+)\\s*-\\s*(.*)$",
      remove = FALSE
    ) |>
    mutate(rotulo = trimws(rotulo))
  
  # --- Steps 2 & 3: Loop para Recodificar com fct_recode() ---
  
  # Obter a lista de variáveis categóricas que vamos converter
  vars_para_converter <- unique(rotulos_df$VAR)
  
  # Começar com os dados processados numericamente
  domicilios_final <- domicilios_proc
  
  # Loop através de cada variável que precisa ser recodificada
  for (variavel_atual in vars_para_converter) {
    
    # Filtrar o dataframe de rótulos para obter as regras apenas para a variável atual
    regras_recodificacao <- rotulos_df |>
      filter(VAR == variavel_atual)
    
    # Criar um vetor nomeado para o fct_recode().
    # O formato é: c("novo_nome1" = "codigo_antigo1", "novo_nome2" = "codigo_antigo2", ...)
    # A função setNames() faz isso de forma eficiente.
    mapa_recodificacao <- setNames(regras_recodificacao$codigo, regras_recodificacao$rotulo)
    
    # Imprimir o mapa para uma variável para fins de ensino (opcional)
    if (variavel_atual == "V0001") {
      cat("Mapa de recodificação para V0001 (Unidade da Federação):\n")
      print(mapa_recodificacao)
    }
    
    # Aplicar a recodificação à coluna correspondente no dataframe principal
    domicilios_final <- domicilios_final |>
      mutate(
        # Usamos !!sym(variavel_atual) para dizer ao mutate para usar
        # o *valor* da string 'variavel_atual' como um nome de coluna
        !!sym(variavel_atual) := fct_recode(!!sym(variavel_atual), !!!mapa_recodificacao)
      )
  }
  
  cat("\nExemplo de variável convertida para fator (V0001 - Unidade da Federação):\n")
  print(table(domicilios_final$V0001))
}  

cat("\n--- Visualização Final dos Dados Processados ---\n")
glimpse(domicilios_final |> select(all_of(c("V0001", "V0201", "V2011"))))


# --- Fim do Script ---
