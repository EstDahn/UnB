# --- Script de Aula: Análise de Dados de Texto em R ---
# Autor: IA Gemini instruída por dmp
# Data: 2025-07-22
# Objetivo: Demonstrar um fluxo de trabalho para análise de texto em R,
#           desde a extração e limpeza até análises mais avançadas.

# --- 0. Pacotes Necessários ---
# Certifique-se de que os pacotes estão instalados. Se não, rode no Console:
# install.packages(c("tidyverse", "pdftools", "tidytext", "topicmodels"))

# apesar de não ser utilizado explicitamente o pacote 'textdata' deve ser instalado
#install.packages("textdata")

library(tidyverse)
library(pdftools)
library(tidytext)
library(topicmodels)

# --------------------------------------------------------------------------
# --- SEÇÃO INTRODUTÓRIA: Extração, Tokenização e Frequência de Palavras ---
# --------------------------------------------------------------------------
# Objetivo: Mostrar o fluxo de trabalho básico para ler um texto de um PDF,
#           limpá-lo e encontrar as palavras mais comuns.

cat("--- Iniciando Seção Introdutória ---\n")

# -- Passo 1: Extrair Texto do PDF --
# Usamos o pacote `pdftools` para ler o conteúdo textual do nosso arquivo.
# Os alunos devem ter o arquivo PDF na pasta "dados/" do projeto.
pdf_path <- "dados/Projeto Politico Pedagogico do curso de Estatistica - maio 2022.pdf"

if (!file.exists(pdf_path)) {
  stop("Arquivo PDF não encontrado. Por favor, baixe o arquivo e coloque na pasta 'dados'.")
}

texto_ppp <- pdf_text(pdf_path)

# O resultado é um vetor de caracteres, onde cada elemento é o texto de uma página.
cat("Número de páginas extraídas:", length(texto_ppp), "\n")

# -- Passo 2: Tokenização com `tidytext` --
# "Tokenizar" é o processo de dividir o texto em unidades de análise (tokens),
# geralmente palavras. O `tidytext` faz isso de forma organizada.

# Primeiro, colocamos nosso texto em um tibble.
ppp_df <- tibble(pagina = 1:length(texto_ppp), texto = texto_ppp)

# Agora, usamos unnest_tokens() para criar o formato "uma-palavra-por-linha".
ppp_palavras <- ppp_df |>
  unnest_tokens(palavra, texto)

cat("Visualização das palavras (tokens):\n")
print(head(ppp_palavras))


# -- Passo 3: Limpeza - Remover Stopwords --
# Stopwords são palavras muito comuns (e, ou, de, a, o) que não carregam
# muito significado e podem ser removidas para focar nos termos importantes.

# Carregamos a lista de stopwords em português do pacote tidytext
data("stop_words") # A lista original é em inglês
stopwords_pt <- get_stopwords(language = "pt")

# Usamos anti_join() para remover as stopwords
ppp_palavras_limpas <- ppp_palavras |>
  anti_join(stopwords_pt, by = c("palavra" = "word"))

# -- Passo 4: Análise de Frequência --
# Agora podemos simplesmente contar as palavras restantes.
frequencia_palavras <- ppp_palavras_limpas |>
  count(palavra, sort = TRUE)

cat("\nAs 15 palavras mais frequentes no documento:\n")
print(head(frequencia_palavras, 15))


# -- Passo 5: Visualização --
# Um gráfico de barras é uma ótima maneira de visualizar as frequências.
cat("\nGerando gráfico de barras das palavras mais frequentes...\n")
frequencia_palavras |>
  head(20) |>
  mutate(palavra = reorder(palavra, n)) |> # Reordena para o gráfico
  ggplot(aes(x = palavra, y = n)) +
  geom_col(fill = "#2980b9") +
  coord_flip() +
  labs(
    title = "Palavras Mais Frequentes no PPP de Estatística",
    subtitle = "Após remoção de stopwords",
    x = "Palavra",
    y = "Frequência"
  ) +
  theme_minimal()


# --------------------------------------------------------------------------
# --- SEÇÃO INTERMEDIÁRIA: N-grams e Análise de Sentimento ---
# --------------------------------------------------------------------------
# Objetivo: Ir além de palavras únicas para analisar o contexto (n-grams)
#           e a carga emocional do texto.

cat("\n\n--- Iniciando Seção Intermediária ---\n")

