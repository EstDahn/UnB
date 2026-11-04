# --- Script de Código R dos Slides de "Fatores" (forcats) ---
# Fonte: Extraído de 13-Types-Slides-factors.pdf
# Nota: Slides com soluções (páginas 20, 28) foram excluídos.

# --- Dependências ---
# Carrega o tidyverse (inclui dplyr, ggplot2, forcats)
library(tidyverse) 
# library(forcats) # forcats faz parte do tidyverse

# --- Página 2 ---
olhos <- factor(x = c("azul", "verde", "verde"),
                levels = c("azul", "castanho", "verde"))

# --- Página 3 ---
olhos
unclass(olhos)

# --- Página 4 ---
# library(tidyverse) # Já carregado

# --- Página 6 ---
# library(forcats) # Já carregado via tidyverse
# O conjunto de dados gss_cat está incluído no pacote forcats
data(gss_cat) 
# View(gss_cat) # Opcional: visualizar os dados

# --- Página 7 ---
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  group_by(relig) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# --- Página 13 ---
levels(gss_cat$relig)

# --- Página 17 ---
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  group_by(relig) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

# --- Página 19 ---
# Sua Vez 3 - Código a ser completado pelos alunos
# (Solução executável da Página 20 foi excluída)

# --- Página 20 ---
# (Solução Excluída)

# --- Página 23 ---
gss_cat %>%
  ggplot(aes(marital)) + 
  geom_bar()

# --- Página 24 ---
gss_cat %>%
  ggplot(aes(fct_infreq(marital))) + 
  geom_bar()

# --- Página 25 ---
gss_cat %>%
  ggplot(aes(fct_rev(fct_infreq(marital)))) + 
  geom_bar()

# --- Página 27 ---
# Sua Vez 4 - Código a ser completado pelos alunos
# (Solução executável da Página 28 foi excluída)

# --- Página 28 ---
# (Solução Excluída)

# --- Página 31 ---
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  mutate(partyid = fct_recode(partyid,
                              "Republicano, forte"    = "Strong republican",
                              "Republicano, fraco"      = "Not str republican",
                              "Independente, pró-rep" = "Ind, near rep",
                              "Independente, pró-dem" = "Ind, near dem",
                              "Democrata, fraco"        = "Not str democrat",
                              "Democrata, forte"      = "Strong democrat")) %>%
  group_by(partyid) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(tvhours, fct_reorder(partyid, tvhours))) +
  geom_point() + 
  labs(y = "Identificação Partidária")

# --- Página 35 ---
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  mutate(partyid = fct_collapse(partyid,
                                conservador = c("Strong republican", 
                                                "Not str republican", 
                                                "Ind, near rep"),
                                liberal = c("Strong democrat", 
                                            "Not str democrat", 
                                            "Ind, near dem"))) %>%
  group_by(partyid) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(tvhours, fct_reorder(partyid, tvhours))) +
  geom_point() + 
  labs(y = "Identificação Partidária")

# --- Página 39 ---
# Nota: O código original do slide agrupa implicitamente outras categorias. 
# Usar fct_lump explicitamente torna isso mais claro.
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  mutate(partyid = partyid %>%
           fct_collapse(
             conservador = c("Strong republican", "Not str republican", "Ind, near rep"),
             liberal = c("Strong democrat", "Not str democrat", "Ind, near dem")
           ) %>% 
           fct_lump(n = 2, other_level = "Outro") # Manter os 2 principais, agrupar o resto em "Outro"
  ) %>%
  # Filtrar níveis NA/Outros originais se não foram colapsados, 
  # ou tratar o novo nível "Outro" apropriadamente, dependendo do objetivo da análise.
  # Para este gráfico, podemos querer manter o novo "Outro".
  group_by(partyid) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(tvhours, fct_reorder(partyid, tvhours))) +
  geom_point() + 
  labs(y = "Identificação Partidária")

# --- Página 41 ---
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  mutate(partyid = partyid %>%
           fct_collapse(
             conservador = c("Strong republican", "Not str republican", "Ind, near rep"),
             liberal = c("Strong democrat", "Not str democrat", "Ind, near dem")
           ) %>% 
           fct_lump(n = 2, other_level = "Outro") 
  ) %>%
  group_by(partyid) %>%
  summarise(tvhours = mean(tvhours)) %>%
  ggplot(aes(fct_reorder(partyid, tvhours), tvhours)) + # Reordenar o fator para o eixo x
  geom_col() + 
  labs(x = "Identificação Partidária") + 
  coord_flip() # Inverter as coordenadas para barras horizontais

# --- Fim do Script ---
