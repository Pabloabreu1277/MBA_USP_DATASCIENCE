
# Introdução ao Software R
# MBA DSA USP ESALQ
# Prof. Wilson Tarantin Junior

#------------------- Apresentação do R e RStudio -------------------------------

# R é a linguagem de programação que vamos utilizar
# RStudio é um software que torna a utilização do R mais simples para o usuário

# A interface do RStudio divide-se em 4 grandes partes, principalmente para:

# 1ª Parte: script com o histórico de códigos daquele projeto ou análise
# 2ª Parte: console onde os códigos podem ser digitados e são implementados
# 3ª Parte: environment onde ficam listados os objetos
# 4ª Parte: onde aparecem outputs, help de pacotes, arquivos da pasta atual

# Sempre que iniciar uma nova análise, sugere-se criar um "project"

# File -> New Project -> New Directory -> New Project -> Nome do Projeto

# O project cria uma pasta, o que facilita a organização e o compartilhamento
# Também ajuda na importação de dados no RStudio

#------------------- Estrutura básica de operação do R -------------------------

# Normalmente, utiliza-se um script para guardar o histórico das análises

# File -> New File -> R Script

# Vamos conhecer as operações fundamentais do R

1 + 1
10 - 2
25 * 2
100 / 10
3 ^ 2
sqrt(25)

# Para executar um comando do script, posicione o cursor e clique "ctrl+enter"
# Também é possível digitar os comandos diretamente no console

# O R possui uma linguagem básica, muitas vezes chamada de R Base (Base R)
# Entretanto, os desenvolvimentos ocorrem por meio de "pacotes"
# Tais pacotes precisam ser instalados antes do uso, por exemplo:

install.packages("tidyverse")

# O comando acima, install.packages(), instalou o pacote "tidyverse"
# Assim é feito com pacotes que serão utilizados, mas ainda não foram instalados

# Quando for utilizar o pacote, é necessário carregá-lo com a função library()

library(tidyverse)

# Após rodar este comando, as funções do tidyverse já podem ser utilizadas

# Um parêntese: perceba que os textos, neste script, se iniciam com #
# Os códigos são digitados diretamente e são identificados como comandos
# Se digitarmos os textos diretamente, o R identificará um erro
# Da mesma forma, se um comando estiver incorreto, um erro aparecerá

# O R funciona com base em objetos que ficam listados no environment

# Vamos conhecer os objetos iniciando pelos vetores
# Os vetores mais simples são os atômicos (numéricos; caracteres; lógicos)

numeros <- c(1, 2, 3, 4, 5)

# Acima, criamos um objeto chamado "numeros" que é um vetor numérico
# Para criar o "numeros", utilizamos o indicador <- para atribuir os valores
# O atalho para gerar a atribuição é "alt -" juntos
# A função c() indica que estamos concatenando (combinando) valores em um vetor

# Neste momento, é importante entendermos o objetivo das funções
# As funções indicam a ação que deve executada pelo R
# No caso acima: pedimos que o R combinasse - c() - os números em um vetor
# Portanto, as funções são algoritmos que executam uma ação pré-estabelecida
# Um aspecto comum é que muitas funções demandam mais de um argumento

# Uma ferramenta de ajuda importante é o Help do RStudio
# Coloque o cursor sobre uma função e aperte F1: surge o Help daquela função
# O Help é relevante, pois mostra a documentação da função (e seus argumentos)

# Ao escrever o nome do objeto no console (ou no script), o objeto é "printado"

numeros

# Os comandos são "case sensitive", isto é, diferenciam maiúsculas e minúsculas 

Numeros # note que houve um erro, não existe o objeto Numeros (maiúscula)

# Também não são aceitos caracteres especiais no nome de objetos
# Uma dica é não complicar no nome dos objetos (evitar maiúsculas, acentos...)
# Outra é não utilizar nomes muito parecidos com nomes de funções já existentes

# Seguindo com as funções, poderíamos utilizar o comando print()

print(numeros)

# Vamos criar um vetor com textos, isto é, com caracteres:

pessoas <- c("João", "Maria", "Pedro", "Paula")

