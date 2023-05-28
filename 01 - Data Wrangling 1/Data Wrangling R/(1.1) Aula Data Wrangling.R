
## Data Wrangling R
## MBA DSA USP ESALQ

# Prof. Wilson Tarantin Junior

# Atividade de Análise nº 1 - Introdução ao pacote dplyr
# https://dplyr.tidyverse.org/

# O pacote dplyr está contido no tidyverse
# dplyr: contém muitas funções comuns na manipulação de dados

# Se for a primeira vez que utiliza o tidyverse, instale-o
# Vamos instalar o pacote de leitura em excel
# Também já vamos instalar um pacote que utilizaremos no RMarkdown

install.packages("tidyverse")
install.packages("readxl")
install.packages("knitr")

# Se já instalou para análises anteriores, basta carregar o pacote

library("tidyverse")

#--------------------Importar os datasets---------------------------------------

# Dois datasets serão utilizados na apresentação central dos tópicos:
# "dataset_inicial" - Fonte: Fávero & Belfiore (2017, Cap. 12)
# "dataset_merge" - utilizado em análises futuras, mas já podemos importá-lo

# Como estão em Excel, vamos importá-los da seguinte forma:

library(readxl)

dataset_inicial <- read_excel("(1.2) Dataset Aula Data Wrangling.xls")
dataset_merge <- read_excel("(1.3) Dataset Aula Data Wrangling (Join).xls")

#--------------------Visualização-----------------------------------------------

# Algumas formas para visualizar informações do dataset

View(dataset_inicial) # Mostra a base de dados completa em uma nova aba
head(dataset_inicial, n=5) # Mostra as 5 primeiras observações da base de dados
str(dataset_inicial) # Mostra a estrutura da base de dados
glimpse(dataset_inicial) # Função parecida com a str
print(dataset_inicial) # Apresenta a base de dados no console
dim(dataset_inicial) # As dimensões do dataset: linhas e colunas, respectivamente
names(dataset_inicial) # Para ver os nomes das variáveis

# Poderíamos fazer o print de apenas uma variável
# O símbolo "$" é utilizado para especificar uma variável do dataset

dataset_inicial$`Tempo para chegar à escola (minutos)`

# Relembrando algumas definições sobre as variáveis:

# Variáveis <Chr> são caracteres ("characters"), isto é, contêm textos
# Variáveis <dbl> são "doubles", isto é, contêm números
# Variáveis <int> são integers, isto é, contêm números inteiros

#--------------------Rename-----------------------------------------------------

# Função "rename": utilizada para alterar o nome das variáveis

# No dataset de exemplo, os nomes das variáveis contêm:
# Espaços, maiúsculas, acentos e caracteres especiais...
# É melhor não utilizá-los, podem gerar conflito e dificultam a escrita

# Inicialmente, sem utilizar a função, poderíamos fazer da seguinte forma:
# 1º:Combinamos os novos nomes desejados em um vetor

novos_nomes <- c("Observações",
                 "Tempo para chegar",
                 "Distância percorrida",
                 "Semáforos",
                 "Período",
                 "Perfil")

print(novos_nomes)

# 2º: Em seguida, atribuimos o vetor com nomes ao dataset

names(dataset_inicial) <- novos_nomes

head(dataset_inicial, n=5)

# A função "rename" torna este trabalho mais prático
# A seguir, o argumento da função é: novo nome = nome antigo

nova_base <- rename(dataset_inicial, 
                    observacoes = "Observações",
                    tempo = "Tempo para chegar",
                    distancia = "Distância percorrida",
                    semaforos = "Semáforos",
                    periodo = "Período",
                    perfil = "Perfil")

head(nova_base, n=5)

# Existe uma forma um pouco diferente de escrever as funções no R
# Trata-se do uso do operador pipe - %>% - atalho: Ctrl+Shift+M
# Com ele, tiramos o primeiro argumento do código
# É muito útil para realizar diversas funções em sequência

nova_base %>% rename(obs = observacoes,
                     temp = tempo,
                     dist = distancia,
                     sem = semaforos,
                     per = periodo,
                     perf = perfil) 

# No código acima, não criamos um novo objeto, mas poderíamos criar

