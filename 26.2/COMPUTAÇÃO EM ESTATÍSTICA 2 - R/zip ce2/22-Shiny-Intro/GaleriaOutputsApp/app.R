library(shiny)
library(tidyverse)
library(DT) # Pacote para tabelas interativas

ui <- fluidPage(
  titlePanel("Galeria de Outputs do Shiny"),
  
  sidebarLayout(
    sidebarPanel(
      # Input para selecionar a espécie de flor
      selectInput("species_select", "Filtrar por Espécie:", 
                  choices = c("Todas", levels(iris$Species)),
                  selected = "Todas")
    ),
    
    mainPanel(
      h4("Output: Tabela Interativa (DT)"),
      dataTableOutput("iris_table"), # Espaço para a tabela interativa
      
      hr(),
      
      h4("Output: Gráfico (ggplot)"),
      plotOutput("iris_plot"), # Espaço para o gráfico
      
      hr(),
      
      h4("Output: Texto Reativo"),
      textOutput("summary_text") # Espaço para o texto
    )
  )
)

server <- function(input, output) {
  
  # 1. Criar um objeto de dados reativo
  # Este código será re-executado sempre que input$species_select mudar
  dados_filtrados <- reactive({
    if (input$species_select == "Todas") {
      iris
    } else {
      iris |> filter(Species == input$species_select)
    }
  })
  
  # 2. Renderizar a tabela interativa
  output$iris_table <- renderDataTable({
    datatable(dados_filtrados()) # Usamos dados_filtrados() para acessar os dados
  })
  
  # 3. Renderizar o gráfico
  output$iris_plot <- renderPlot({
    ggplot(dados_filtrados(), aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
      geom_point(size = 3, alpha = 0.7) +
      theme_minimal(base_size = 16) +
      labs(title = "Comprimento vs. Largura da Sépala")
  })
  
  # 4. Renderizar o texto de resumo
  output$summary_text <- renderText({
    n_linhas <- nrow(dados_filtrados())
    paste("A seleção atual contém", n_linhas, "observações.")
  })
}

shinyApp(ui = ui, server = server)