# Agora, foi criado um vetor de textos que foram colocados entre aspas duplas

pessoas

# Também poderíamos criar um vetor com argumentos lógicos, TRUE ou FALSE

logico <- c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE)

# Igualmente válido:

logico_2 <- c(T, F, T, T, F, F)

# Note que tais argumentos não são textos, estão definidos como lógicos
# Para saber a classe de vetor, é possível utilizar:

class(numeros)
class(pessoas)
class(logico)

# Para saber o comprimento do vetor, é possível utilizar:

length(numeros)
length(pessoas)
length(logico)

# Cada objeto tem seu nome e não há nomes iguais no ambiente

sequencia <- c(1:10) # esta é uma forma de gerar uma sequência de números

# Se atribuir o mesmo nome a outro objeto, o objeto antigo é substituído

sequencia <- c(500:600)

# Existem vetores que guardam informações de variadas classes:

varios_1 <- c(1, 2, 3, "Azul", "Verde", "Vermelho", TRUE, FALSE, TRUE)

class(varios_1)
print(varios_1)

# O R atribui a classe "caracteres" a este vetor, ou seja, tornaram-se textos
# Isto ocorre, pois a prioridade estabelecida pelo R é a seguinte:
# 1º Textos, 2º Números, 3º Argumentos lógicos

varios_2 <- c(425, 426, 427, TRUE, FALSE, FALSE)

class(varios_2)
print(varios_2)

# Agora, como há somente números e lógicos, o R transforma TRUE = 1 e FALSE = 0
# Tais procedimentos são chamados de coerção

# É possível realizar operações com os vetores. A seguir, alguns exemplos:
# Observe os operadores comumente utilizados na linguagem R

numeros == 1
numeros * 2
triplo_numeros <- numeros * 3
metade_numeros <- numeros / 2

pessoas != "João"

sequencia > 550
sequencia >= 598
sequencia > 100
sequencia <= 100

# Há outros tipos de vetores, agora vamos conhecer os fatores:

# Fatores: contêm variáveis categóricas com os possíveis valores estipulados
# A seguir, para criar um fator, vamos utilizar o c() dentro da função factor()
# A função factor() tem dois argumentos adicionais: levels e labels

altura <- factor(c("alto", "médio", "alto", "baixo", "médio", "alto"), 
                levels = c("baixo", "médio", "alto"),
                labels = c("prédios baixos",
                           "prédios médios",
                           "prédios altos"))

class(altura)

altura

# No caso dos fatores, a variável, inclusive, pode estar indicada como numérica

respostas <- factor(c(1, 2, 2, 3, 1, 2, 3, 3, 1, 2, 1, 1, 3, 2, 3),
                    levels = c(1, 2, 3),
                    labels = c("discordo totalmente",
                               "não concordo, nem discordo",
                               "concordo totalmente"))

class(respostas)

respostas

# Note que a sequência de levels e labels é a correta, isto é, mantém a ordem

# Outro tipo de objeto bastante relevante na análise de dados são os data frames

# Data frames: são os objetos que guardam informações como nas bases de dados
# Assim, nos data frames estão colunas (variáveis) e linhas (observações)

banco_dados_um <- data.frame(var1 = c("pessoa 1", "pessoa 2", "pessoa 3"),
                             var2 = c(42, 55, 28))

print(banco_dados_um)

# Note que foi criado um objeto do tipo "Data" no ambiente do RStudio

# Na função data.frame as variáveis devem ter o mesmo comprimento
# Vamos adicionar 3 vetores para formar o dataset

variavel_um <- c(1:10)
variavel_dois <- c(11:18, NA, NA)
variavel_tres <- c("a","b","c","d","e","f","g","h","i","j")

banco_dados_dois <- data.frame(variavel_um, variavel_dois, variavel_tres)

# No caso acima foi adicionado um argumento relevante: NA
# O NA é a indicação do dado "não disponível", isto é, missing value
# Note que o NA não é texto

# Vamos criar o banco de dados com nomes diferentes para as variáveis

banco_dados_tres <- data.frame(posicao = variavel_um,
                               faltam = variavel_dois,
                               letras = variavel_tres)