nova_base_pipe <- nova_base %>% 
  rename(obs = observacoes,
         temp = tempo,
         dist = distancia,
         sem = semaforos,
         per = periodo,
         perf = perfil)

# Note que um novo objeto foi criado no ambiente do R

head(nova_base_pipe, n=5)

rm(nova_base_pipe) # Remove o objeto especificado do ambiente

# Também é possível utilizar a função "rename" com base na posição da variável
# Em datasets com muitas variáveis, esta função facilita a escrita do código

nova_base %>% rename(obs = 1,
                     temp = 2,
                     dist = 3,
                     sem = 4,
                     per = 5,
                     perf = 6)

# É possível alterar apenas uma ou outra variável

nova_base %>% rename(sem = 4,
                     perf = 6)

#--------------------Mutate-----------------------------------------------------

# Função "mutate": apresenta duas utilidades principais
# 1. Inclui variáveis no dataset, mantendo as existentes
# 2. Transforma o conteúdo das variáveis

# Numa primeira situação, são adicionados duas variáveis a um dataset existente 
# As observações no dataset e nas variáveis devem estar igualmente ordenadas

variavel_nova_1 <- c(1,2,3,4,5,6,7,8,9,10)
variavel_nova_2 <- c(11:20)
print(variavel_nova_1)
print(variavel_nova_2)

base_inclui <- mutate(nova_base,
                      variavel_nova_1, 
                      variavel_nova_2)
View(base_inclui)

# Podemos utilizar o operador %>% para criar uma nova base (alterando nomes)
# E, no mesmo código, vamos inserir as duas "variáveis novas"
# Também criaremos a variável "temp_novo" como função de outra variável da base

nova_base %>% 
  rename(obs = observacoes,
         temp = tempo,
         dist = distancia,
         sem = semaforos,
         per = periodo,
         perf = perfil) %>%
  mutate(variavel_nova_1,
         variavel_nova_2,
         temp_novo = temp*2)

# ATENÇÃO: na etapa do mutate, a variável já se chama "temp"
# O nome original foi alterado na etapa do "rename"

# A função "mutate" também pode tranformar as variáveis existentes no dataset
# Vamos supor que gostaríamos de transformar a variável "semáforos" em texto
# Para isto, podemos utilizar a função "replace"
# Vamos substituir todos os valores da variável, mas poderiam ser só alguns

base_texto_1 <- mutate(nova_base, 
                       semaforos = replace(semaforos, semaforos==0, "Zero"),
                       semaforos = replace(semaforos, semaforos==1, "Um"),
                       semaforos = replace(semaforos, semaforos==2, "Dois"),
                       semaforos = replace(semaforos, semaforos==3, "Três"))

head(base_texto_1)

# Em conjunto com o mutate, também pode ser utilizada a função "recode"
# Vamos iniciar substituindo números por textos

base_texto_2 <- mutate(nova_base,
                       semaforos = recode(semaforos,
                                          `0` = "Zero",
                                          `1` = "Um", 
                                          `2` = "Dois",
                                          `3` = "Três"))

head(base_texto_2)

# A seguir, trocaremos um texto por outro texto e criaremos uma nova variável

base_texto_3 <- mutate(nova_base, 
                       perfil_novo = recode(perfil,
                                            "calmo" = "perfil 1",
                                            "moderado" = "perfil 2",
                                            "agressivo" = "perfil 3"))

head(base_texto_3)

# Poderíamos manter na variável original (ao invés de criar "perfil_novo")

# Vamos utizar o "recode" para transformar um texto em valores

base_texto_valores <- mutate(nova_base,
                             periodo = recode(periodo,
                                              "Manhã" = 0,
                                              "Tarde" = 1))

head(base_texto_valores)

# Um código semelhante poderia ser utilizado para gerar dummies (var. binárias)

base_dummy <- mutate(nova_base, perfil_agressivo = recode(perfil,
                                                          "agressivo"=1,
                                                          "moderado"=0,
                                                          "calmo"=0),
                                perfil_moderado = recode(perfil,
                                                          "agressivo"=0,
                                                          "moderado"=1,
                                                          "calmo"=0),
                                perfil_calmo = recode(perfil,
                                                       "agressivo"=0,
                                                       "moderado"=0,
                                                       "calmo"=1))

