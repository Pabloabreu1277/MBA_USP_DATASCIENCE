# Baixa pacotes

library("httr")
library("rvest")

# Busca dados na internet - rvest
#Página: https://en.wikipedia.org/wiki/Web_scraping

#função de leitura
wikipedia <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

#busca tag de título
wikipedia %>% html_elements("title")
wikipedia %>% html_elements("label")%>% html_text()


#busca nó de heading, mas tira parte do código HTML
wikipedia %>% html_elements("h1") %>% html_text()

#busca nó de parágrafo, mas tira parte do código HTML
data <- wikipedia %>% html_elements("p") %>% html_text()


length(data)

data[2]

# Busca dados específicos em uma web page - rvest

#Vamos olhar a página: https://en.wikipedia.org/wiki/Web_scraping

library("rvest")

#função de leitura
wikipedia <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

#Busca específico 
# "FAQ about linking – Are website terms of use binding contracts?".
body_text <- wikipedia %>% html_elements("#cite_note-5") %>% html_text()
body_text

substr(body_text, start = 1, stop = 20)

substr(body_text, start = 21, stop = nchar(body_text))

#Busca item listado
techniques <- wikipedia %>% html_elements("#Techniques") %>% html_text()
techniques

#Vamos olhar a página http://www.r-datacollection.com/materials/html/OurFirstHTML.html

library("httr")

#Usa método GET()
website <- GET("http://www.r-datacollection.com/materials/html/OurFirstHTML.html")

#Visualiza como texto
content(website, "text")

# Busca dados específicos em uma API IBGE - httr

library("rvest")
library("httr")
library("jsonlite")
library("data.table")

#Mostra API de países do IBGE
#https://servicodados.ibge.gov.br/api/docs/paises

#Parâmetros
#country = "BR"

#1 - Listagem de Países - mostra na página web

url = "https://servicodados.ibge.gov.br/api/v1/paises/BR"

page_data <- GET(url)

page_data$status_code

rawToChar(page_data$content)

fromJSON(rawToChar(page_data$content))

result <- fromJSON(rawToChar(page_data$content))


#2 - Indicadores - mostra na página web

url2 = "https://servicodados.ibge.gov.br/api/v1/paises/BR|US"

page_data2 <- GET(url2)

#tipo de arquivo
http_type(page_data2)

jsonText <- content(page_data2, "text")
jsonText

jsonParsed <- content(page_data2, "parsed")
jsonParsed
