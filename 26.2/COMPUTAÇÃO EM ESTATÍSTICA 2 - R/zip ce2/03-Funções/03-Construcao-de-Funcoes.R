# --- Script de Aula: Construção de Funções em R ---
# Autor: Prof. Donald M. Pianto
# Objetivo: Demonstrar a criação de funções em R, desde exemplos simples
#           até funções de análise de dados mais complexas e robustas.

# --- 0. Carregar Pacotes ---
# Vamos carregar os pacotes que usaremos na aula.
# Certifique-se de que eles estão instalados.
# install.packages("tidyverse")
# install.packages("gapminder")

library(tidyverse)
library(gapminder)


# --------------------------------------------------------------------------
# --- Exemplo 1: Uma Função Simples (`maxminratio`) ---
# --------------------------------------------------------------------------
# Vamos começar com um exemplo simples para calcular a razão entre o valor
# máximo e mínimo de um vetor numérico.

# -- Passo 1: A Função Básica --
# Uma função de uma linha é a forma mais simples de começar.
maxminratio <- function(x) {
  max(x) / min(x)
}

# Testando a função com um vetor simples
meu_vetor <- c(1, 2, 5, 10)
maxminratio(meu_vetor)

# Podemos usar esta função com `apply` para aplicá-la a cada coluna de uma matriz.
minha_matriz <- matrix(1:12, ncol = 3)
apply(minha_matriz, 2, maxminratio)


# -- Passo 2: Introduzindo um Problema (Valores `NA`) --
# O que acontece se o nosso vetor de entrada tiver um valor ausente (`NA`)?
vetor_com_na <- c(1, 2, 5, 10, NA)
maxminratio(vetor_com_na)
# A função retorna NA. Para torná-la mais útil, podemos adicionar um argumento
# para lidar com valores ausentes.


# -- Passo 3: Adicionando um Argumento com Valor Padrão --
# Tornamos a função mais robusta e flexível, permitindo que o usuário
# decida como lidar com os NAs.
maxminratio <- function(x, na.rm = FALSE) {
  max(x, na.rm = na.rm) / min(x, na.rm = na.rm)
}
# - `na.rm = FALSE`: Este é o valor padrão. Se o usuário não especificar
#   nada, a função se comportará como antes.
# - `na.rm = na.rm`: Passamos o valor do nosso argumento `na.rm` para as
#   funções `max()` e `min()`.

# Agora, a função é muito mais útil:
# Comportamento padrão (ainda retorna NA)
maxminratio(vetor_com_na)

# Novo comportamento (ignora o NA)
maxminratio(vetor_com_na, na.rm = TRUE)


# --------------------------------------------------------------------------
# --- Exemplo 2: Uma Função de Análise de Dados ---
# --------------------------------------------------------------------------
# Agora, vamos construir uma função mais completa para analisar os dados
# do `gapminder` para um país específico.

# -- Passo 1: O Esqueleto da Função e a Lógica Principal --
# Começamos definindo o nome, os argumentos e a lógica principal, que
# é filtrar os dados e retorná-los.
analisar_pais_v1 <- function(pais, anos = unique(gapminder$year)) {
  
  dados_filtrados <- gapminder |>
    filter(country == pais, year %in% anos)
  
  return(dados_filtrados)
}

# Testando a primeira versão
dados_brasil <- analisar_pais_v1(pais = "Brazil", anos = c(1997, 2002, 2007))
print(dados_brasil)


# -- Passo 2: Tratamento de Erros (Validação de Entradas) --
# Uma função robusta deve verificar suas entradas e falhar de forma
# controlada e informativa. Usamos `if` e `stop()` para isso.
analisar_pais_v2 <- function(pais, anos = unique(gapminder$year)) {
  
  # 1. Verificar se o país existe
  if (!pais %in% unique(gapminder$country)) {
    stop("País não encontrado. O nome do país precisa estar em inglês!")
  }
  
  # 2. Verificar se todos os anos existem
  if (!all(anos %in% unique(gapminder$year))) {
    stop("Ano não disponível.")
  }
  
  # Lógica principal (como antes)
  dados_filtrados <- gapminder |>
    filter(country == pais, year %in% anos)
  
  return(dados_filtrados)
}