View(base_dummy)

# ATENÇÃO: há funções mais diretas para criar dummies, esta acima é para prática
# Criando variáveis binárias (dummies) por meio de função específica

install.packages("fastDummies")
library("fastDummies")

base_dummy_2 <- dummy_columns(.data = nova_base,
                              select_columns = c("periodo",
                                                 "perfil"),
                              remove_selected_columns = F,
                              remove_first_dummy = F)

# Algumas vezes, é necessário utilizar o mutate para critérios mais detalhados
# Para critérios mais complexos, a função case_when pode ser mais adequada

base_categorias <- mutate(nova_base,
                          categorias_tempo = case_when(tempo <= 20 ~ "Rápido",
                                                       tempo > 20 & tempo <= 40 ~ "Intermediário",
                                                       tempo > 40 ~ "Demorado"))

View(base_categorias)

# Por fim, também é possível deletar colunas com o mutate
# Para isto, vamos utilizar o operador NULL

base_categorias <- mutate(base_categorias,
                          tempo = NULL)

#--------------------Transmute--------------------------------------------------

# Função "transmute": inclui variáveis no dataset, excluindo as existentes
# Depois de informar o dataset, informe as variáveis mantidas e adicionadas

base_exclui_1 <- transmute(nova_base,
                           observacoes, tempo,
                           variavel_nova_1, variavel_nova_2)

# Podemos praticar um pouco mais com o pipe

base_exclui_rename <- nova_base %>% 
  transmute(observacoes, tempo, variavel_nova_1) %>% 
  mutate(tempo_novo = recode(tempo,
                             `10` = "dez",
                             `15` = "quinze",
                             `20` = "vinte",
                             `25` = "vinte e cinco",
                             `30` = "trinta",
                             `35` = "trinta e cinco",
                             `40` = "quarenta",
                             `50` = "cinquenta",
                             `55` = "cinquenta e cinco")) %>% 
  mutate(posicao = cut(tempo, 
                       breaks = c(0, median(tempo), Inf),
                       labels = c("menores", "maiores")))

# Para referência do cálculo, a mediana da amostra

median(nova_base$tempo)

# Utilizamos a função "cut", que converte uma variável de valores em intervalos
# No exemplo acima, pedimos 2 intervalos tendo a mediana como referência
# Em seguida, já adicionamos novos nomes aos intervalos (labels)
# Note que a variável resultante é uma "factor"

# Ao aplicar a função "summary" à variável factor, o resultado é uma contagem
# summary: gera estatísticas descritivas para variáveis

summary(base_exclui_rename$posicao)

#--------------------Select-----------------------------------------------------

# Função "select": tem a finalidade principal de extair variáveis selecionadas 
# Também pode ser utilizada para reposicionar as variáveis no dataset

# Relembrando, sem utilizar a função, poderia ser feito:

selecao_1 <- nova_base[,c("observacoes","tempo")] # critérios após a vírgula
selecao_2 <- nova_base[,1:3] # selecionando pela posição das colunas de 1 a 3
selecao_3 <- nova_base[,c(1:3, 5)] # pulando posições

# É possível selecionar parte do dataset (incluindo a seleção de linhas):
# Linhas antes da vírgula, colunas após a vírgula

extrai_parte_1 <- nova_base[3:7, c("observacoes", "perfil")]
extrai_parte_2 <- nova_base[3:7, 1:2]

# Função "select" utilizada para selecionar e manter variáveis no dataset
# Portanto, seleciona as variáveis que devem ficar no dataset

base_select_1 <- select(nova_base, observacoes, tempo) # especificando
base_select_2 <- select(nova_base, -perfil, -semaforos) # todas menos algumas
base_select_3 <- select(nova_base, observacoes:distancia) # de uma a outra
base_select_4 <- select(nova_base, starts_with("per")) # para algum início comum
base_select_5 <- select(nova_base, ends_with("o")) # para algum final comum

# Reposicionar variáveis do dataset com "select"

nova_base %>% select(observacoes, perfil, everything())

# O mesmo trabalho poderia ser feito com a função "relocate"

