##############################################################################
# Carregar o pacote mlbench (se ainda não estiver instalado)
# install.packages("mlbench")
library(mlbench)

# Carregar a base de dados Housing
data(BostonHousing)

# Visualizar as primeiras linhas da base de dados
head(BostonHousing)

# Desenvolva o seu modelo livremente (de preferência dentro do que vimos em aula) e venha preparado na próxima aula
# A nossa variável resposta aqui é o MEDV, que é o valor mediano do imóvel
# Tente fazer um modelo que indique o valor mediano de um imóvel dadas as características da região
#######################################
# Dicionário de dados:
#######################################

# CRIM: Taxa de criminalidade per capita por região.
# ZN: Proporção de terrenos residenciais divididos em lotes com mais de 25.000 pés quadrados (cerca de 2.322 metros quadrados).
# INDUS: Proporção de acres não comerciais por cidade.
# CHAS: Variável fictícia (dummy) que indica se o imóvel faz fronteira com o rio Charles (1 se faz fronteira, 0 caso contrário).
# NOX: Concentração de óxidos nítricos (partes por 10 milhões).
# RM: Média de número de quartos por habitação.
# AGE: Proporção de unidades ocupadas pelos proprietários construídas antes de 1940.
# DIS: Distância ponderada até cinco centros de emprego em Boston.
# RAD: Índice de acessibilidade a rodovias radiais.
# TAX: Taxa de imposto sobre propriedades de valor total por $10.000.
# PTRATIO: Razão aluno-professor por cidade.
# B: 1000(Bk - 0.63)^2, onde Bk é a proporção de pessoas de origem afro-americana por cidade.
# LSTAT: Porcentagem de status inferior da população.
# MEDV: Valor mediano das residências ocupadas pelos proprietários em milhares de dólares.



# Fique à vontade para usar as funções que vimos
# Fique à vontade para consultar as inteligências que quiser, naturais ou não