# Testando o tratamento de erros (use `try()` para ver a mensagem sem parar o script)
try(analisar_pais_v2(pais = "Brasil"), silent = TRUE)
try(analisar_pais_v2(pais = "Brazil", anos = c(2007, 2008)), silent = TRUE)


# -- Passo 3: Saídas Múltiplas, Condicionais e o Argumento `...` --
# Uma função pode fazer mais do que apenas retornar um objeto. Ela pode
# imprimir mensagens (efeitos colaterais) e criar gráficos condicionalmente.
# O argumento `...` (dots) permite passar argumentos para outras funções internas.

analisar_pais_final <- function(pais, 
                                anos = unique(gapminder$year), 
                                gerar_grafico = TRUE,
                                ...) { # Adicionamos o argumento ...
  
  # Validação de Entradas (como antes)
  if (!pais %in% unique(gapminder$country)) {
    stop("País não encontrado. O nome do país precisa estar em inglês!")
  }
  if (!all(anos %in% unique(gapminder$year))) {
    stop("Ano não disponível.")
  }
  
  # Lógica Principal
  dados_filtrados <- gapminder |>
    filter(country == pais, year %in% anos)
  
  # --- Saídas ---
  
  # 1. Mensagem no console (efeito colateral)
  pop_pais_2007 <- gapminder$pop[gapminder$country == pais & gapminder$year == 2007]
  continente_pais <- unique(gapminder$continent[gapminder$country == pais])
  pop_continente_2007 <- sum(as.numeric(gapminder$pop[gapminder$continent == continente_pais & gapminder$year == 2007]))
  percentual_pop <- (pop_pais_2007 / pop_continente_2007) * 100
  
  cat(
    paste0("Em 2007, ", pais, " respondia por ", 
           round(percentual_pop, 2), "% da população do continente.\n")
  )
  
  # 2. Gráfico condicional (efeito colateral)
  if (gerar_grafico) {
    plot_vida <- ggplot(dados_filtrados, aes(x = year, y = lifeExp)) +
      geom_line(color = "blue", linewidth = 1) +
      geom_point(color = "red", size = 3) +
      labs(
        title = paste("Expectativa de Vida em", pais),
        x = "Ano",
        y = "Expectativa de Vida"
      ) +
      theme_minimal() +
      labs(...) # Passamos o argumento ... para o labs()
    
    print(plot_vida)
  }
  
  # 3. Valor de retorno
  return(dados_filtrados)
}

# Testando a função final
# Chamada padrão
analisar_pais_final("Argentina", anos = c(1982, 1992, 2002))

# Chamada personalizada com o argumento `...` para customizar o gráfico
analisar_pais_final("Argentina", anos = c(1982, 1992, 2002),
                    subtitle = "Período de redemocratização e crises",
                    caption = "Fonte: Pacote gapminder")


# --------------------------------------------------------------------------
# --- Exercício de Aula: Coeficiente de Variação ---
# --------------------------------------------------------------------------
# O coeficiente de variação (CV) é uma medida de dispersão relativa,
# definida como o desvio padrão dividido pela média: CV = sd(x) / mean(x).

# Tarefa:
# 1. Parte A: Crie uma função `coef_variacao(x)` que calcule o CV.
# 2. Parte B: Modifique a função para que ela aceite um argumento `na.rm = FALSE`
#    e o passe para as funções `sd()` e `mean()`.
# 3. Teste sua função com os vetores abaixo.

vetor_a <- c(10, 12, 15, 18, 20)
vetor_b <- c(10, 12, 15, 18, 20, NA)

# Escreva a sua função aqui


# Teste a sua função aqui
# coef_variacao(vetor_a)
# coef_variacao(vetor_b)
# coef_variacao(vetor_b, na.rm = TRUE)
