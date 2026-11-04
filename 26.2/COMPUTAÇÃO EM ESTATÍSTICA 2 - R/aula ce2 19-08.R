install.packages("babynames")

library(tidyverse)
library(stringr)
library(babynames)

str_sub("daniel", start = 0, end = -1)

objeto <- "Garret"
objeto

str_sub(objeto,-3) <- 'eth'
objeto

str_sub(objeto,-3) <- 'banana'
objeto


bn <- babynames |> 
  mutate(ultima = str_sub(babynames$name,-1),
         vogal = ultima %in% c("a","e","i","o","u","y") ) |>
  group_by(year,sex) |> 
  summarise( p = weighted.mean(x = vogal, y = n)) |> 
  ggplot(aes(year,p, colour = sex)) +
  geom_line()

bn

texto <- "htpp:\\\\"
writeLines(texto)

texto1 <- '"htpp:\\\\"'
writeLines(texto1)

mi <- "\u00b5"
mi

emoji <- "\U0001f604"
emoji

#escrita pura
tdm = r"("http:\\")"
writeLines(tdm)





