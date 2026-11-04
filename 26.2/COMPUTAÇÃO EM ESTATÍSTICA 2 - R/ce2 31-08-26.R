
library(tidyverse)

x <- c("apple\\", "banana","pear")

writeLines(x)

str_view(x,"\\\\")
str_view(x,"[\\\\]")



x <- "1888: MDCCCCCCLXXXVIII"

str_view(x, "CC+")
str_view(x,"CC*")
str_view(x,"CCC")

str_view(x,'C{3}')
str_view(x,'C{4,}')
str_view(x,"C{1,2}")

str_view(x,'C[LX]')
str_view(x,'C[LX]+')

# Regex Flags

bananas <- c('banana','Banana','BANANA')

str_view(bananas,"banana")
str_view(bananas, regex("banana",ignore_case = TRUE))
         



num <- 1:2000

meio <- num*0.05

str_detect(words,'^[Tt]')

sum(str_detect(words,'^[^Tt]'))

sum(!str_detect(words,'^[Tt]'))


#PROP DE  TERMINA VOGAL:

mean(str_detect(words,'[aeiouy]$'))

head(cbind(words,str_detect(words,'[aeiouy]$')))


#PROP DE  TERMINA consoante:

mean(!str_detect(words,'[aeiouy]$'))

mean(str_detect(words,'[^aeiouy]$'))

head(cbind(words,!str_detect(words,'[aeiouy]$')))


#QUANTAS VOGAIS POR PALAVRA:

x <- c("apple", "banana","pear")

str_detect(x,"a")
str_count(x,"a")

str_count(words,"[aeiouy]")
head(cbind(words,str_count(words,"[aeiouy]")))

mean(str_count(words,"[aeiouy]"))

#-------------------------------------------------
colours <- c("\\bred","orange","yellow","green","blue","purple\\b")
colour_match <- str_flatten(colours,collapse = "\\b|\\b")
colour_match


str_detect(sentences,colour_match)

sum(str_detect(sentences,colour_match))

sentences[str_detect(sentences,colour_match)]

str_subset(sentences, colour_match)

tem_cor <- str_subset(str_to_lower(sentences), colour_match)
tem_cor

matches <- str_extract(tem_cor,colour_match)
matches

matches2 <- str_extract_all(tem_cor,colour_match,simplify = T)
matches2