#------------------- Importando dados ------------------------------------------

# Até o momento, criamos internamente os objetos utilizados
# Agora, vamos importar um tipo de objeto fundamental, as bases de dados

# Inicialmente, vamos importar um arquivo da própria extensão do R (.RData)
# A seguir, temos dados relacionados ao desempenho escolar de 2.000 pessoas
# Fonte dos dados: Fávero & Belfiore (2017, Capítulo 16)

load("(2) desempenho_aluno_escola.RData")

# Também podemos importar um arquivo em Excel (utilizando o readxl - tidyverse)
# A seguir, temos dados com a cotação de fechamento mensal de 4 ações

library(readxl)
preco <- read_excel("(2) precos_acao.xlsx")

# Outro formato bastante comum é o (.csv)
# A seguir, vamos importar dados do Banco Mundial sobre o crescimento do PIB
# Fonte dos dados: https://databank.worldbank.org/

pib_paises <- read.csv("(2) pib_paises.csv",
                       sep = ",",
                       dec = ".")

# Os argumentos adicionados nesta função foram:
# O separador (,) e a indicação de decimais (.)

# Uma ferramenta interessante é a coleta dos dados diretamente nos links
# Cotação do dólar comercial (venda e compra) - cotações diárias
# Fonte: Banco Central do Brasil

dolar <- read.csv("https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarPeriodo(dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@dataInicial='12-31-2021'&@dataFinalCotacao='12-31-2022'&$top=10000&$format=text/csv&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao",
                  sep = ",")

# Os argumentos são: a indicação do link e o separador das variáveis (,)

# Por fim, note que o RStudio também auxilia na importação das bases de dados
# Em environment, clique no botão de "Importar"

# ATENÇÃO: se surgir uma caixa de diálogo para a instalação do pacote, aceite
# Pode surgir na primeira vez que utiliza o assistente de importação

# Note que há opção para importar arquivos de outros softwares

# Por exemplo, vamos importar um arquivo do SPSS (.sav)
# Os dados contêm as notas de 100 alunos em 4 disciplinas distintas
# Fonte dos dados: Fávero & Belfiore (2017, Capítulo 10)

#------------------- Salvando dados no R ---------------------------------------

# Se alterarmos as bases, podemos exportar os bancos de dados utilizados

# Salvando em .RData

save(banco_dados_um, file = "(3) dados_salvos_1.RData")

# Salvando em Excel:

install.packages("writexl")
library("writexl")

write_xlsx(banco_dados_dois,"(3) dados_salvos_2.xlsx")

# Salvando em .csv

write.csv(banco_dados_tres, file = "(3) dados_salvos_3.csv", row.names = F)

#------------------- Conceitos básicos de manipulação de dados -----------------

# A manipulação dos dados consiste em organizar as variáveis e observações
# Na grande maioria dos casos, as bases de dados precisam ser preparadas

# Vamos utilizar como exemplo a base de dados de desempenho dos alunos

load("(2) desempenho_aluno_escola.RData") # Se já estiver carregada, não precisa

View(desempenho_aluno_escola)

# Vamos olhar apenas a parte inicial do banco de dados (10 primeiras linhas)

head(desempenho_aluno_escola, n = 10)

# Quais são os nomes das variáveis disponíveis?

names(desempenho_aluno_escola)

# Ao todo, quantas variáveis e quantas observações existem no banco de dados?

nrow(desempenho_aluno_escola) # observações (linhas)
ncol(desempenho_aluno_escola) # variáveis (colunas)
dim(desempenho_aluno_escola) # ambos juntos (linhas, colunas)

# Qual é a estrutura do banco de dados?

str(desempenho_aluno_escola)

# Em algumas funções, certas vezes, pode ser necessário especificar uma variável
# Indicaremos o nome_objeto_dados$variável

desempenho_aluno_escola$desempenho # Somente o print da variável

horas_estudo <- desempenho_aluno_escola$horas # Armazenando em um vetor

# Para remover um objeto do ambiente, pode ser feito da seguinte forma:

rm(horas_estudo)

# É possível localizar informações do banco de dados da seguinte forma:
# O primeiro argumento é o número da linha e, após a vírgula, a posição da coluna 

