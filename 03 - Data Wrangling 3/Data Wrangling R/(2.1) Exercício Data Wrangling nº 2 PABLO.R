## Data Wrangling R
## MBA DSA USP ESALQ

# Prof. Wilson Tarantin Junior

# Atividade de Análise nº 2 - Dataset WDI World Bank
# O dataset contém muitos indicadores sobre o desenvolvimento dos países
# https://databank.worldbank.org/source/world-development-indicators

# Importando os pacotes
library(readxl)
library(tidyverse)

# Importando o banco de dados
dataset_wdi <- read_excel("(2.2) WDI World Bank.xlsx")

# Informações básicas do banco de dados
dim(dataset_wdi)
glimpse(dataset_wdi)

# O dataset está estruturado de modo que, para cada país, existem várias linhas
# Cada linha representa um tipo de indicador existente na fonte consultada
# Da forma como está, é difícil realizar análises com tais indicadores

# Vamos analisar um pouco melhor o conteúdo do dataset:
unique(dataset_wdi$`Country Name`)
unique(dataset_wdi$`Series Name`)
#Prints que aparecem no console
options(max.print = 3000)
unique(dataset_wdi$`Series Name`) # após ajuste, aparecem todos os indicadores
unique(dataset_wdi$`Topic`)

# Temos informações para o ano de 2021 em muitos indicadores de vários tópicos
# Também podemos notar que existem missing values marcados como ".."

# Para facilitar, vamos iniciar simplificando os nomes das colunas
dataset_wdi <- dataset_wdi %>% 
  rename(pais = 1,
         cod_pais = 2,
         serie = 3,
         cod_serie = 4,
         ano_2021 = 5,
         topico = 6)

# Nota-se que as últimas linhas do banco de dados não são observações
# Vamos limpar de forma simples, selecionando as linhas válidas 
dataset_wdi <- dataset_wdi[1:383572,]

glimpse(dataset_wdi)

# Temos um problema com a variável que contém as informações de 2021
# Ela está no formato de caracteres, provavelmente, devido aos missings ".."

# Vamos utilizar o "mutate" em conjunto com a função "na_if"
# "na_if" substitui determinada informação por NAs

dataset_wdi <- dataset_wdi %>% 
  mutate(ano_2021 = na_if(ano_2021, ".."))

# Os dois pontos foram substituídos, mas a variável ainda é texto

dataset_wdi <- dataset_wdi %>% 
  mutate(ano_2021_aj = as.double(ano_2021)) %>% 
  select(-ano_2021)

glimpse(dataset_wdi)

# Na prática, a parte do na_if não seria necessária neste caso
# O própio as.double já converteria, por coerção, os ".." em NAs

# Vamos continuar organizando o dataset, colocando em uma estrutura mais prática

unique(dataset_wdi$topico)

# Vamos supor que o objetivo seja analisar informações do tópico "saúde"
# Existem vários tópicos sobre saúde, mas com diversos subtópicos
# Vamos filtrar todos os tópicos sobre saúde utilizando "str_detect"
# A seguir, vamos pedir todos os tópicos que começam com "saúde"

dataset_wdi_saude <- dataset_wdi %>% 
  filter(str_detect(topico, "^Health"))

unique(dataset_wdi_saude$topico)

# Neste momento, já temos um dataset mais ajustado

# Porém, uma estrutura mais interessante seria colocar as séries nas colunas
# Assim, elas se tornariam variáveis e teríamos uma linha para cada país

# Uma função que pode ser utilizada, parte do tidyverse (tidyr), é "pivot_wider"

dataset_wdi_saude_wide <- pivot_wider(dataset_wdi_saude,
                                      id_cols = c("pais", "cod_pais"),
                                      names_from = "serie",
                                      values_from = "ano_2021_aj")

# Pode ser útil manter os tópicos de cada variável, por exemplo:

dataset_wdi_saude_final <- pivot_wider(dataset_wdi_saude,
                                       id_cols = c("pais", "cod_pais"),
                                       names_from = c("topico", "serie"),
                                       values_from = "ano_2021_aj")

# ATENÇÃO: na prática, seria fundamental ajustar os nomes das variáveis!

# Algumas variáveis estão sem informações para todas as observações
# Vamos retirar utilizando o purrr

dataset_wdi_saude_final <- dataset_wdi_saude_final %>%
  purrr::discard(~ all(is.na(.)))

# Por fim, vamos adicionar a categoria "income group" ao dataset

income <- read_excel("(2.3) WDI Income Group.xlsx")

income <- income %>% 
  select(Code, `Income Group`) %>% 
  rename(cod_pais = Code)

dataset_wdi_saude_final <- dataset_wdi_saude_final %>% 
  left_join(income, by = "cod_pais") %>% 
  relocate(`Income Group`, .after = cod_pais)

# A partir deste banco de dados, seria possível iniciar as análises

# FIM!