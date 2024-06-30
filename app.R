library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
if(!require("shinydashboard")) {
  install.packages("shinydashboard")
  library(shinydashboard)
} else {
  library(shinydashboard)
}
dados = read.csv('dados_shiny_2022081822.csv')

#altera o tema dos graficos 
theme_set(theme_bw())

options(warn = -1) #impede com que avisos não aparecem no console

ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("idmodelos", label = "Modelos:", choices = sort(unique(dados$MODELO)), selected = "corolla xei 16v"),
      selectizeInput("uf", label="Unidade federativa", choices = sort(unique(dados$UF)), options = list(maxItems=27), selected = "df"),
      sliderInput("ano",label="Ano do automóvel:",min = min(dados$ANO),max = max(dados$ANO),value = 2022, sep = ""),
      checkboxGroupInput("acessorios", label ="Acessórios opcionais", choices = colnames(dados)[seq(27, 36)], inline = T),
      actionButton("consultar", "Consultar")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      textOutput("teste"),
      plotlyOutput("grafico_media_valores"),
      plotlyOutput("variacao_preco_uf"),
      plotlyOutput("variacao_quilometragem_valor_uf"),
      plotlyOutput("frequenia_cambio_automovel"),
      plotlyOutput("frequencia_pelacor"),
      plotlyOutput("frequencia_direcao")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dados_select = eventReactive(input$consultar,{
    
    #modelo = 'corolla xei 16v'
    #uf = c('mt', 'se')

   resultado = dados %>% filter(MODELO == input$idmodelos & UF %in% input$uf)
   
   for (c in input$acessorios) {
     resultado = resultado %>% filter_at(vars(c), all_vars(. ==1))# consegue passar via string para uma variavel
     
   }
   resultado
   
  }, ignoreNULL = F)
  output$teste = renderText({
    paste("DADOS:", dim(dados_select()$UF))
  })

  
  output$grafico_media_valores = renderPlotly({
    
    #VALOR MÉDIO AO LONGO DO TEMPO
    #GRAFICO DE LINHAS
    media_data = dados_select() %>% 
      group_by(DATA_COLETA_METADADOS, UF)%>%
      summarise(mediaValor = mean(VALOR))
    media_data
    
    ggplotly(
      ggplot(data = media_data)+
        geom_line(aes(x = DATA_COLETA_METADADOS, y = mediaValor, group = UF, color = UF, text = paste("Data:", DATA_COLETA_METADADOS, "\n", "Valor da média:", mediaValor)), linewidth  = 1)+
        ggtitle("Média dos valores ao longo do tempo (Mato Grosso e Sergipe)")+
        scale_color_brewer(palette='Dark2'), #adicionando paleta de cores 
      tooltip = c('text')
    )
    
    
  })
  output$variacao_preco_uf = renderPlotly({
    
    #VARIAÇÃO DE PREÇO POR UF
    #valores: minimos, maximos, mediana, media, outlies...
    #BOXPLOT
    ggplotly(
      ggplot(data=dados_select())+
        geom_boxplot(aes(x = UF, y = VALOR, fill = UF))+
        ggtitle("Variação de preço por UF")+
        scale_fill_brewer(palette='Dark2') #adicionando paleta de cores
    )
    
  })
  output$variacao_quilometragem_valor_uf = renderPlotly({
    
    #VARIAÇÃO DA QUILOMETRAGEM, VALOR E UF (ANALISAR A RELAÇÃO)
    #GRAFICO DE DISPERSÃO
    ggplotly(
      ggplot(data = dados_select())+
        geom_point(aes(x=QUILOMETRAGEM, y=VALOR, colour  = UF))+
        ggtitle("Distribuição do VALOR, QUILOMETRAGEM por UF")+
        scale_colour_brewer(palette='Dark2') #adicionando paleta de cores
    )
    
    
  })
  output$frequenia_cambio_automovel = renderPlotly({
    
    #FREQUENCIA RELATIVA DO TIPO DE CAMBIO DOS AUTOMOVEIS
    #grafico de barras vertical, horizontalpara frequencias absolutas ou pizza para frequencias relativas
    #GRAFICO DE PIZZA
    frequencia_cambio <- dados_select()%>% 
      group_by(CÂMBIO) %>%
      summarise(qtd = n()) %>%
      mutate(prop = qtd / sum(qtd) * 100) %>%
      mutate(ypos = cumsum(prop) - 0.5 * prop)
    
    plot_ly(frequencia_cambio, labels=~CÂMBIO, values = ~prop, type = "pie",
            text_info = 'label+percent') %>%  layout(title="Quantidade por Câmbio") 
    
    
  })
  output$frequencia_pelacor = renderPlotly({
    
    #FREQUENCIA POR COR 
    #GRAFICO DE BARRA
    frequencia_absoluta = dados_select() %>% group_by(COR)%>%
      summarise(QTD = n()) #frequencia absoluta
    
    ggplotly(
      ggplot(data = frequencia_absoluta)+
        geom_bar(aes(x = reorder(COR, QTD), y = QTD, fill = QTD, text= paste("COR:", COR,"\n",  "QTD:", QTD)), stat = 'identity')+ #fill = qtd, mostra cor de calor
        xlab('COR')+
        ggtitle("Quantidade por cor"), tooltip = c("text"))
    
    
    
  })
  output$frequencia_direcao = renderPlotly({
    
    #FREQUENCIA POR DIREÇÃO(hidraulica, eletrica, mecanica etc...)
    #GRAFICO DE PIZZA
    freq_direcao = dados_select() %>%
      group_by(DIREÇÃO)%>%
      summarise(qtd = n())%>%
      mutate(prop = qtd/sum(qtd)*100)%>%
      mutate(ypos = cumsum(prop)-0.5*prop)
    
    plot_ly(freq_direcao, labels=~DIREÇÃO, values = ~prop, type = "pie",
            text_info = 'label+percent') %>%  layout(title="Quantidade por Direção") 
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
#-------------------------------------------------------------------------------------------------