# Qual é o valor do desempenho escolar (variável na 3ª coluna) do 1º aluno?
desempenho_aluno_escola[1 , 3]

# Quais são os valores de todas as variáveis do 5º aluno?
desempenho_aluno_escola[10 , ]

# Quais são os valores de todas as variáveis para os alunos de 7 a 12?
desempenho_aluno_escola[c(7:12), ]

# Quais são as observações para a variável da 6ª coluna (tipo de escola?)?
desempenho_aluno_escola[ , 6]

# No caso acima, também poderia ser indicada pelo nome da variável
desempenho_aluno_escola[ , "priv"]

# Poderíamos reorganizar a ordem das variáveis
reorganiza <- desempenho_aluno_escola[ , c(2,5,3,4,1,6)]

# Vamos armazenar somente as variáveis estudante (id), desempenho e horas
parte_dados <- desempenho_aluno_escola[ , c("estudante", "desempenho", "horas")]

# As variáveis "horas" e "tempo de experiência" poderiam ser excluídas
novos_dados_1 <- desempenho_aluno_escola[ , -c(4,5)]

# Supondo que não vamos analisar as linhas de 476 até 522
novos_dados_2 <- desempenho_aluno_escola[ -c(476:522), ]

# Também é possível filtrar observações por meio dos operadores:
# Alguns operadores úteis para realizar filtros:

"== igual"
"> maior"
">= maior ou igual"
"< menor"
"<= menor ou igual"
"!= diferente"
"& indica e"
"| indica ou"

desempenho_aluno_escola[desempenho_aluno_escola$desempenho > 50,]

desempenho_aluno_escola[desempenho_aluno_escola$priv == "pública",]

teste_escolas_pub<-desempenho_aluno_escola[desempenho_aluno_escola$priv == "pública" &
                        desempenho_aluno_escola$desempenho <= 20,]
teste_escolas_priv<- desempenho_aluno_escola[desempenho_aluno_escola$priv == "privada" &
                          desempenho_aluno_escola$desempenho <= 20,]

desempenho_aluno_escola[desempenho_aluno_escola$escola != "A",]

seleciona_escolas <- desempenho_aluno_escola[desempenho_aluno_escola$escola == "C" |
                                             desempenho_aluno_escola$escola == "H",]

# A seguir, vamos trabalhar no banco de dados do PIB dos países

pib_paises <- read.csv("(2) pib_paises.csv",
                       sep = ",",
                       dec = ".")

# Excluir variáveis que não utilizaremos
# Ao mesmo tempo, vamos excluir as últimas linhas (267 até 271)
#linha e coluna

pib_paises <- pib_paises[-c(267:271),-c(2,4)]

# Vamos alterar os nomes das variáveis

nomes <- c("ano","paises_regioes","var_pib_capita","var_pib_total")
names(pib_paises) <- nomes

head(pib_paises)

# Note que as variáveis que devem ser numéricas vieram como textos
# Vamos criar novas variáveis contendo os valores

pib_paises$var_pib_capita_ajust <- as.numeric(pib_paises$var_pib_capita)
pib_paises$var_pib_total_ajust <- as.numeric(pib_paises$var_pib_total)

#excluir colunas com formatação errada

pib_paises<-pib_paises[,-c(3,4)]

# Utilizamos, em conjunto, a função "as.numeric"

# Um detalhe: note que apareceram "warnings" - este não é erro, é informação!

# Por fim, podemos gerar algumas estatísticas descritivas das duas variáveis

summary(pib_paises$var_pib_capita_ajust)
summary(pib_paises$var_pib_total_ajust)

#------------------- Funções e iterações ---------------------------------------

# Referência: R for Data Science - (https://r4ds.had.co.nz/functions.html)

# Uma função é uma forma de simplificar um código
# É adequada sempre que for necessário repetir o mesmo código várias vezes
# Então, funções automatizam tarefas que seriam repetitivas
# Permite que sejam criados e nomeados objetos contendo tais funções

# Reduzir a duplicidade de códigos é importante, pois:
# Facilita a visualização (leitura do código)
# Facilita a mudança do código, caso necessário
# Evita erros durante a duplicação do código

