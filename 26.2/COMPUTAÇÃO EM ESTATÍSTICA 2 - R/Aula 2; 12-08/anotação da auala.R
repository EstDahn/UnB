

install.packages("tidyverse")
library(tidyverse)

dinossauro <- read.csv('pew.csv',check.names = F)

dinossauro |> pivot_longer(!religion,
                           names_to = 'renda',
                           values_to = 'observações')





#-------------------------------------------------------------------------------


raw <- read.delim("weather.txt",check.names = F, na.strings = '.')

raw2 <- pivot_longer(raw,!c(year,month,element),
                     names_to = 'day', values_to = 'value',
                     values_drop_na = T)

raw2_final = pivot_wider(raw2, names_from = "element",
                         values_from = 'value')
raw2_final

#$$

tidy <- raw |>
  pivot_longer(!c(year,month,element),
               names_to = 'day', values_to = 'value',
               values_drop_na = T) |> 
  pivot_wider(names_from = "element",
              values_from = 'value')
tidy


#juntasse

rbind() e cbind()

#SALVAR
write.csv