nova_base %>% relocate(perfil, .after = observacoes)
nova_base %>% relocate(perfil, .before = tempo)

# A seguir, com "select", informaremos a ordem (inclusive, excluindo variáveis)

nova_base %>% select(tempo, semaforos, perfil, observacoes)

# A função "pull" executa trabalho semelhante ao "select", porém gera um vetor

vetor_pull <- nova_base %>% 
  pull(var = 3)

#--------------------Summarise--------------------------------------------------

# Função "summarise": função que resume o dataset, podendo criar outros
# Abaixo, as observações da variável "tempo" são resumidas em descritivas

descritivas_nova_base <- summarise(nova_base,
                                   observações = n(),
                                   média = mean(tempo),
                                   mediana = median(tempo),
                                   desv_pad = sd(tempo),
                                   mínimo = min(tempo),
                                   máximo = max(tempo),
                                   quartil_3 = quantile(tempo, probs = 0.75))

print(descritivas_nova_base)

# Então, acima, criamos um data frame com uma linha de descritivas da variável

# Poderia ser utilizada para criar informações mais específicas sobre o dataset
# Para isto, o "summarise" é utilizado em conjunto com a função "group by"
# A seguir, vamos agrupar as informações do dataset pelo critério de "período"

base_grupo <- group_by(nova_base, periodo)

# Aparentemente, nada mudou na "base_grupo" em relação à "nova_base"

View(base_grupo)
View(nova_base)

glimpse(base_grupo)

# Porém, o "group by" fica registrado no objeto

descritivas_base_grupo <- base_grupo %>% 
  summarise(média = mean(tempo),
            desvio_pad = sd(tempo),
            n_obs = n())

# O resultado do "summarise" acima é para cada grupo especificado no objeto
# Também criamos um data frame com duas linhas, uma para cada grupo
# Caso queira retirar o agrupamento criado, basta aplicar o "ungroup"

base_sem_grupo <- base_grupo %>% ungroup()

glimpse(base_sem_grupo)

summarise(base_sem_grupo,
          mean(tempo)) # informações para a base completa

# Também poderia agrupar por mais de um critério e gerar o dataset

descritivas_novos_grupos <- nova_base %>% 
  group_by(periodo, perfil) %>% 
  summarise(tempo_médio = mean(tempo),
            mínimo = min(tempo),
            máximo = max(tempo),
            contagem = n()) %>% 
  arrange(desc(máximo))

View(descritivas_novos_grupos)

# A função "arrange" apenas fez a organização de apresentação do dataset
# Foi pedido que fosse organizado de forma decrescente (desc)
# Se retirar o desc(), fica na ordem crescente

# No contexto de resumo do dataset, a função "table" é útil para as contagens
# Portanto, é utilizada para criar tabelas de frequências:

table(nova_base$periodo)
table(nova_base$perfil)
table(nova_base$periodo,
      nova_base$perfil)

# Caso necessário, seria possível armazenar a tabela em um objeto:

dados_freq_1 <- as.data.frame(table(nova_base$periodo,
                                    nova_base$perfil))

# Um trabalho semelhante poderia ser feito por meio da função count()
# A função count() será muito útil para usar em conjunto com o "pipe"

nova_base %>% 
  count(periodo)

nova_base %>% 
  count(perfil)

dados_freq_2 <- nova_base %>% 
  count(periodo, perfil, name = "contagem")

#--------------------Filter-----------------------------------------------------

# A função "filter" tem o objetivo de gerar subconjuntos do dataset
# São especificados os critérios e as linhas que os atenderem serão filtradas

# Os principais operadores lógicos são:

# ==: igual
# !=: diferente
# > e <: maior e menor (podem conter o igual >= e <=)
# &: indica "E"
# |: indica "OU"

# Inicialmente, sem utilizar a função, poderia ser feito:

filtro_1 <- nova_base[nova_base$tempo > 20,] # critérios antes da vírgula
filtro_2 <- nova_base[nova_base$tempo > 20 & nova_base$distancia < 25,]
filtro_3 <- nova_base[nova_base$tempo <=15 | nova_base$periodo == "Tarde",]

# Função "filter": filtra a base de dados de acordo com os critérios escolhidos

