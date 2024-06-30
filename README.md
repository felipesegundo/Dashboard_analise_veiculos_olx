# Dashboard_analise_veiculos_olx
## Acesso à aplicação aqui: https://89zvv1-felipe-alexandre.shinyapps.io/app_shiny_2/
A aplicação apresentada é um dashboard interativo desenvolvido com Shiny, uma biblioteca do R usada para criar aplicativos web interativos. Esse dashboard é voltado para análise de dados de vendas de automóveis, permitindo que o usuário filtre e visualize informações específicas sobre veículos.

### Objetivo do Dashboard
O objetivo principal do dashboard é permitir que os usuários consultem e analisem dados de vendas de automóveis com base em vários critérios, como modelo, unidade federativa (UF), ano do automóvel e acessórios opcionais. A partir dessas seleções, o dashboard gera uma série de gráficos interativos que apresentam insights sobre os dados filtrados.

### Componentes do Dashboard
1. Interface do Usuário (UI)
A interface do usuário (UI) é construída usando fluidPage e dashboardPage, criando uma estrutura de layout intuitiva. Os componentes principais da UI incluem:

Título da Aplicação: "Old Faithful Geyser Data".
Barra Lateral: Permite que o usuário selecione:
Modelo do automóvel (selectInput).
Unidade federativa (selectizeInput).
Ano do automóvel (sliderInput).
Acessórios opcionais (checkboxGroupInput).
Botão de consulta (actionButton).
Painel Principal: Exibe os gráficos e as informações geradas com base nos filtros selecionados.
2. Lógica do Servidor (Server)
A lógica do servidor processa as entradas do usuário e gera os gráficos necessários. Os principais componentes incluem:

Filtragem dos Dados: Utilizando a função eventReactive, os dados são filtrados conforme os critérios de seleção fornecidos pelo usuário.
Geração de Gráficos:
Gráfico de Linha: Mostra a média dos valores ao longo do tempo por UF.
Boxplot: Exibe a variação de preço por UF.
Gráfico de Dispersão: Analisa a relação entre quilometragem e valor por UF.
Gráfico de Pizza: Mostra a frequência relativa dos tipos de câmbio e direção dos automóveis.
Gráfico de Barras: Apresenta a quantidade de automóveis por cor.
3. Estrutura do Dashboard
A estrutura do dashboard é organizada utilizando shinydashboard:

### Cabeçalho: Título "VENDAS DE AUTOMÓVEIS".
### Barra Lateral: Componentes de filtro e ação para consultar os dados.
Corpo da Página: Composto por diversas fluidRow e box que contêm os gráficos gerados.
### Funções de Análise
Média dos Valores ao Longo do Tempo: Permite visualizar como os preços médios dos automóveis variam ao longo do tempo para diferentes UFs.
Variação de Preço por UF: Analisa a distribuição dos preços dos automóveis em diferentes estados.
Distribuição do Valor e Quilometragem: Explora a relação entre a quilometragem dos veículos e seus preços por estado.
Frequência Relativa dos Tipos de Câmbio: Mostra a proporção de veículos com diferentes tipos de câmbio.
Quantidade por Cor: Exibe a frequência de veículos com base em suas cores.

Frequência por Direção: Mostra a proporção de veículos com diferentes tipos de direção (hidráulica, elétrica, mecânica).
Este dashboard é uma ferramenta poderosa para análise detalhada de vendas de automóveis, fornecendo aos usuários uma visão abrangente dos dados de mercado com capacidade de filtragem e visualização interativa.






