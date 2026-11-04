library(tidyverse)


leitores = read.csv2("leitores.csv")
desempenho = read.csv2("desempenho.csv")
vendas = read.csv2("vendas.csv")
mundo = read.csv2("mundo.csv")


#EXERCÍCIO 3-------------------------------------
#Faz a tabela de contingencia
table(leitores$Grau_instrucao,leitores$Jornal)

#EXERCÍCIO 6-------------------------------------

gráfico <- ggplot(mundo, aes(x = URBANA, y = PIBCAPIT)) +
  geom_point() +
  geom_smooth(method = "lm")
gráfico

# Pearson
pearson <- cor(mundo$URBANA, mundo$PIBCAPIT, method = "pearson")
# Spearman
spearman <- cor(mundo$URBANA, mundo$PIBCAPIT, method = "spearman")
cat("Pearson:", pearson, "\nSpearman:", spearman)

#d)-----------------------------------------------
ggplot(mundo, aes(x = URBANA, y = PIBCAPIT)) +
  geom_point() +
  scale_y_continuous(trans = "log10")
#e)-----------------------------------------------
mundo$LOG_PIB <- log(mundo$PIBCAPIT + 1)
modelo_log <- lm(LOG_PIB ~ URBANA, data = mundo)
summary(modelo_log)

n = nrow(newmundo) #Numero de observações

mundo <- mundo %>%  #novas colunas com valores pra calcular
  mutate("XeY" = URBANA * LOG_PIB, "XQuadrado" = URBANA**2)
tibble(mundo)

newmundo <- mundo %>% #selecionar apenas oq interessa pro calculo da reta
  select(URBANA, LOG_PIB,XQuadrado, XeY )

#calculo dos valores de alpha e beta pra reta de regressão
alpha <-(((n*sum(newmundo$XeY))-(sum(newmundo$URBANA)*sum(newmundo$LOG_PIB)))
           /(n*sum(newmundo$XQuadrado))-sum(newmundo$URBANA)**2))
names(alpha) <- "ALPHA"
alpha

beta <- mean(newmundo$LOG_PIB) - alpha * mean(newmundo$URBANA)
names(beta) <- "BETA"
beta

#calcular pela função pronta
reta <- lm(formula = LOG_PIB ~ URBANA , data = newmundo)
reta

#f)------------------------------------------------

ValorEmX <- 50 #alterar pro valor buscado

Y50 <- 0.00421*ValorEmX+5.2322
Y50

gráficoLOG <- ggplot(newmundo,aes(URBANA, LOG_PIB)) +
  geom_point() +
  geom_smooth(method = "lm")

gráficoLOG #gráfico Y em LOG
gráfico #gráfico y normal
log(ValorEmX) #valor aproximado do LOG


#QUESTÃO 7)----------------------------------------

Dados7 <- data.frame("região" = c("SP", "RJ", "BELÉM", "BH", "SALVA", "PA", "RECIFE","FORTA"),
                     "primario" = c(2.0,2.5,2.9,3.3,4.1,4.3,7.0,13.0),
                     "indice"= c(17.5,18.5,19.5,22.2,26.5,16.6,36.6,38.4))
Dados7

#a)------------------------------------------------

ggplot(Dados7, aes(primario,indice)) +
  geom_point()

#b)------------------------------------------------

cor( x = Dados7$primario, y = Dados7$indice ) #correlação de pearson

Dados7_filtrado <- Dados7 %>% 
  filter( região != "PA") 

cor( x = Dados7_filtrado$primario,
     y = Dados7_filtrado$indice ) #pearson sem porto alegre

#c)------------------------------------------------

lm(formula = indice ~ primario, data = Dados7_filtrado) # reta de regressão

#y = 2.017 * X + 15.574 + erro