base_filtro_1 <- filter(nova_base, tempo > 20)
base_filtro_2 <- filter(nova_base, tempo > 20 & distancia < 25)
base_filtro_3 <- filter(nova_base, periodo == "Manhã")
base_filtro_4 <- filter(nova_base, periodo != "Manhã" & between(tempo, 20, 50))
base_filtro_5 <- filter(nova_base, tempo <= 15 | periodo == "Tarde")
base_filtro_6 <- filter(nova_base, tempo > mean(tempo))

# A função filter também pode ser aplicada em datasets com grupos (group by)
# Neste caso, a função é aplicada dentro de cada grupo

base_filtro_7 <- nova_base %>% 
  group_by(periodo) %>% 
  filter(tempo > mean(tempo)) %>% 
  ungroup()

# Analisando as bases 6 e 7:

# base_filtro_6: observações tempo > 30 (média geral) foram filtradas
# base_filtro_7: observações com tempo p/ manhã > 22.1 foram filtradas
# base_filtro_7: observações com tempo p/ tarde > 48.3 foram filtradas

nova_base %>% 
  group_by(periodo) %>% 
  summarise(mean(tempo))

# A seguir, vamos realizar algumas operações sequencialmente
# O objetivo é obter estatísticas condicionais para grupos separados
# Note que estamos adicionando o argumento na.rm = T nas funções
# Embora não seja o caso aqui, é necessário quando há valores faltantes

descritivas_condic <- nova_base %>% 
  filter(tempo > 20) %>% 
  group_by(perfil) %>% 
  summarise(observações = sum(!is.na(distancia)),
            média = mean(distancia, na.rm = T),
            mediana = median(distancia, na.rm = T),
            desv_pad = sd(distancia, na.rm = T),
            mínimo = min(distancia, na.rm = T),
            máximo = max(distancia, na.rm = T),
            quartil_1 = quantile(distancia, probs = 0.25, na.rm = T),
            quartil_3 = quantile(distancia, probs = 0.75, na.rm = T)) %>% 
  arrange(média)

# Outro operador útil para realizar comparações e filtros é: %in%
# É utilizado para verificar se os elementos de um objeto constam em outro

selecao_pessoas <- c("Gabriela", "Gustavo", "Letícia", "Antônio", "Ana")

nova_base %>% 
  filter(observacoes %in% selecao_pessoas)

# Podemos calcular estatísticas na sequência

nova_base %>% 
  filter(observacoes %in% selecao_pessoas) %>% 
  summarise(tempo_medio_pessoas = mean(tempo))

# Também é possível encontrar o complemento do %in%
# Utilizando o ponto de exclamação

nova_base %>% 
  filter(!(observacoes %in% selecao_pessoas))

nova_base %>% 
  filter(!(observacoes %in% selecao_pessoas)) %>% 
  summarise(tempo_medio_pessoas = mean(tempo))

#--------------------Slice------------------------------------------------------

# A função "filter" seleciona linhas com base em critérios lógicos
# A função "slice" pode ser utilizada para a seleção de linhas usando posições

nova_base %>% slice(5:9) # com base na posição das linhas
nova_base %>% slice(1:2, 5:9) # com base na posição das linhas com intervalo
nova_base %>% slice_head(n=3) # as três primeiras linhas
nova_base %>% slice_tail(n=3) # as três últimas linhas
nova_base %>% slice_min(order_by = distancia, prop = 0.40) # os prop % menores
nova_base %>% slice_max(order_by = distancia, prop = 0.10) # os prop % maiores

#--------------------Join-------------------------------------------------------

# Funções "join": utilizadas para realizar a junção (merge) de datasets
# Para ser possível, é necessária pelo menos uma variável em comum nos datasets

# Left Join: traz as variáveis do dataset Y para o dataset X 
# Nas funções, X é o primeiro argumento a ser inserido na função

# Primeiramente, vamos igualar o nome da variável que será usada como "chave"

dataset_inicial <- dataset_inicial %>% rename(observacoes=Observações)
dataset_merge <- dataset_merge %>% rename(observacoes=Estudante)

# Em seguida, podemos realizar o merge

base_left_join <- left_join(dataset_inicial, dataset_merge,
                            by = "observacoes")

