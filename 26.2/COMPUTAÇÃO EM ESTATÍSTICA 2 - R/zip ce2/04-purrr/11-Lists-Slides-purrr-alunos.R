# --- R Code Script from "Lists with purrr" Slides (Pages 38 onwards) ---
# Fonte: Extraído de 11-Lists-Slides-purrr.pdf
# Propósito: Fornecer trechos de código executáveis para estudantes.

# --- Dependencies ---
# O código a seguir requer o pacote 'tidyverse'.
# install.packages("tidyverse") # Execute uma vez se não estiver instalado
library(tidyverse)

# Alguns blocos de código dependem de objetos criados em slides anteriores (antes da página 38)
# ou dados externos. Placeholders ou passos de configuração estão incluídos abaixo.

# --- Setup from Page 40 (Required for later examples) ---
# Dados de exemplo para notas de exame
set.seed(1000)
exams <- list(
  student1 = round(runif(10, 50, 100)),
  student2 = round(runif(10, 50, 100)),
  student3 = round(runif(10, 50, 100)),
  student4 = round(runif(10, 50, 100)),
  student5 = round(runif(10, 50, 100))
)

# Placeholder para o objeto extra_credit (usado por volta da página 75)
# Baseado no contexto/saída do slide 78
extra_credit <- list(0, 0, 10, 10, 15) # Valores de exemplo
names(extra_credit) <- names(exams) # Atribuir nomes correspondentes a exams

# Placeholder/Nota para o conjunto de dados 'who' (usado por volta da página 91)
# Este conjunto de dados faz parte do pacote 'tidyr' (incluído no tidyverse)
# who <- tidyr::who # Descomente esta linha se você não tiver 'who' carregado

# --- Page 43 ---
# Demonstrando erro ao aplicar mean diretamente a uma lista
# mean(exams) # Esta linha produzirá um erro, como mostrado no slide

# --- Page 44 ---
# Calculando a média para cada estudante individualmente
mean(exams$student1)
mean(exams$student2)
mean(exams$student3)
mean(exams$student4)
mean(exams$student5)

# --- Page 45 ---
# Criando uma lista de médias manualmente
list(
  student1 = mean(exams$student1),
  student2 = mean(exams$student2),
  student3 = mean(exams$student3),
  student4 = mean(exams$student4),
  student5 = mean(exams$student5)
)

# --- Page 47 ---
# Carregando tidyverse (já feito acima, mostrado aqui para contexto do slide)
# library(tidyverse)

# --- Page 48 ---
# Usando map() para aplicar mean a cada elemento
exams %>% map(mean)

# --- Page 52 ---
# Definindo nomes para elementos dentro de um elemento da lista
x <- c("hw1", "hw2", "hw3", "hw4", "hw5", "hw6", "hw7", "hw8", "hw9", "hw10")
set_names(exams$student1, nm = x)

# --- Page 53 ---
# Usando map() com set_names()
exams %>% map(set_names, nm = x)

# --- Page 54 ---
# Usando map() duas vezes (set_names e depois bind_rows)
# Nota: bind_rows aqui pode não ser a função pretendida para vetores brutos,
# provavelmente é usado ilustrativamente ou requer transformação prévia.
# Esta cadeia específica pode produzir avisos ou saída inesperada dependendo
# da estrutura exata esperada por bind_rows neste contexto.
exams %>%
map(set_names, nm = x) %>%
map(bind_rows) # Verifique se esta etapa é apropriada para seu objetivo

# --- Page 57 ---
# Usando map_dfr() para combinar resultados em um data frame por linha
# Requer elementos adequados para ligação por linha (ex: vetores/listas nomeados)
exams %>%
 map(set_names, nm = x) %>% # Garanta que os elementos sejam vetores nomeados primeiro
 map_dfr(bind_rows, .id = "student") # .id adiciona nomes dos estudantes como uma coluna

# --- Page 58 ---
# Usando map_dfc() para combinar resultados em um data frame por coluna
# Requer elementos adequados para ligação por coluna
exams %>%
 map(set_names, nm = x) %>%
 map_dfc(bind_rows) # Verifique a adequação; nomes das colunas podem colidir