# Para criar uma função, existem três etapas básicas:
# 1. Nomear a função
# 2. Indicar os argumentos (inputs) da função (ficam dentro de function(x, y))
# 3. Indicar o código, a função, que será implementado (fica dentro do {})

# Exemplo: todo dia atualizamos milhares de valores somando 17 e dividindo por 2
# Ao invés de repetir a mesma conta toda vez, poderíamos criar uma função:

atualizar <- function(histórico) {
  atual <- ((histórico + 17)/2)
  return(atual)
}

# O input é o que nomeamos de "histórico", isto é, o valor que vamos atualizar
# O "atual" é o nome que demos ao código que será implementado (a função)
# O "return" é o que queremos que a função retorne, isto é, o valor atualizado

atualizar(1)
atualizar(2)
atualizar(3)
atualizar(4)

# Ainda menos repetitivo, poderíamos criar um vetor com todos os valores
# Em seguida, o vetor entra como input na função para retornar todos os valores

atualizar_hoje <- c(1:15)

atualizar(atualizar_hoje)

# Inclusive, poderíamos guardar os resultados em um objeto

atualizados <- atualizar(atualizar_hoje)

print(atualizados)

# Poderíamos ter uma função com mais de um input. Por exemplo

ajustar <- function(valor1, valor2) {
  ajuste <- ((valor1 + 180)/(valor2 - 60))
  return(ajuste)
}

ajustar(100, 80)
ajustar(200, 80)
ajustar(200, 100)

# Neste contexto de funções, as condições "if, else if e else" são importantes
# Primeiramente, estabelecemos a condição entre parênteses
# Entre as primeiras chaves, vamos estabelecer o resultado caso if = TRUE
# Na sequência, estabelecemos o else, ou seja, o restante caso if = FALSE

valor <- 100000

if (valor >= 1000000) {
  "número grande"
} else {
  "número pequeno"
}

# Também poderíamos ter múltiplos critérios utilizando o "else if"

valor <- 650000

if (valor >= 1000000) {
  "número grande"
} else if (valor >= 500000 & valor <1000000) {
  "número intermediário"
} else {
  "número pequeno"
}

# É possível integrar condições ("if") às funções apresentadas anteriormente
# Voltando ao exemplo, vamos supor que atualizamos valores só até o limite 100
# Valores que seriam atualizados acima dele, ficam no limite estabelecido = 100

# Adicionamos o if (condição) {o que retornar quando for satisfeita}
# Na sequência, o else {o que retornar quando NÃO for satisfeita}

atualizar_teto <- function(histórico) {
  atual <- ((histórico + 17)/2)
  if (atual <= 100) {
    return(atual)}
  else {
    return("Atualizado no Teto = 100")}
}

atualizar_teto(44)
atualizar_teto(199)

# Do mesmo modo, é possível adicionar múltiplas condições às funções ("else if")

ajustar_mult <- function(valor1, valor2) {
  ajuste <- ((valor1 + 180)/(valor2 - 60))
  if(ajuste <= 100) {
    return("baixo")}
  else if(ajuste > 100 & ajuste <= 1000) {
    return("médio")}
  else {
    return("alto")}   
}

ajustar_mult(500, 300) # resultado = 2,8333
ajustar_mult(50000,100) # resultado = 1.254,50
ajustar_mult(1000, 70) # resultado = 118

# Nos exemplos acima, criamos nossas funções que utilizamos em cada código 
# Porém, também poderíamos utilizar funções já existentes
# Ou seja, o código pode conter uma grande diversidade de funções já existentes

médias <- function(x) {
  media <- mean(x, na.rm = T)
  return(media)
}

valores <- c(1, 4, 6, 9, 12, 16)

médias(valores)

# A seguir, vamos analisar o funcionamento do "for()" e do "while()"

# Retomando o trabalho de atualizar valores diariamente, podemos usar o for()

for (i in atualizar_hoje) {
  print((i + 17)/2)
}

# Interpretação: para todo valor i que consta no vetor "atualizar_hoje"
# Faça o print do resultado (valor i + 17)/2

