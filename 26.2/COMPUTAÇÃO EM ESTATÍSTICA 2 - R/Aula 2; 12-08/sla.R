###-------------------------------------------------
### Aula Semana 1
###-------------------------------------------------

# Utilizaremos '#' para fazer comentários no código

#Site com microdados utilizados no curso
#https://portaldeimigracao.mj.gov.br/pt/base-de-dados

#Usando R como uma calculadora
2 + 2
5 * 3
10 / 2
4^2


#Atribuindo valores a objetos
a <- 10
b <- 5
c1 <- a + b
c1
#Obs: tambem e possivel utilizar '=' para atribuicao
c2 = a * b
c2

#help: pesquise por palavra chave ou o nome de alguma funcao
help(sum)

vet=c(1,2,4)
sum(vet)

###------------------------------------------
# pre-leitura dos microdados (formato .csv)
###------------------------------------------
#identificar o diretorio de trabalho
getwd()
#setar o diretório de trabalho
setwd("C:/...")
setwd("C:/Users/Estudante/Downloads/dados/dados_CE1")
#ver quais arquivos e pastas estao no diretorio
dir()
#pre-leitura dos microdados
readLines("CGIL_CNIg_2024.csv",10)
#Dica: verifique possivel acentuação no arquivo
#lendo o arquivo com a função read.csv2 (ponto e vírgula como separador)
dados <- read.csv2("CGIL_CNIg_2024.csv", fileEncoding = "UTF-8")
# dados <- read.csv2("CGIL_CNIg_2024.csv", fileEncoding = "latin1")
#Outra possibilidade de Encoding: "latin1"

#verificando as primeiras linhas do banco de dados
head(dados, 2)

dim(dados) # dimensões dos dados
nrow(dados) # número de linhas
ncol(dados) # número de colunas

###------------------------------------------
# selecionando linhas e colunas específicas
###------------------------------------------
names(dados) #ver nomes das variaveis
dim(dados)   #ver dimensões do banco de dados (linhas e colunas)

table(dados$andamento) #tabela de frequencias da variavel andamento
dados[1,1]
dados[c(1,5,10),c(2,4)]

#selecionando apenas linhas com andamento 'DEFERIDO'
dados_deferidos <- dados[dados$andamento == "DEFERIDO", ]

#selecionando apenas as colunas 'ano' e 'andamento'
dados_ano_andamento <- dados[, c("ano", "andamento")]

rm(dados_deferidos, dados_ano_andamento, a, b, c, c2)


###------------------------------------------
# Leitura de dados massivos
###------------------------------------------

# install.packages("data.table")
# library(data.table)
# 
# getwd()
# 
# setwd("G:/...")
# dir()
# readLines("CGIL_CNIg_2024.csv", n = 10)
# dados <- fread( "CGIL_CNIg_2024.csv", sep = ";", encoding = "UTF-8",select = c("tipo_visto", "andamento", "amparo_legal", "modalidade"))
# head(dados)
# # Estrutura do banco
# str(dados)


#Resolucao Normativa
table(dados_final$amparo_legal)
#transformar dos dados em factor
levels(as.factor(dados_final$amparo_legal))
#ler a base de RNs
dir()
readLines("RNs_geral_17052025.csv",10)
rns <- read.csv2("RNs_geral_17052025.csv", fileEncoding = "UTF-8")

#verificar se todos os amparos estao na base de RNs
dados_final$amparo_legal%in%rns$amparo_legal
dados_final$amparo_legal[!dados_final$amparo_legal%in%rns$amparo_legal]

#juntar a base de dados com as informacoes de RNs por meio de um 'merge'
dados_final2 <- merge.data.frame(dados_final, rns,
                                 by.x = "amparo_legal",
                                 by.y = "amparo_legal",
                                 all.x = TRUE)

###------------------------------------------
# Criação de um diretório para salvar as saídas
###------------------------------------------
#criar um diretorio para salvar as tabelas
dir()#verifica o que está salvo no diretório
getwd()#verifica qual é o diretório de trabalho atual
dir.create("tabelas_saida")#cria o diretório
setwd("tabelas_saida")#seta o diretório de trabalho para o novo diretório
getwd()#verifica se o diretório foi alterado




