###################################
####### Regexp usage ##############
###################################

## Last class: stringr
# str_c/str_glue/str_flatten
# str_sub


# When you first look at a regexp, you’ll think a cat walked across your keyboard, 
# but as your understanding improves they will soon start to make sense.

# 1. Determine which strings match a pattern. # str_detect, str_count 
# 2. Find the positions of matches. # str_which
# 3. Extract the content of matches. # str_subset e str_extract, str_extract_all
# 4. Replace matches with new values. # str_replace 
# 5. Split a string based on a match. # str_split 

## 1. Detect matches and find positions of matches
library(tidyverse)

x <- c("apple", "banana", "pear")
str_detect(x, "e")

# How many common words start with t?
str_detect(words, "^[tT]")
sum(str_detect(words, "^[tT]"))

# How many common words do not start with t?
sum(str_detect(words, "^[^t]"))
sum(!str_detect(words, "^t"))
sum(str_detect(words, "^[a-su-zA-SU-Z]"))


# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiouy]$"))
head(cbind(words, str_detect(words, "[aeiouy]$")))


# What proportion of common words end with a consonant?
mean(!str_detect(words, "[aeiouy]$"))
mean(str_detect(words, "[^aeiouy]$"))


# On average, how many vowels per word?
x <- c("apple", "banana", "pear")
str_detect(x, "a")
str_count(x, "a")
head(cbind(words,str_count(words, "[aeiouy]")))
mean(str_count(words, "[aeiouy]"))


# Quiz: Create a df and a column with # vowels and consonants
df <- tibble(
  word = words, 
  i = seq_along(word)
)

df <- df %>% 
  mutate(
    vowels = str_count(word, "[aeiouy]"),
    consonants = str_count(word, "[^aeiouy]")
  )


## 2. Find the positions of matches
str_which(words,  "[aeiouy]$")


## 3. Extract the content of matches

# find all sentences that contain the following colours
colours <- c("red", "orange", "yellow", "green", "blue", "purple")

colour_match <- str_flatten(colours, collapse = "|")
colour_match
str_detect(sentences, colour_match)
sentences[str_detect(sentences, colour_match)]

has_colour <- str_subset(sentences, colour_match)
has_colour

# fix the problems:
colours <- c("\\bred", "orange", "yellow", "green", "blue", "purple\\b")
colour_match <- str_flatten(colours, collapse = "\\b|\\b")
colour_match
str_subset(sentences, colour_match)

# colours <- c(" red", "orange", "yellow", "green", "blue", "purple ")
# colour_match <- str_c(colours, collapse = " | ")
# str_subset(sentences, colour_match)

has_colour <- str_subset(str_to_lower(sentences), colour_match)
has_colour

# Return the pattern match
matches <- str_extract(has_colour, colour_match)
head(matches)

matches2 <- str_extract_all(has_colour, colour_match, simplify =  T)
head(matches2)
View(matches2)



## 4. Replace matches
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", 
                     "3" = "three"))

## 5. Split a string into pieces
?str_split
str_split(head(sentences, 5), " " )

sentences %>%
  head(5) %>% 
  str_split(" ")

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = T)


## Materials
# See string manipulation with stringr cheatsheet
# https://stringr.tidyverse.org/#cheatsheet
  
  
  
  ## Exercises
  
  # 1. From the words data: 
  ### a. Find all words that start or end with x.
library(tidyverse)
head(words)  
str_subset(words, "^[xX]|[xX]$")
str_subset(words, "^[xX][xX]$") # errado!
str_subset(c("xat", "cax", "aij", " axoj"), "^[xX]|[xX]$")

### b. Find all words that start with two or more vowels and end with a consonant.
str_subset(words, "^[aeiouy][aeiouy]+.*[^aeiouy]$")  
str_subset(words, regex("^[aeiouy][aeiouy]+.*[^aeiouy]$", ignore_case = T)) 
str_subset(words, regex("^[aeiouy]{2,}.*[^aeiouy]$", ignore_case = T)) 

parte1 = str_detect(words, "^[aeiouy]{2,}")
parte2 = str_detect(words, "[^aeiouy]$")
words[parte1&parte2]

# 2. From the Harvard sentences data, extract:
  ### a. The first word from each sentence.
sentences %>% head()

str_extract(sentences, "\\b[A-Za-z]+\\b")
str_extract(sentences, "[A-Za-z]+")
str_extract(sentences, "^[A-Za-z]+")
str_extract(sentences, "^[:alpha:]+")
str_extract(sentences, "\\b\\w+\\b")
str_extract(sentences, "^\\w+")
res = str_extract(sentences, "\\w+")
cbind(sentences, res) %>% head()
str_extract(c("1 apple", "One apple", "Apple is good"), "^\\w+")


### b. All words ending in ing.
str_extract_all(sentences, "\\b\\w+ing\\b", simplify=T) %>% View( )
str_extract_all(sentences, "\\b.*ing\\b", simplify=T) %>% View( ) # errado
str_extract_all(sentences, "ing$", simplify=T) # errado
str_extract_all(sentences, "ing\\b", simplify=T) %>% View( ) # errado

