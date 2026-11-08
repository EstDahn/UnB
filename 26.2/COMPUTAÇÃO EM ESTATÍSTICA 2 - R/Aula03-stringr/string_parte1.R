##############################################
####### Aula CE2 - Prof. Thais #######
##############################################


## Loading packages
library(tidyverse)
#library(stringr)

###################################
## Exercício do slide Aula 02 #####
###################################
library(babynames)
library(nycflights13)
babynames %>%
  mutate(last = str_sub(name, -1),
         vowel = last %in% c("a", "e", "i", "o", "u", "y")) %>%
  group_by(year, sex) %>%
  summarise(p_vowel = weighted.mean(vowel, n)) %>%
  ggplot(aes(year, p_vowel, color=sex)) +
  geom_line()


###################################
####### Strings Basic #############
###################################

# Creating a string
string1 <- "This is a string"
string1

# Escape character:  \ 
double_quote <- "\""
double_quote
writeLines(double_quote)

# quiz: include a literal backslash
backslash <- "\\"
writeLines(backslash)

# quiz: write http:\\
text <- "http:\\\\"
text
writeLines(text)

# quiz: write "http:\\"
text <- " \"http:\\\\\" "
text
writeLines(text)

text <- ' "http:\\\\" '
text2 <- " 'http:\\\\' " 
writeLines(text)
writeLines(text2)


# Special characters
?"'"
x <- "\u00b5"
x
y <- "\U0001f604"
y

setwd("C:\\Users\\Professor\\Desktop")


# Raw string 
tricky <- r"("http:\\")"
str_view(tricky)
    

# Number of characters in a string
str_length(c("a", "R for data science", NA))
str_length("   ")

# Exemplo: No banco de dados babynames, apresente uma tabela de contagem: número de caracteres, número de crianças
babynames %>%
  count(length = str_length(name), wt = n)

# Exemplo: Filtre os nomes com 15 caracteres e faça uma tabela de contagem: nome, quantidade de crianças.
#          Ordene do nome mais popular para o menos popular.
babynames %>%
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)


# Combine strings
str_c("x", "y", "z", sep = "_")
str_c("x", "y", "z")
str_c("Turma-", c("a", "b", "c"), "-Prof.Thais")
?str_c

letras <- c("a", "b", "c")
str_glue( "Turma-{letras}-Thais")

dados = data.frame(professor = c("Thais","Alan") , disciplina= "CE2", Turma = c("01","02"))
# Exemplo: Adicione 1 coluna chamada código no seguinte formato CE2_01_ProfThais
dados %>% mutate(código = str_glue("{disciplina}_{Turma}_Prof{professor}"))


# Vector collapse
str_flatten(c("x", "y", "z"), ", ")
str_flatten(dados$professor, ", ")


# Subsetting strings  
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)
str_to_lower(str_sub(x, 1, 1))
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x <- str_to_lower(x)
str_sub(x, 1, 1) <- "Anajapjsdp"
x

# Upper and lower case
str_to_lower(x)
?str_to_lower

dog <- "The quick brown dog"
str_to_upper(dog)
str_to_lower(dog)
str_to_title(dog)
str_to_sentence("the quick brown dog")


# Separate strings into rows or columns
df1 <- data.frame(x = c("a,b,c", "d,e", "f"))
df1
df1 %>% separate_longer_delim(x, delim = ",")


df3 <- data.frame(x = c("CE2_01_Thais", "CE2_02_Alan", "IP_01_Roberto"))
df3
df3 %>%
  separate_wider_delim(
    x,
    delim = "_",
    names = c("disciplina", "turma", "professor")
  )


