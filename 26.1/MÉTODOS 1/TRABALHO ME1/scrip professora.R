#  *******************************************************************************  
#              Exemplo - Programa R - Intervalo de Confiança           
#             e Testes de Hipóteses para Média e Proporção e Variância            
#  ******************************************************************************* 


# Importando dados
# Para ler arquivo de dados em formato txt
dados <- read.table(file.choose(), header = TRUE)
dados
# Para ler arquivo de dados em formato csv
dados1 <- read.csv2(file.choose(), header = TRUE)
dados1


# Para ler um “resumo” da base de dados, onde será 
# apresentado o nome das variáveis com alguns valores
head(dados1)


# Dimensão da base de dados
dim(dados) 

# Agora vamos ter acesso a cada variável individualmente
sexo <- factor(dados$Sexo)
idade <- dados$Idade
ginst <- factor(dados$g_Instru)
lresid <- factor(dados$l_Resid)
renda <- dados$Renda
renda


# **************************************************************** #
# Intervalo de Confiança e Teste para Media Populacional  #
# **************************************************************** #
summary(idade)
mean(idade)
t.test(idade)

# Indicando a confianca  #
t.test(idade, conf.level=0.9)

# Especificando o valor de mu0  #
t.test(idade, mu=30)

# Especificando a hipotese alternativa  #
# alternative = "two.sided" OU "less" OU "greater"  #
t.test(idade, mu=30,alternative =  "greater" )


# ******************************************************************** #
# Intervalo de Confiança e Teste para Variância Populacional  #
# ******************************************************************** #
summary(idade)
mean(idade