# --- Page 60 ---
# Usando map_dbl() para obter um vetor numérico nomeado de médias
exams %>% map_dbl(mean)

# --- Page 61 ---
# Exemplo de um teste lógico aplicado a um elemento
length(exams$student1) == 10

# --- Page 63 ---
# Usando map() com o atalho de fórmula para um teste lógico
exams %>% map(~length(.) == 10)

# --- Page 65 ---
# Completar

# --- Page 67 ---
# Completar

# --- Page 68 ---
# Definindo uma função simples e chamando-a
add_1 <- function(x) x + 1
add_1(1)

# --- Page 70 ---
# Definindo uma função com dois argumentos e chamando-a
add_2 <- function(x, y) x + y
add_2(2, 3)

# --- Page 75 ---
# Usando map2() com o atalho de fórmula (requer a lista 'extra_credit')
# Garanta que 'extra_credit' esteja definido (veja seção de setup acima)
exams %>% map2(extra_credit, ~.x + .y) # Isso soma vetores elemento a elemento

# --- Page 78 ---
# Completar

# --- Page 88 ---
# Criando um tibble com uma coluna de lista manualmente
df <- tibble(
 num = c(1, 2, 3),
 cha = c("one", "two", "three"),
 listcol = list(1, c("1", "two", "FALSE"), FALSE)
)

# --- Page 89 ---
# Adicionando outra coluna de lista usando mutate
df %>%
 mutate(listcol2 = list(c(1,2), c(3,4), "Hi"))

# --- Page 91 ---
# Visualizando o conjunto de dados 'who' (requer que 'who' esteja carregado - veja setup)
View(who) # Descomente para visualizar se 'who' está carregado

# --- Page 92 ---
# Passos de manipulação de dados para criar o conjunto de dados 'tb' a partir de 'who'
# Requer que o conjunto de dados 'who' esteja carregado
tb <-
 who %>%
 gather("codes", "n", 5:60) %>%
 separate(codes, c("new", "type", "sexage"), sep = "_") %>%
 select(-new, -iso2, -iso3) %>%
 separate(sexage, c("sex", "age"), sep = 1) %>%
 drop_na(n) # Descomente se 'who' está carregado e você quer criar 'tb'

# --- Page 100 ---
# Aninhando os dados 'tb'
# Requer o objeto 'tb' da página 92
tb_predictions <- tb %>%
 group_by(country, year) %>%
 summarise(n = sum(n), .groups = 'drop') %>% # Adicionado .groups = 'drop'
 nest(data = c(year, n)) # Especifique colunas para aninhar
# Descomente se 'tb' existe

# --- Page 101 ---
# Acessando os dados aninhados para o primeiro país
# Requer 'tb_predictions' da página 100
tb_predictions$data[[1]] # Descomente se 'tb_predictions' existe

# --- Page 102 ---
# Ajustando modelos aos dados aninhados usando map()
# Requer 'tb_predictions' da página 100
# Nota: Slide original usou 'lifeExp', provavelmente um erro, deveria ser 'n'
tb_predictions_models <- tb_predictions %>%
 mutate(model = map(data, ~lm(n ~ year, data = .)))
# Descomente se 'tb_predictions' existe

# --- Page 103 ---
# Acessando o modelo ajustado para o primeiro país
# Requer 'tb_predictions_models' da página 102
tb_predictions_models$model[[1]] # Descomente se o objeto existe

# --- Page 104 ---
# Fazendo previsões usando os modelos ajustados e map_dbl()
# Requer 'tb_predictions_models' da página 102
tb_predictions_final <- tb_predictions_models %>%
 mutate(pred_2020 = map_dbl(model, predict, newdata = tibble(year = 2020)))
# Descomente se o objeto existe

# --- Page 105 ---
# Desaninhando dados (exemplo, pode desaninhar os dados aninhados originais)
# Requer 'tb_predictions' da página 100
tb_predictions %>% unnest(data) %>% View()# Descomente se o objeto existe

# --- End of Script ---
