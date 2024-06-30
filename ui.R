
source("app.R")

# ESTRUTURA DO DASHBOARD
cabecalho = dashboardHeader(title = "VENDAS DE AUTOMÓVEIS")
barra_lateral = dashboardSidebar(fluidRow(
  column(width=12, 
         selectInput("idmodelos", label = "Modelos:", choices = sort(unique(dados$MODELO)), selected = "corolla xei 16v")
),
  column(width=12, 
         selectizeInput("uf", label="Unidade federativa", choices = sort(unique(dados$UF)), options = list(maxItems=27), selected = "df")
),
  column(width=12,
         sliderInput("ano",label="Ano do automóvel:",min = min(dados$ANO),max = max(dados$ANO),value = 2022, sep = "") 
),
  column(width=12,
         checkboxGroupInput("acessorios", label ="Acessórios opcionais", choices = colnames(dados)[seq(27, 36)], inline = T)  
         
),
  column(width=12,
         actionButton("consultar", "Consultar", class = "btn-success")  
)
))


corpo_pagina = dashboardBody(
  fluidRow(
    infoBox(title="", subtitle = "Registros", value = nrow(dados), color = "navy"),
    
    infoBox(title="", subtitle = "Modelos Disponíveis", value = length(unique(dados$MODELO)), color = "red"),
    
    infoBox(title="", subtitle = "UFs Registradas", value = length(unique(dados$UF)), color = "yellow")
            
            
),

  

  fluidRow(
    column(width = 12, box(width = '100%',
                           column(width = 8, plotlyOutput("grafico_media_valores")),  
                           column(width = 4, plotlyOutput("variacao_preco_uf"))   
    ))
  ),
  fluidRow(
   column(width=12, box(width="100%", 
                        column(width=6, plotlyOutput("variacao_quilometragem_valor_uf")),
                        column(width=6, plotlyOutput("frequenia_cambio_automovel"))
))),
  fluidRow(
    column(width=12, box(width="100%",
                      column(width = 6, plotlyOutput("frequencia_pelacor")),
                      column(width = 6, plotlyOutput("frequencia_direcao"))
                      
                      
)))
)




dashboardPage(header = cabecalho, sidebar = barra_lateral, body = corpo_pagina)