View(base_left_join)

# O argumento "by" indica a variável que será a "chave" para a combinação

# Da mesma forma, mas usando o pipe

dataset_inicial %>% left_join(dataset_merge, by = "observacoes")

# Podemos verificar que a variável que está em Y foi trazida para X
# Como uma observação de X não está presente em Y, o dataset final aponta "NA"
# NA = é um missing value
# Então, no dataset final, todas as observações de X estão presentes
# Por outro lado, observações de Y que não estejam em X são excluídas
# As observações que estão na "chave" de X são aquelas no dataset final

# Right Join: leva as variáveis de X para Y (X é o primeiro argumento)

base_right_join <- right_join(dataset_inicial, dataset_merge,
                              by = "observacoes")

View(base_right_join)

dataset_inicial %>% right_join(dataset_merge, by = "observacoes")

# Neste caso, o dataset final contém somente as observações de Y
# Isto é, uma observação de X que não está presente em Y foi excluída
# As observações que estão na "chave" de Y são aquelas no dataset final
# São gerados NA na a observação de Y que não está em X

# Inner Join: cria um novo dataset com as observações que estão em X e Y
# Para fazer parte do dataset final, deve estar em ambos os datasets iniciais
# Colocando de outra forma, é a interseção de X e Y

base_inner_join <- inner_join(dataset_inicial, dataset_merge,
                              by = "observacoes")

View(base_inner_join)

# Não há missing values, só as observações que estão em X e Y ficam após o merge

# Full Join: cria um novo dataset contendo todas as informações de X e Y
# Ou seja, pode estar em X e não estar em Y e vice-versa

base_full_join <- full_join(dataset_inicial, dataset_merge,
                            by = "observacoes")

View(base_full_join)

# As próximas duas funções, Semi Join e Anti Join, são formas de comparação
# Isto significa que elas não realizam o merge, apenas comparam datasets

# Semi Join: mantém em X as observações que coincidem com Y, sem realizar merge

base_semi_join <- semi_join(dataset_inicial, dataset_merge,
                            by = "observacoes")

View(base_semi_join)

# No dataset final, constam apenas as variáveis que já estavam em X
# Porém, as observações são somente aquelas que também estão em Y

# Anti Join: mantém em X suas observaçoes que não coincidem com Y
# Também não ocorre o merge

base_anti_join <- anti_join(dataset_inicial, dataset_merge,
                            by = "observacoes")

View(base_anti_join)

#--------------------Bind-------------------------------------------------------

# Existem formas simples de combinar datasets, adequados em casos particulares
# As funções "bind" combinam datasets sem a especificação de uma "chave"
# Isto significa que as observações ou variáveis devem estar na mesma ordem

# Vamos criar alguns datasets para exemplificar:

dataset_bind_1 <- tibble(var1 = c("obs1", "obs2", "obs3", "obs4"),
                        var2 = 1:4,
                        var3 = 10:13)

dataset_bind_2 <- tibble(var4 = c("obs1", "obs2", "obs3", "obs4"),
                        var5 = 100:103)

dataset_bind_3 <- tibble(var6 = c("obs50", "obs51", "obs52", "obs53"),
                         var7 = 1500:1503)

dataset_bind_4 <- tibble(var1 = c("obs5", "obs6", "obs7", "obs8", "obs9"),
                         var2 = 5:9,
                         var3 = 14:18)

# Combinar colunas (variáveis): deve haver o mesmo número de observações

dataset_bind_colunas <- bind_cols(dataset_bind_1, dataset_bind_2)

# No exemplo a seguir, o resultado da combinação fica incorreto

dataset_bind_1 %>% bind_cols(dataset_bind_3)

# Combinar linhas (observações): as variáveis devem estar na ordem

dataset_bind_linhas <- bind_rows(dataset_bind_1, dataset_bind_4)

#--------------------Iterações com Purrr----------------------------------------

# O pacote purrr oferece funções que realizam iterações mais facilmente

# https://purrr.tidyverse.org/

# As iterações evitam a repetição de códigos
# São adequadas quando a intenção é realizar a mesma tarefa em vários inputs
# Por exemplo, evitam repetir o código que seria aplicado em diversas variáveis 

