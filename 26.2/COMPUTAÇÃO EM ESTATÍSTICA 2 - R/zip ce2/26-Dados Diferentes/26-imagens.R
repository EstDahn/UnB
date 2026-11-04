# --- Script de Aula: Análise de Dados de Imagem em R ---
# Autor: IA Gemini instruída por dmp
# Data: 2025-07-22
# Objetivo: Demonstrar um fluxo de trabalho para análise de imagem em R,
#           desde manipulações básicas até tarefas de visão computacional.

# --- 0. Pacotes Necessários ---
# Certifique-se de que os pacotes estão instalados. Se não, rode no Console:
# install.packages(c("magick", "imager", "tidyverse", "tesseract", "opencv"))

library(magick)
library(imager)
library(tidyverse)
library(tesseract)
library(opencv)

# --------------------------------------------------------------------------
# --- SEÇÃO INTRODUTÓRIA: Manipulações de Alto Nível com `magick` ---
# --------------------------------------------------------------------------
# Objetivo: Ler uma imagem e aplicar transformações visuais comuns.

cat("--- Iniciando Seção Introdutória ---\n")

# -- Passo 1: Ler uma Imagem --
# Usamos uma imagem de exemplo que vem com o pacote `magick`.
# Isso garante que o código funcione para todos sem precisar baixar arquivos.
imagem <- image_read("wizard:")

# Para ler um arquivo do seu próprio computador, você usaria:
# imagem <- image_read("caminho/para/sua/imagem.jpg")

# -- Passo 2: Inspecionar o Objeto da Imagem --
# Imprimir o objeto nos dá metadados sobre a imagem.
cat("Informações sobre a imagem original:\n")
print(imagem)

# -- Passo 3: Transformações Básicas --
# O `magick` usa o pipe (|> ou %>%) para encadear operações.

# Redimensionar a imagem
imagem_pequena <- image_scale(imagem, "200") # Redimensiona para 200px de largura

# Converter para escala de cinza
imagem_cinza <- image_convert(imagem, type = 'Grayscale')

# Aplicar um filtro de desfoque (blur)
imagem_blur <- image_blur(imagem, radius = 0, sigma = 5)

# Aplicar um filtro artístico de carvão
imagem_carvao <- image_charcoal(imagem)

# -- Passo 4: Combinar e Visualizar Imagens --
# Podemos combinar as imagens em uma única para fácil comparação.
# image_append() empilha imagens horizontalmente.
primeira_linha <- image_append(c(imagem_pequena, imagem_cinza))
segunda_linha <- image_append(c(imagem_blur, imagem_carvao))

# image_append(..., stack = TRUE) empilha verticalmente.
imagem_combinada <- image_append(c(primeira_linha, segunda_linha), stack = TRUE)

cat("\nVisualizando a imagem combinada com as transformações...\n")
print(imagem_combinada)


# --------------------------------------------------------------------------
# --- SEÇÃO INTERMEDIÁRIA: A Imagem como Dados ---
# --------------------------------------------------------------------------
# Objetivo: Entender que uma imagem é uma matriz de números (pixels) e
#           realizar análises quantitativas.

cat("\n\n--- Iniciando Seção Intermediária ---\n")

# -- Demonstração 1: Extraindo Dados de Pixels --
# Usamos image_data() para converter a imagem em um array numérico.
# A estrutura é [canal_de_cor, largura, altura].
dados_pixels <- image_data(imagem_pequena) # Usando a imagem menor para ser mais rápido
cat("Dimensões do array de pixels:", dim(dados_pixels), "\n")
cat("(Canais de Cor, Largura, Altura)\n")

# Os 3 canais de cor são Vermelho, Verde e Azul (RGB).
# Vamos manipular o array: remover completamente o canal azul para um efeito mais visível.
dados_sem_azul <- dados_pixels
# CORREÇÃO: Para atribuir um valor a um array 'raw', o valor também deve ser 'raw'.
# Usamos as.raw(0) para representar o zero em formato de byte.
dados_sem_azul[3, , ] <- as.raw(0) 

# Agora, convertemos o array modificado de volta para uma imagem
imagem_sem_azul <- image_read(dados_sem_azul)

cat("\nComparando a imagem original com a versão sem o canal azul...\n")
print(image_append(c(imagem_pequena, imagem_sem_azul)))


# -- Demonstração 2: Histograma de Cores --
# O pacote `imager` é excelente para análises em nível de pixel.

# Vamos converter a imagem para o formato do `imager`.
imagem_cimg <- imager::magick2cimg(imagem_pequena)

# O resto do código funciona como antes.
pixels_df <- as.data.frame(imagem_cimg, wide = "c") |>
  rename(R = c.1, G = c.2, B = c.3)

cat("\nVisualização do data frame de pixels:\n")
print(head(pixels_df))

# Agora podemos usar ggplot2 para criar um histograma dos valores de cada canal de cor.
cat("\nGerando histograma de cores...\n")
pixels_df |>
  pivot_longer(cols = c(R, G, B), names_to = "canal", values_to = "valor") |>
  ggplot(aes(x = valor, fill = canal)) +
  geom_histogram(bins = 30, show.legend = FALSE) +
  facet_wrap(~canal, nrow = 3) +
  scale_fill_manual(values = c("R" = "red", "G" = "green", "B" = "blue")) +
  labs(
    title = "Distribuição dos Valores de Pixels por Canal de Cor",
    x = "Intensidade do Pixel (0-1)",
    y = "Contagem"
  )

