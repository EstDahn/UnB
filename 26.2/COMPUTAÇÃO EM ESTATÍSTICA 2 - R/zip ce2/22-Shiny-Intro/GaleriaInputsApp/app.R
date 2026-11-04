library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("Galeria de Inputs do Shiny"),
  
  fluidRow(
    column(4,
           h4("Seleção"),
           selectInput("var_select", "Escolha uma variável:", choices = names(mtcars)),
           radioButtons("dist_radio", "Distribuição:", choices = c("Normal", "Uniforme", "Log-normal")),
           checkboxInput("show_rug", "Mostrar 'rug plot'?", value = TRUE)
    ),
    column(4,
           h4("Valores Numéricos e de Texto"),
           numericInput("num_obs", "Número de observações:", 30, min = 1, max = 100),
           textInput("plot_title", "Título do Gráfico:", "Meu Título Padrão"),
           sliderInput("alpha_slider", "Transparência (alpha):", min = 0, max = 1, value = 0.5)
    ),
    column(4,
           h4("Datas"),
           dateInput("select_date", "Selecione uma data:"),
           dateRangeInput("date_range", "Selecione um período:")
    )
  ),
  hr(), # Uma linha horizontal para separar
  fluidRow(
    column(12,
           h4("Valores Atuais dos Inputs no Server"),
           verbatimTextOutput("input_values") # Espaço para mostrar os valores
    )
  )
)

server <- function(input, output) {
  output$input_values <- renderPrint({
    # Acessamos os inputs com input$inputId
    str(list(
      Variavel_Selecionada = input$var_select,
      Distribuicao = input$dist_radio,
      Mostrar_Rug = input$show_rug,
      Numero_Obs = input$num_obs,
      Titulo = input$plot_title,
      Alpha = input$alpha_slider,
      Data_Unica = input$select_date,
      Periodo = input$date_range
    ))
  })
}

shinyApp(ui = ui, server = server)