# Também poderíamos salvar os resultados em uma lista

resultados <- list()

for (i in atualizar_hoje) {
  resultados[[i]] <- ((i + 17)/2)
}

# Assim, em outro momento, poderíamos buscar um valor em particular da lista

resultados[[5]]

# Ou mesmo a lista toda

resultados

# O while() permite que seja adicionada uma condição do tipo "enquanto"

valores <- 2

while(valores < 100){
  valores <- (valores + 20)
  print(valores)
}

# Interpretação: enquanto o resultado de valores for menor do que 100, some 20

# A seguir, além de realizar o while(), os resultados são armazenados no vetor

novos_result <- c()

valores <- 2

while(valores < 100){
  valores <- (valores + 20)
  novos_result <- c(novos_result, valores)
  print(valores)
}

print(novos_result)

# Portanto, funções e iterações são ferramentas que podem facilitar a escrita

#------------------- Data Visualization ----------------------------------------

# Para a visualização de dados, vamos utilizar principalmente o pacote "ggplot2"

# O "ggplot2" é um pacote para a criação de gráficos integrante do tidyverse  
# (https://ggplot2.tidyverse.org/)
# O ggplot2 foi instalado ao instalar o tidyverse. Agora, basta carregá-lo

library(ggplot2) # Obs.: se já tiver carregado o tidyverse, não precisa fazê-lo

# Os códigos para a criação dos mais diversos tipos de gráficos são semelhantes
# Em essência, muda-se a "geometria" do gráfico -> geometria = tipo de gráfico
# Muitos dos argumentos adicionais são ajustes e formatações
# Dada a necessidade da análise, escolhe-se o tipo de gráfico e sua "geom"

# Além do ggplot2, a seguir, outros pacotes que podem ser úteis:

install.packages(c("plotly","reshape2","ggrepel","rgl","car","sf","esquisse"))

options(rgl.debug = TRUE)

library(plotly)
library(reshape2)
library(ggrepel)
library(rgl)
library(car)
library(sf)
library(esquisse)

# --- Gráfico de Barras ---

# Vamos começar analisando uma variável qualitativa, o perfil do investidor

load("(2) perfil_investidor.RData")

# Como é uma variável categórica, vamos criar um gráfico de barras (geom_bar)
# Neste caso, o gráfico apresentará a contagem em cada categoria da variável
# Note que no "aes" (aesthetics) entra como argumento a variável de interesse

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil))

# Poderíamos mudar a ordem de apresentação reorganizando os níveis da variável

perfil_investidor$perfil <- factor(perfil_investidor$perfil,
                                   levels = c("Conservador", 
                                              "Moderado", 
                                              "Agressivo"))

# O novo gráfico seria:

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil))

# Conforme indicado, muitos dos argumentos adicionais são ajustes e formatações
# Vamos adicionar novas legendas ao gráfico

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil)) +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020")

# Vamos alterar a cor das barras (argumento "fill")

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil), fill = "blue") +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020")

# As possíveis cores disponíveis na linguagem base podem ser consultadas

colours()

# Vamos adicionar bordas às barras (argumento "color")

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil), color = "red", fill = "blue") +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020")

# Vamos alterar o fundo do gráfico (theme)

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil), color = "red", fill = "blue") +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020") +
  theme_light()

# Um aspecto importante é que podemos adicionar mais de uma geometria ao gráfico
# Vamos adicionar um texto (geom_text) contendo os valores que foram contados

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil), color = "red", fill = "blue") +
  geom_text(aes(x = perfil, label = ..count..), stat = "count", vjust = 2) +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020") +
  theme_light()

# Também poderíamos apresentar o gráfico com os eixos invertidos

ggplot(data = perfil_investidor) +
  geom_bar(aes(x = perfil), color = "red", fill = "blue") +
  geom_text(aes(x = perfil, label = ..count..), stat = "count", hjust = -1) +
  labs(title = "Perfil dos Investidores",
       subtitle = "Banco X",
       x = "Perfil do Investidor",
       y = "Quantidade",
       caption = "Período: 2020") +
  coord_flip() +
  theme_light()

# --- Histograma ---

