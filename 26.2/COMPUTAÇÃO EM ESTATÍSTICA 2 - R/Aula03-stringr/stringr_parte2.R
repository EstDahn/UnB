###################################
####### Regular expressions #######
###################################
library(tidyverse)

## It is language that allow you to describe 
## patterns in strings
?regex
x <- c("apple", "banana", "pear")
str_view(x, "an")

str_view(x, ".a.")
str_view("bananana", ".a.")
# obs.: matches never overlap


# Anchor
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")


# Boundaries: \b
head(sentences)
str_view(sentences, "book")
str_view(sentences, " \\bbook\\b")


# Quantifiers: ? + *
str_view(c("a", "ab", "abb"), "ab?") # 0/1
str_view(c("a", "ab", "abbbbbb"), "ab+") # 1+
str_view(c("a", "ab", "abb"), "ab*") # 0+


# Classes
str_view(c("wexet", "exemplo", "oi"), "^[aeiouy]x[aeiouy]")
length(str_view(words, "[aeiouy]x[aeiouy]?"))
length(str_view(words, "[aeiouy]x"))
str_view(words, "[^aeiou]y[^aeiou]")
str_view(c("osys", "gyo"), "[^aeiou]y[^aeiou]")

x <- c("1dog\"", "cat1", "cat2")
writeLines(x)

str_view(x, "[digit]")
str_view(x, "[:digit:]")
str_view(x, "^[:digit:]")
str_view(x, "[^digit]")
str_view(x, "[:^digit:]")
?regexp


# Range
x <- c("Apple", "banana", "pear")
str_view(x, "[a-i]") 
str_view(x, "[I-f]") 
str_view(x, "^[A-Z].*[a-z]$")
str_view(x, "^[A-Z][a-z]")
str_view(x, "^[A-Z][a-z]$")
str_view(x, "[aeiouy]") 
str_view(x, "[^aeiouy]") 


# Alternation 
str_view(c("grey", "gray"), "(gray)|(grey)") # gray ou grey
str_view(c("grey", "gray"), "gr(e|a)y") # grey ou gray
str_view(c("grey", "gray"), "gre|ay") # gre ou ay
str_view(c("grey", "gray"), "g(re|a)y") # grey ou gay



# Escaping in regular expressions
# Look for a literal character that normally has special meaning in a regex
# how do you match the character “.”?
x <- c("apple.", "banana\\", "pear^", "a\"")
str_view(x)
str_view(x, ".")
str_view(x, "\\.") # reg. expr:
str_view(x, "[.]")
str_view(x, fixed("."))
1. escrever um texto
2. ler o texto e tranformar em expressão regular
3. Interpretar a expressão regular

# exceptions:
str_view(x, "[\"]")
str_view(x, fixed("\""))
str_view(x, "[\\^]") # reg. expr: \^
str_view(x, "\\^")
str_view(x, fixed("^"))


x <- c("apple\\", "banana", "pear")
writeLines(x)
str_view(x, "\\\\") # reg. exp. \\
str_view(x, "[\\\\]")
str_view(x, fixed("\\"))


# More about Quantifiers
x <- "1888: MDCCCCCCLXXXVIII"
str_view(x, "CC+") # 1+
str_view(x, "CC*") # 0+
str_view(x, "CCC")

str_view(x, 'C[LX]+')
str_view(x, 'C{3}')
str_view(x, 'C{4,}')
str_view(x, 'C{1,2}')


# Regex flags
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))
?regex


# Exercícios

# 1. From "sentences", find all sentences that start with “The”.

# 2. Find all sentences that begin with (She,He,It,They).

# 3. Find "words" that only contains consonants and y.









# Respostas 
str_view(sentences, "^The\\b")
str_view(sentences, "^(She|He|It|They)\\b")
str_view(words, "^[^aeiou]+$")


