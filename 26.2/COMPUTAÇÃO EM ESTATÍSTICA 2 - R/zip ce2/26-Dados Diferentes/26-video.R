# --- Script de Aula: Análise de Dados de Vídeo em R ---
# Autor: IA Gemini instruída por dmp
# Data: 2025-07-22
# Objetivo: Demonstrar um fluxo de trabalho para análise de vídeo em R,
#           focando na decomposição do vídeo em seus componentes (frames e áudio).

# --- 0. Pacotes Necessários ---
# Certifique-se de que os pacotes estão instalados. Se não, rode no Console:
# install.packages(c("tidyverse", "av", "magick", "opencv"))

library(tidyverse)
library(av)        # O pacote principal para ler, escrever e manipular vídeo e áudio
library(magick)    # Para manipulação de imagens (frames)
library(opencv)    # Para detecção de objetos (usado na seção avançada)

# --- Preparação: Baixar o Vídeo de Exemplo ---
# Vamos criar uma pasta 'dados' para nossos arquivos.
if (!dir.exists("dados")) {
  dir.create("dados")
}

## Código para usar BigBuckBunny
# video_url <- "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
# video_path <- "dados/big_buck_bunny.mp4"
# Baixar o vídeo apenas se ele ainda não existir na pasta.
# if (!file.exists(video_path)) {
#   cat("Baixando o vídeo de exemplo 'Big Buck Bunny'...\n")
#   download.file(video_url, destfile = video_path, mode = "wb")
#   cat("Download concluído.\n")
# } else {
#   cat("O vídeo de exemplo 'Big Buck Bunny' já existe.\n")
# }

## Usar o vídeo de pessoas andando
video_path <- "dados/pessoas_andando.mp4"
video_url <- "https://videos.pexels.com/video-files/4727781/4727781-hd_1920_1080_30fps.mp4"
if (!file.exists(video_path)) {
    cat("Baixando o vídeo de exemplo 'pessoas andando'...\n")
    download.file(video_url, destfile = video_path, mode = "wb")
    cat("Download concluído.\n")
} else {
  cat("Vídeo de exemplo 'pessoas_andando' encontrado.\n")
}


# --------------------------------------------------------------------------
# --- SEÇÃO INTRODUTÓRIA: Lendo e Inspecionando um Vídeo ---
# --------------------------------------------------------------------------
# Objetivo: Ler um arquivo de vídeo, extrair seus metadados básicos e
#           isolar um único frame como uma imagem.

cat("\n--- Iniciando Seção Introdutória ---\n")

# -- Passo 1: Obter Informações do Vídeo --
# A função av_video_info() lê os metadados do arquivo de vídeo sem
# carregar o vídeo inteiro na memória.
info_video <- av_video_info(video_path)

cat("Informações sobre o vídeo:\n")
print(info_video)


# -- Passo 2: Extrair um Único Frame --
# A função av_capture_frame() permite extrair um frame de um ponto
# específico no tempo. Vamos pegar o frame no segundo 15.
frame_15s <- av_video_images(video = video_path, 
                             trim = "15:16",
                             fps=1)

# O resultado é um string com a localização da imagem que foi extraído.
cat("\nLocalização do frame extraído:\n", frame_15s, "\n")


# -- Passo 3: Trabalhando com o Frame como uma Imagem --
# Podemos ler esta imagem como um objeto do pacote `magick` para
# manipulá-lo usando as técnicas que aprendemos no script sobre imagens.
frame_magick <- image_read(frame_15s)

cat("Visualizando o frame do segundo 15 como uma imagem:\n")
print(image_scale(frame_magick, "600")) # Redimensionando para exibir


# --------------------------------------------------------------------------
# --- SEÇÃO INTERMEDIÁRIA: Decompondo o Vídeo ---
# --------------------------------------------------------------------------
# Objetivo: Separar o vídeo em seus componentes principais: a trilha de áudio
#           e uma sequência de frames (para criar um GIF).

cat("\n\n--- Iniciando Seção Intermediária ---\n")

