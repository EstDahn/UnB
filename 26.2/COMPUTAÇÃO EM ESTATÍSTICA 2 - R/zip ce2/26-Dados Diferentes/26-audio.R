# --- Script de Aula: Análise de Dados de Áudio em R ---
# Autor: IA Gemini instruída por dmp
# Data: 2025-07-22
# Objetivo: Demonstrar um fluxo de trabalho para análise de áudio em R,
#           desde a leitura e visualização até análises mais avançadas.

# --- 0. Pacotes Necessários ---
# Certifique-se de que os pacotes estão instalados. Se não, rode no Console:
# install.packages(c("tidyverse", "tuneR", "seewave", "av", "googleLanguageR"))

library(tidyverse)
library(tuneR)     # O pacote clássico para ler e manipular arquivos .wav
library(seewave)   # Um pacote completo para visualização e análise de som
library(av)        # Para conversão de áudio (usado na seção avançada)
library(googleLanguageR) # Para speech-to-text (usado na seção avançada)

# --- Preparação ---
# Para este script, assumimos que você tem um arquivo de áudio chamado
# "estatistica_ciencia.wav" salvo em uma pasta "dados" no seu projeto.
audio_path <- "dados/estatistica_ciencia.wav"
# ou o arquivo "rouxinal.wav"
# audio_path <- "dados/rouxinal.wav"
# ou o arquivo "variando.wav"
# audio_path <- "dados/variando.wav"
# ou o arquivo "escala.wav"
# audio_path <- "dados/escala.wav"

if (!file.exists(audio_path)) {
  stop("Arquivo de áudio não encontrado. Por favor, grave o seu áudio, salve como 'estatistica_ciencia.wav' e coloque na pasta 'dados'.")
}

# --------------------------------------------------------------------------
# --- SEÇÃO INTRODUTÓRIA: Lendo e Visualizando Áudio ---
# --------------------------------------------------------------------------
# Objetivo: Ler um arquivo de áudio e criar as duas visualizações mais
#           fundamentais: a forma de onda (waveform) e o espectrograma.

cat("--- Iniciando Seção Introdutória ---\n")

# -- Passo 1: Ler o Arquivo de Áudio --
# Usamos a função readWave() do pacote tuneR para ler o arquivo .wav.
som <- readWave(audio_path)

# -- Passo 2: Inspecionar o Objeto de Áudio --
# Imprimir o objeto nos dá metadados importantes.
cat("Informações sobre o arquivo de áudio:\n")
print(som)
cat("---------------------------------------\n")
cat("Canais (Channels):", som@stereo, "\n") # FALSE = mono, TRUE = stereo
cat("Taxa de Amostragem (Sampling Rate):", som@samp.rate, "Hz\n")
cat("Profundidade de Bits (Bit Depth):", som@bit, "bit\n")
cat("Duração:", length(som@left) / som@samp.rate, "segundos\n")

# -- Passo 3: Visualizar a Forma de Onda (Waveform) --
# Esta é a visualização mais simples: Amplitude vs. Tempo.
cat("\nGerando gráfico da forma de onda...\n")
plot(som, main = "Forma de Onda (Amplitude vs. Tempo)")


# -- Passo 4: Visualizar o Espectrograma --
# Esta é uma visualização muito mais rica, mostrando a intensidade (cor)
# das diferentes frequências (eixo y) ao longo do tempo (eixo x).
cat("\nGerando espectrograma...\n")
spectro(som, main = "Espectrograma (Frequência vs. Tempo)", flim = 0:10)


# --------------------------------------------------------------------------
# --- SEÇÃO INTERMEDIÁRIA: Análise Quantitativa de Áudio ---
# --------------------------------------------------------------------------
# Objetivo: Extrair características numéricas do sinal de áudio, como o tom
#           (pitch) e filtrar o som.

cat("\n\n--- Iniciando Seção Intermediária ---\n")

# -- Demonstração 1: Rastreamento do Tom (Pitch Tracking) --
# A frequência fundamental (f0) corresponde à nossa percepção do tom de um som.
# A função fund() do seewave pode estimar essa frequência ao longo do tempo.
cat("Rastreando a frequência fundamental (pitch)...\n")

# 'fmax' é definido para focar nas frequências típicas da voz humana.
pitch_contour <- fund(som, fmax = 400, plot = FALSE, # plot=FALSE para não gerar o gráfico padrão
                      threshold = 1) # threshold to require a steady tone for identfication

# Agora, podemos plotar o contorno do tom com ggplot2
pitch_df <- as.data.frame(pitch_contour)
ggplot(pitch_df, aes(x = x, y = y)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Contorno do Tom (Pitch) da Locução",
    x = "Tempo (s)",
    y = "Frequência Fundamental (Hz)"
  ) +
  geom_smooth(method = "loess", span=0.1) +
  theme_minimal()


# -- Demonstração 2: Filtrando o Áudio --
# Podemos manipular o áudio, por exemplo, removendo certas frequências.
# Vamos aplicar um filtro "passa-baixa" (low-pass), que remove as frequências altas.

# Filtra o som, mantendo apenas as frequências abaixo de 1500 Hz.
som_filtrado <- ffilter(som, from = 0, to = 1500, output = "Wave")
cat("\nÁudio filtrado (apenas frequências baixas). Gerando novo espectrograma...\n")
spectro(som_filtrado, main = "Espectrograma do Áudio Filtrado (Low-pass)", flim = 0:10)

# Para ouvir a diferença, você pode salvar o arquivo filtrado.
savewav(som_filtrado, filename = "dados/som_filtrado.wav")


# --------------------------------------------------------------------------
# --- SEÇÃO AVANÇADA: Reconhecimento de Fala (Speech-to-Text) ---
# --------------------------------------------------------------------------
# Objetivo: Usar uma API na nuvem para converter o áudio de fala em texto.
# NOTA: Esta seção requer configuração de uma conta Google Cloud, similar
#       ao que fizemos para o basedosdados. É um tópico avançado.

cat("\n\n--- Iniciando Seção Avançada ---\n")

# -- Passo 1: Preparar o Áudio para a API --
# A API do Google Speech-to-Text funciona melhor com o formato de áudio FLAC.
# Usaremos o pacote 'av' para fazer a conversão.
audio_flac_path <- "dados/estatistica_ciencia.flac"

audio_path <- "dados/som_filtrado.wav"

av_audio_convert(
  audio = audio_path,
  output = audio_flac_path,
  format = "flac",
  sample_rate = 16000, # A API prefere taxas de amostragem de 16000 Hz
  channels = 1
)
cat("Arquivo de áudio convertido para o formato FLAC em:", audio_flac_path, "\n")


# -- Passo 2: Autenticação e Chamada da API --
# Esta parte requer que o pacote 'googleLanguageR' esteja instalado e que a
# autenticação com o Google Cloud esteja configurada.
# library(googleLanguageR)
gl_auth("caminho/para/sua/chave.json") # Autenticação via chave de serviço

cat("\nEnviando áudio para a API do Google Speech-to-Text (exemplo conceitual)...\n")

# O código abaixo é como a chamada seria feita.
# Ele está comentado para não dar erro sem a devida autenticação.
#
# tryCatch({
  resultado_texto <- gl_speech(
    audio_flac_path,
    languageCode = "pt-BR", # Especifica o idioma,
    encoding = "FLAC"
  )$transcript

  cat("\n--- Texto Transcrito pela API ---\n")
  print(resultado_texto)

# }, error = function(e) {
#   message("A chamada para a API do Google falhou. Verifique sua autenticação.")
# })


cat("\nFim do script de análise de áudio.\n")