# No purrr, as funções map() realizam tais tarefas
# O map() parte de um vetor e aplica dada função para cada elemento dele
# Retorna um vetor de mesmo comprimento do vetor input. Vetores resultantes:

# map(): listas
# map_lgl(): lógicos
# map_int(): inteiros
# map_dbl(): doubles
# map_chr(): caracteres 

# A seguir, vamos criar o vetor que contém os inputs para a função map()
# Para a nova_base, vamos selecionar as variáveis numéricas:

vetor_input <- c("tempo", "distancia", "semaforos")

# O objetivo é criar um vetor (numérico) que contém estatísticas por variável

# A seguir, cada linha gera um tipo de estatística para cada variável do vetor
# A tarefa que realizamos em 3 linhas antes, é realizada em uma linha agora

map_dbl(nova_base[vetor_input], mean, na.rm = T)
map_dbl(nova_base[vetor_input], median, na.rm = T)
map_dbl(nova_base[vetor_input], sd, na.rm = T)
map(nova_base[vetor_input], quantile, probs = c(0.25, 0.50, 0.75), na.rm = T)

# ATENÇÃO: embora não seja necessário nesta base de dados, usamos na.rm = T
# O argumento solicita a remoção de NAs antes de fazer as contas (T é TRUE)
# É um argumento importante, pois evita erros quando há dados faltantes

# Nos caso os percentis, utilizamos apenas o map, pois é gerada uma lista
# A justificativa é que pedimos 3 informações no mesmo código
# Vamos analisar o objeto gerado em uma lista

lista_quartis <- map(nova_base[vetor_input], quantile, probs = c(0.25, 0.50, 0.75), na.rm = T)

lista_quartis[["tempo"]]
lista_quartis[["tempo"]][["25%"]]

# A seguir, vamos utilizar o map() e gerar descritivas completas das variáveis

map(nova_base[vetor_input], ~ summary(.))

# Portanto, o cógigo acima gerou mais informação em uma única linha
# O ~ indica que trata-se de uma função, ou seja, escreveremos uma função
# Os pontos substituem a indicação dos dados (usa nova_base[vetor_input])

# Acima, foram utilizadas funções já existentes (mean, median, sd, quantile)
# Porém, também poderiam conter funções (functions) criadas por nós
# A seguir, combinaremos o map() como a função do coeficiente de variação

coef_var <- function(x) {
  cv <- ((sd(x, na.rm=T))/(mean(x, na.rm=T)))*100
  return(cv)
}

# Após elaborar a nova função, basta utilizá-la no map()

map_dbl(nova_base[vetor_input], coef_var)

# Também poderíamos adicionar diretamente ao map() com os atalhos ~ e .

map_dbl(nova_base[vetor_input], ~ (sd(., na.rm=T) / mean(., na.rm=T))*100)

# A seguir, utilizamos o map pedindo os elementos da 5ª linha

map(nova_base, 5)

# Também podemos identificar os tipos de elementos contidos no vetor

map_chr(nova_base, typeof)

# E os elementos únicos deste objeto

map(nova_base, unique)

# Em resumo, podemos utilizar a função map() de forma bastante flexível
# A ideia é sempre replicar uma função aos elementos do vetor input

# O map() também pode ser aplicado quando há múltiplos inputs

# Por exemplo, vamos gerar variáveis com as seguintes médias e desvios padrão

médias_var <- list(5, 10, 15)
desv_pad_var <- list(1, 2, 3)

map2(médias_var, desv_pad_var, rnorm, n = 5)

# Os parâmetros interagiram em sequencia: 5 e 1, 10 e 2, 15 e 3
# No map2(), os inputs que variam estão antes da função e os dados fixos depois
# Para vários inputs, utiliza-se pmap()

# Vamos variar o tamanho "n" das variáveis

tamanho_var <- list(7, 9, 11)

parametros <- list(tamanho_var, médias_var, desv_pad_var) # sequência da fórmula

pmap(parametros, rnorm)

# Na prática, para evitar erros, é melhor nomear os argumentos

parametros2 <- list(mean = médias_var, sd = desv_pad_var, n = tamanho_var)

pmap(parametros2, rnorm)

# Fim!