# -- Demonstração 1: Extraindo a Trilha de Áudio --
# Podemos usar av_audio_convert() para extrair o áudio e salvá-lo como um
# arquivo .wav, que pode ser analisado com as ferramentas da aula de áudio.
# audio_output_path <- "dados/bunny_audio.wav"
audio_output_path <- "dados/andando_audio.wav"

av_audio_convert(
  audio = video_path,
  output = audio_output_path,
  format = "wav",
  total_time = 10 # to limit the output size (can be removed to extract all audio)
)
cat("Trilha de áudio extraída e salva em:", audio_output_path, "\n")
# Agora, poderíamos usar `tuneR::readWave(audio_output_path)` para analisá-lo.


# -- Demonstração 2: Criando um GIF a partir de Frames --
# Vamos extrair alguns frames e combiná-los em uma animação.

paths_dos_frames <- av_video_images(video_path, trim = "20:22", fps=5)
# Agora, usamos magick para processar estes frames
cat("\nProcessando frames para criar um GIF...\n")
gif_animado <- paths_dos_frames |>
  image_read() |>        # Converte a lista de arrays para objetos magick
  image_join() |>        # Junta todos em uma única sequência
  image_scale("300") |>  # Redimensiona para um tamanho razoável
  image_animate(fps = 5) # Anima a sequência com 5 frames por segundo

cat("Visualizando o GIF animado criado a partir dos frames do vídeo:\n")
print(gif_animado)


# --------------------------------------------------------------------------
# --- SEÇÃO AVANÇADA: Análise de Vídeo com Visão Computacional ---
# --------------------------------------------------------------------------
# Objetivo: Aplicar um modelo de detecção de objetos (faces) a cada frame
#           de um vídeo para criar um vídeo anotado.

# ATENÇÃO: Este processo pode ser computacionalmente intensivo e demorar.
# Vamos analisar apenas 5 segundos do vídeo.

cat("\n\n--- Iniciando Seção Avançada ---\n")

# -- Passo 1: Definir o Processo para um Único Frame --
# Criamos uma função que recebe o caminho até um frame, 
# detecta faces e desenha um retângulo.
# O formato do desenho retornado é magick-image
anotar_faces <- function(frame) {
  # Converte o frame (localização do arquivo no disco) para um objeto opencv
  frame_ocv <- ocv_read(frame)
  # Converte o frame para o formato magick-image para anotação depois
  frame_magick <- image_read(frame)

  # Detecta as coordenadas das faces
  facemask <- ocv_facemask(frame_ocv)
  coordenadas <- attr(facemask, 'faces')
  
  # Se faces forem encontradas, desenha um retângulo
  if (nrow(coordenadas) > 0) {
    cat("\nDesenhando retângulos nas ", nrow(coordenadas), 
        " faces detectadas usando magick...\n")
    
    # A função image_draw() do magick abre um "dispositivo gráfico" para desenhar.
    desenho <- image_draw(frame_magick)
    
    # Usamos a função rect() do R base para desenhar os retângulos.
    # Note que o ocv_facemask retorna um raio, então construímos o retângulo a partir dele.
    rect(
      xleft = coordenadas$x - coordenadas$radius,
      ybottom = coordenadas$y + coordenadas$radius,
      xright = coordenadas$x + coordenadas$radius,
      ytop = coordenadas$y - coordenadas$radius,
      border = "red",
      lwd = 3
    )
    
    # Finaliza o processo de desenho
    dev.off()
    return(desenho)
  }  
  return(frame_magick)
}

# -- Passo 2: Aplicar a Função a Múltiplos Frames --
# Vamos processar um frame a cada meio segundo para 5 segundos.
paths_dos_frames_a_anotar <- av_video_images(video_path, 
                                             trim = "1:21", 
                                             fps=2)

cat("Processando vídeo para detecção de faces (pode demorar um pouco)...\n")
frames_anotados <- map(paths_dos_frames_a_anotar, anotar_faces)

# -- Passo 3: Criar o Vídeo Final Anotado --
# Combinamos os frames anotados em uma animação final.
video_anotado <- frames_anotados |>
  image_join() |>
  image_scale("800") |>
  image_animate(fps = 2)

cat("Visualizando o vídeo final com as faces detectadas:\n")
print(video_anotado)

cat("\nFim do script de análise de vídeo.\n")