# -- Demonstração 1: Análise de Bigramas (Pares de Palavras) --
# Analisar pares de palavras (bigramas) nos ajuda a entender o contexto.
cat("Analisando os bigramas mais comuns...\n")

ppp_bigramas <- ppp_df |>
  unnest_tokens(bigrama, texto, token = "ngrams", n = 2)

# Podemos separar os bigramas em duas colunas para remover stopwords
bigramas_separados <- ppp_bigramas |>
  separate(bigrama, c("palavra1", "palavra2"), sep = " ")

bigramas_filtrados <- bigramas_separados |>
  filter(!palavra1 %in% stopwords_pt$word) |>
  filter(!palavra2 %in% stopwords_pt$word)

# Contar os bigramas mais comuns
contagem_bigramas <- bigramas_filtrados |>
  count(palavra1, palavra2, sort = TRUE)

cat("Os 10 bigramas mais comuns no documento:\n")
print(head(contagem_bigramas, 10))


# -- Demonstração 2: Análise de Sentimento --
# Podemos classificar as palavras de acordo com o sentimento que elas carregam.
cat("\nAnalisando o sentimento do documento...\n")

# Usaremos o léxico "nrc", que classifica palavras em emoções.
# Nota: Este léxico é originalmente em inglês, a tradução pode não ser perfeita
# para o português, mas serve como uma excelente demonstração da técnica.
# Para um projeto real, seria ideal usar um léxico em português.
sentimentos_nrc <- get_sentiments("nrc")

# Juntamos nossas palavras limpas com o léxico de sentimentos
ppp_sentimentos <- ppp_palavras_limpas |>
  inner_join(sentimentos_nrc, by = c("palavra" = "word"),
             relationship = "many-to-many")

# Agora, contamos quantos palavras estão associadas a cada sentimento
contagem_sentimentos <- ppp_sentimentos |>
  count(sentiment, sort = TRUE)

cat("Contagem de palavras por sentimento:\n")
print(contagem_sentimentos)

# E visualizamos o resultado
contagem_sentimentos |>
  ggplot(aes(x = reorder(sentiment, n), y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(
    title = "Análise de Sentimento do PPP de Estatística",
    x = "Sentimento",
    y = "Contagem de Palavras"
  ) +
  theme_minimal()


# --------------------------------------------------------------------------
# --- SEÇÃO AVANÇADA: Modelagem de Tópicos (Topic Modeling) ---
# --------------------------------------------------------------------------
# Objetivo: Usar um modelo de machine learning não supervisionado (LDA) para
#           descobrir os "tópicos" ou temas latentes em uma coleção de documentos.

# NOTA: A modelagem de tópicos funciona melhor com muitos documentos.
# Como temos apenas um (o PPP), usaremos um dataset clássico para demonstração:
# o `AssociatedPress` do pacote `topicmodels`.

cat("\n\n--- Iniciando Seção Avançada ---\n")

# -- Passo 1: Preparar os Dados para LDA --
# O dataset AssociatedPress já está em um formato Document-Term Matrix (DTM).
data("AssociatedPress")
print(AssociatedPress)

# -- Passo 2: Rodar o Modelo LDA --
# Vamos pedir ao modelo para encontrar k=4 tópicos. A escolha de 'k' é uma
# parte importante e muitas vezes iterativa do processo.
lda_model <- LDA(AssociatedPress, k = 5, control = list(seed = 1234))
print(lda_model)

# -- Passo 3: Interpretar os Resultados --
# Queremos saber: quais palavras são mais associadas a cada tópico?
# Usamos broom::tidy() para extrair essa informação.
topicos_palavras <- tidy(lda_model, matrix = "beta")

cat("\nProbabilidade de cada palavra pertencer a cada tópico (beta):\n")
print(topicos_palavras)

# -- Passo 4: Visualizar os Tópicos --
# Para cada tópico, vamos encontrar as 10 palavras com maior probabilidade (beta)
# e visualizar o resultado.
top_termos_por_topico <- topicos_palavras |>
  group_by(topic) |>
  slice_max(beta, n = 10) |>
  ungroup() |>
  arrange(topic, -beta)

# Gráfico
top_termos_por_topico |>
  mutate(term = reorder_within(term, beta, topic)) |>
  ggplot(aes(x = term, y = beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(
    title = "Termos Mais Importantes por Tópico (Modelo LDA)",
    x = "Termo",
    y = "Probabilidade (beta)"
  )

cat("\nFim do script de análise de texto.\n")