# A seguir, vamos elaborar o histograma de notas dos alunos (desempenho escolar)
# O banco de dados é o mesmo que já utilizamos anteriormente

load("(2) desempenho_aluno_escola.RData")

# Iniciando com o gráfico básico (geom_histogram)

ggplot(data = desempenho_aluno_escola) +
  geom_histogram(aes(x = desempenho))

# Vamos adicionar algumas formatações

ggplot(data = desempenho_aluno_escola) +
  geom_histogram(aes(x = desempenho), color = "black", fill = "light green") +
  labs(x = "Desempenho Escolar",
       y = "Frequência") +
  theme_bw()

# Algumas vezes pode ser importante formatar a quantidade de barras apresentadas

ggplot(data = desempenho_aluno_escola) +
  geom_histogram(aes(x = desempenho), color = "black", fill = "light green", bins = 50) +
  labs(x = "Desempenho Escolar",
       y = "Frequência") +
  theme_bw()

# --- Gráfico de Pontos ---

# Na sequência, vamos elaborar um gráfico de dispersão dos pontos
# Os dados são do atlas ambiental sobre distritos da cidade de São Paulo

load("(2) atlas_ambiental.RData")

# Iniciando com o gráfico básico (geom_point)
# Neste caso, devemos especificar as variáveis dos eixos x e y no "aes"

ggplot(atlas_ambiental) +
  geom_point(aes(x = renda, y = escolaridade))

# Como há variáveis nos dois eixos, podemos adicionar outras variáveis:

# Na forma de tamanho dos pontos ("size")

ggplot(atlas_ambiental) +
  geom_point(aes(x = renda, y = escolaridade, size = idade))

# Na forma de cores dos pontos ("color")

ggplot(atlas_ambiental) +
  geom_point(aes(x = renda, y = escolaridade, size = idade, color = favel < 6))

# Na próprio formato dos pontos ("shape")

ggplot(atlas_ambiental) +
  geom_point(aes(x = renda, y = escolaridade, 
                 size = idade, color = favel < 6, 
                 shape = mortalidade > 18)) +
  labs(title = "Indicadores dos Distritos do Município de São Paulo",
       x = "Renda",
       y = "Escolaridade") +
  theme_bw()

# Também é possível plotar valores fitted no gráfico

ggplot(atlas_ambiental) +
  geom_point(aes(x = renda, y = escolaridade, 
                 size = idade, color = favel < 6, 
                 shape = mortalidade > 18)) +
  geom_smooth(aes(x = renda, y = escolaridade), method = "loess", se = FALSE) +
  labs(title = "Indicadores dos Distritos do Município de São Paulo",
       x = "Renda",
       y = "Escolaridade") +
  theme_bw()

# --- Gráfico de Linhas ---

# Vamos elaborar um gráfico de linhas (geom_line) para dados ao longo do tempo
# Neste caso, vamos utilizar o banco de dados com preços de ações

library(readxl)
preco_acao <- read_excel("(2) precos_acao.xlsx")

# Como temos 4 ações no banco de dados, vamos implementar o seguinte gráfico
# Note que vamos separar cada empresa por meio da cor do gráfico

ggplot(preco_acao) +
  geom_line(aes(x = data, y = preco, color = acao))

# Vamos formatar um pouco mais o gráfico

ggplot(preco_acao) +
  geom_line(aes(x = data, y = preco, color = acao)) + 
  labs(x = "Mês de Referência",
       y = "Cotação de Fechamento",
       title = "Série Histórica das Ações",
       color = "Empresa") +
  theme_classic()

# Além disto, vamos adicionar os pontos com os valores da série (geom_point)

ggplot(preco_acao) +
  geom_line(aes(x = data, y = preco, color = acao)) + 
  geom_point(aes(x = data, y = preco, color = acao)) +
  labs(x = "Mês de Referência",
       y = "Cotação de Fechamento",
       title = "Série Histórica das Ações",
       color = "Empresa") +
theme_classic()

# Adicionar os labels dos pontos dentro do gráfico se torna inviável
# Veja o resultado:

