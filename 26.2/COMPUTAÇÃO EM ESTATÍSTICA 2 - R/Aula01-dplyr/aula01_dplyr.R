library(tidyverse)

dados = read.csv("bnames.csv.bz2")
head(dados)
View(dados)

dplyr::filter(dados, soundex=="J500")

dados_J500 = dados %>% 
                    dplyr::filter(soundex=="J500")

dados_J500 %>% select(c(name, year))

dados %>% 
  dplyr::filter(soundex=="J500") %>%
  select(c(name, year)) %>%
  mutate(ano_menor_2000 = ifelse(year < 2000, "Sim", "Não"))

dados2 = tibble(dados) %>% 
  dplyr::filter(soundex=="J500") %>%
  select(c(name, year)) %>%
  mutate(ano_menor_2000 = year < 2000) %>%
  arrange(desc(year))

View(dados2)

dados %>%
  group_by(soundex) %>% 
  summarise(media = mean(prop))