# um novo histograma com valores altos simultâneos nos três canais removidos
pixels_df |>
  filter(R+G+B < 2.99) |> 
  pivot_longer(cols = c(R, G, B), names_to = "canal", values_to = "valor") |>
  ggplot(aes(x = valor, fill = canal)) +
  geom_histogram(bins = 30, show.legend = FALSE) +
  facet_wrap(~canal, nrow = 3) +
  scale_fill_manual(values = c("R" = "red", "G" = "green", "B" = "blue")) +
  labs(
    title = "Distribuição dos Valores de Pixels por Canal de Cor",
    x = "Intensidade do Pixel (0-1)",
    y = "Contagem"
  )


# --------------------------------------------------------------------------
# --- SEÇÃO AVANÇADA: Visão Computacional ---
# --------------------------------------------------------------------------
# Objetivo: Introduzir tarefas de alto nível como Reconhecimento Óptico de
#           Caracteres (OCR) e Detecção de Objetos.

cat("\n\n--- Iniciando Seção Avançada ---\n")

# -- Demonstração 1: Reconhecimento Óptico de Caracteres (OCR) --
# Usamos o pacote `tesseract` para "ler" texto de imagens.

# Primeiro, vamos criar uma imagem de exemplo com texto.
imagem_com_texto <- image_blank(width = 400, height = 100, color = "white") |>
  image_annotate("Estatística UnB", size = 30, gravity = "center")

cat("Imagem criada para o teste de OCR:\n")
print(imagem_com_texto)

# Antes de usar OCR em português com tesseract, é necessário
# baixar os dados treinados, executando o seguinte comando
# no console
# tesseract::tesseract_download("por")

# Agora, usamos tesseract para extrair o texto.
texto_extraido <- ocr(imagem_com_texto, engine = tesseract("por"))

cat("\nTexto extraído da imagem pela função ocr():\n")
cat(texto_extraido, "\n")


# -- Demonstração 2: Detecção de Objetos (Faces) --
# O pacote `opencv` nos dá acesso a algoritmos clássicos de visão computacional.
# Usaremos um modelo pré-treinado (Haar Cascade) para detectar faces.

# Vamos usar a imagem do `wizard:` novamente.
# Nota: Este modelo é treinado para detectar faces humanas. Ele pode não
# encontrar uma face na imagem do mago, mas o código demonstra o fluxo.

# 1. Suponha que você já tenha um objeto 'magick-image'
#    Para este exemplo, vamos criar um a partir da imagem de amostra.
magick_img <- image_read("wizard:")

# 2. Crie um caminho de arquivo temporário
#    Usar tempfile() é uma boa prática para não poluir seu diretório.
temp_path <- tempfile(fileext = ".png")

# 3. Salve a imagem do 'magick' neste arquivo temporário
image_write(magick_img, path = temp_path, format = "png")

# 4. Leia o arquivo temporário usando a função do 'opencv'
#    O resultado será um objeto 'opencv-image'.
ocv_img <- ocv_read(temp_path)

# 5. Verifique a classe do novo objeto para confirmar
class(ocv_img)
#> [1] "opencv-image"

# 6. (Opcional, mas boa prática) Remova o arquivo temporário
unlink(temp_path)

# A função ocv_face() detecta a localização de faces
faces_detectadas <- ocv_face(ocv_img)

cat("\nResultado da detecção de faces (pode ser um tibble vazio se nenhuma face for encontrada):\n")
print(faces_detectadas)

# Em seguida, usamos ocv_facemask() para obter as COORDENADAS das faces.
facemask <- ocv_facemask(ocv_img)
coordenadas_faces <- attr(facemask, 'faces')


cat("\nCoordenadas das faces detectadas (um data frame):\n")
print(coordenadas_faces)

# Agora, podemos verificar se o data frame tem linhas e extrair as faces da imagem.
if (nrow(coordenadas_faces) > 0) {
  cat("\nExtraindo as faces detectadas...\n")
  # A função ocv_rectangle extrai o retângulo.
  faces_no_retangulo <- ocv_rectangle(
    ocv_img, 
    x = coordenadas_faces$x - coordenadas_faces$radius, 
    y = coordenadas_faces$y - coordenadas_faces$radius, 
    width = 2*coordenadas_faces$radius, 
    height = 2*coordenadas_faces$radius)
}

  # Exibir a primeira face
  print(faces_no_retangulo)
  
} else {
  cat("Nenhuma face foi detectada na imagem do 'wizard:'.\n")
}

# Agora podemos manualmente anotar as faces na imagem original
# Agora, podemos verificar se o data frame tem linhas e desenhar na imagem
# original do `magick`, que é mais flexível para anotações.
if (nrow(coordenadas_faces) > 0) {
  cat("\nDesenhando retângulos nas faces detectadas usando magick...\n")
  
  # A função image_draw() do magick abre um "dispositivo gráfico" para desenhar.
  desenho <- image_draw(magick_img)
  
  # Usamos a função rect() do R base para desenhar os retângulos.
  # Note que o ocv_facemask retorna um raio, então construímos o retângulo a partir dele.
  rect(
    xleft = coordenadas_faces$x - coordenadas_faces$radius,
    ybottom = coordenadas_faces$y + coordenadas_faces$radius,
    xright = coordenadas_faces$x + coordenadas_faces$radius,
    ytop = coordenadas_faces$y - coordenadas_faces$radius,
    border = "red",
    lwd = 2
  )
  
  # Finaliza o processo de desenho
  dev.off()
  
  # Exibir a imagem final com os retângulos
  print(desenho)
  
} else {
  cat("Nenhuma face foi detectada na imagem do 'wizard:'.\n")
}


cat("\nFim do script de análise de imagem.\n")
