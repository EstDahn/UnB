# --- Script de Aula: Revisão de Funções Básicas em R ---
# Autor: Prof. Donald M. Pianto
# Objetivo: Fazer uma revisão rápida de subsetting de dados e controle de
#           fluxo como preparação para a aula de construção de funções.

# --- 0. Carregar Pacotes ---
# Vamos carregar os pacotes que usaremos na revisão.
# Certifique-se de que eles estão instalados.
# install.packages("tidyverse")
# install.packages("dados")

library(tidyverse)
library(dados)


# --------------------------------------------------------------------------
# --- Exercício 1: Revisão de Subsetting com `dplyr` ---
# --------------------------------------------------------------------------
# Em quase todas as funções que escrevemos para análise de dados, o primeiro
# passo é selecionar um subconjunto de dados que nos interessa. A forma mais
# comum de fazer isso é usando a função `filter()` do pacote `dplyr`.

# Vamos usar o conjunto de dados `dados::pinguins` para esta revisão.
glimpse(pinguins)

# Tarefa:
# Escreva um pipeline `dplyr` que use o dataset `pinguins` e filtre os
# dados para encontrar apenas os pinguins que atendam a TODAS as
# seguintes condições:
#
# 1. Sejam da espécie "Adelie".
# 2. Tenham uma massa corporal (`massa_corporal`) superior a 4000g.
# 3. Foram observados na ilha "Torgersen".
#
# Atribua o resultado a uma variável chamada `pinguins_filtrados`.

# --- Solução do Exercício 1 ---
pinguins_filtrados <- pinguins |>
  filter(
    especie == "Adelie",
    massa_corporal > 4000,
    ilha == "Torgersen"
  )

# Imprima o resultado para verificar
print(pinguins_filtrados)


# --------------------------------------------------------------------------
# --- Exercício 2: Revisão de Controle de Fluxo com `if`/`else` ---
# --------------------------------------------------------------------------
# Outra tarefa fundamental na programação é fazer o código tomar decisões
# com base em certas condições. A estrutura `if`/`else` é o principal
# bloco de construção para isso.

# Tarefa:
# Considere a variável `x` abaixo. Escreva uma estrutura `if`/`else` que
# verifique se `x` é maior que 10.
#
# - Se a condição for verdadeira, o código deve imprimir a mensagem:
#   "A variável é maior que 10."
# - Caso contrário (se for menor ou igual a 10), o código deve imprimir:
#   "A variável não é maior que 10."
#
# Use a função `cat()` para imprimir as mensagens.

x <- 15

# --- Solução do Exercício 2 ---
if (x > 10) {
  cat("A variável é maior que 10.\n")
} else {
  cat("A variável não é maior que 10.\n")
}


# --------------------------------------------------------------------------
# --- Ponte para a Próxima Etapa: Construção de Funções ---
# --------------------------------------------------------------------------
# Ótimo. Estes exercícios mostram que vocês já dominam as ferramentas
# básicas para selecionar dados e controlar o fluxo do código.
#
# Agora, imagine o seguinte:
#
# - E se você precisasse filtrar os pinguins por diferentes espécies e
#   massas corporais várias vezes ao longo da sua análise? Você copiaria
#   e colaria o código do `filter()` repetidamente?
#
# - E se você precisasse verificar se diferentes variáveis são maiores
#   que 10? Você copiaria e colaria o bloco `if`/`else`?
#
# Copiar e colar código é ineficiente e propenso a erros. A solução para
# isso é encapsular essas operações em uma ferramenta reutilizável.
# A isso, em R, chamamos de **criar uma função**.
#
# É isso que começaremos a fazer na segunda parte da nossa aula de hoje.