ggplot(preco_acao) +
  geom_line(aes(x = data, y = preco, color = acao)) + 
  geom_point(aes(x = data, y = preco, color = acao)) +
  geom_text(aes(x = data, y = preco, label = preco), size = 3, vjust = 2, angle = 45) + 
  labs(x = "Mês de Referência",
       y = "Cotação de Fechamento",
       title = "Série Histórica das Ações",
       color = "Empresa") +
theme_classic()

# Para tornar o gráfico mais interativo, vamos usar o ggplotly
# Basta indicar com o cursor do mouse o ponto para ver informações

ggplotly(
ggplot(preco_acao) +
  geom_line(aes(x = data, y = preco, color = acao)) + 
  geom_point(aes(x = data, y = preco, color = acao)) +
  labs(x = "Mês de Referência",
       y = "Cotação de Fechamento",
       title = "Série Histórica das Ações",
       color = "Empresa") +
  theme_classic()
)

# --- Gráfico de Calor ---

# Vamos gerar um gráfico de calor que distingue informações por meio de cores
# O banco de dados contém informações sobre o tempo para chegar à escola
# Fonte: Fávero & Belfiore (2017, Capítulo 12)

library(readxl) # Se já tiver carregado antes, não precisa fazer novamente
tempo_dist <- read_excel("(2) tempo_dist.xls")

# Vamos trabalhar o gráfico de calor no contexto das correlações entre variáveis
# Portanto, primeiramente, vamos criar a matriz de correlações (função "cor")
# Lembrando: selecionar apenas as variáveis quantitativas da base de dados

correlacoes <- cor(tempo_dist[, 2:4])

correlacoes

# Algumas vezes, é necessário utilizar a base de dados em formatos específicos
# Neste caso, vamos colocar os valores das correlações como uma variável
# Para tanto, será aplicada a função "melt"

correlacoes_reorg <- melt(correlacoes)

View(correlacoes_reorg)

# Agora vamos elaborar um gráfico de calor (geom_tile) com algumas formatações

ggplot(correlacoes_reorg) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) + 
  labs(x = "Variáveis",
       y = "Variáveis",
       fill = "Coef. Correl.")

# Poderíamos trocar as cores para facilitar a visualização
# Ao mesmo tempo, vamos adicionar rótulos aos dados

ggplot(correlacoes_reorg) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) + 
  geom_text(aes(x = Var1, y = Var2, label = value), size = 5) +
  labs(x = "Variáveis",
       y = "Variáveis",
       fill = "Coef. Correl.") +
  scale_fill_gradient2(low = "blue", 
                       mid = "yellow", 
                       high = "red",
                       midpoint = 0)

# Por fim, podemos deixar o gráfico mais interativo com a função "ggplotly"

ggplotly(
ggplot(correlacoes_reorg) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) + 
  geom_text(aes(x = Var1, y = Var2, label = value), size = 5) +
  labs(x = "Variáveis",
       y = "Variáveis",
       fill = "Coef. Correl.") +
  scale_fill_gradient2(low = "blue", 
                       mid = "yellow", 
                       high = "red",
                       midpoint = 0)
)

# --- Gráficos Boxplot ---

# O boxplot apresenta medidas de posição das variáveis
# Mínimo, máximo, 1º quartil, mediana e 3º quartil
# Vemos a distribuição dos dados nas variáveis e eventuais outliers univariados

# Inicialmente, vamos apresentar o boxplot de uma única variável

load("(2) atlas_ambiental.RData")

var_boxplot <- atlas_ambiental[,c(1,3)]

ggplot(var_boxplot) +
  geom_boxplot(aes(y = renda), fill = "gray", color = "blue") +
  labs(x = "Renda",
       y = "Valores")

# Vamos torná-lo mais informativo com o ggplotly

ggplotly(
ggplot(var_boxplot) +
  geom_boxplot(aes(y = renda), fill = "gray", color = "blue") +
  labs(x = "Renda",
       y = "Valores")
)

# Por fim, vamos utilizar a ferramenta Esquisse
# Basicamente, é uma ferramenta interativa para a criação de gráficos
# Vamos ver algumas funcionalidades

esquisser(atlas_ambiental, viewer = "browser")

# Fim!
