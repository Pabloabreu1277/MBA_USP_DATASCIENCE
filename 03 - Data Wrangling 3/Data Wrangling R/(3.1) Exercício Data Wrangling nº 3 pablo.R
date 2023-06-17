## Data Wrangling R
## MBA DSA USP ESALQ

# Prof. Wilson Tarantin Junior

# Atividade de Análise nº 3 - Dataset Comissão de Valores Mobiliários (CVM)
# O dataset contém informações financeiras de companhias abertas brasileiras
# Fonte: https://dados.cvm.gov.br/dataset/cia_aberta-doc-dfp

# Vamos investigar como foi a variação nas vendas e no lucro das empresas
# No dataset, temos dois anos de informações: 2021 e 2022
# Como evoluíram a receita de vendas e o lucro líquido entre os anos?
# Foi diferente entre setores?

library(tidyverse)

# Importando a base de dados

base_cvm <- read.csv("(3.2) CVM Resultado.csv",
                     sep = ";", 
                     encoding = "latin1")

# Vamos organizar o dataset, mantendo apenas informações pertinentes

# Quais contas estão sendo apresentadas no dataset?

options(max.print = 3000)
unique(base_cvm$DS_CONTA)

# Em análise detalhada, identificou-se pelo código das contas (CD_CONTA)
# A receita principal da empresa é 3.01 e lucro/prejuízo líquido é 3.11

base_cvm <- base_cvm %>% 
  filter(CD_CONTA == "3.01" | CD_CONTA == "3.11")

# Temos informações para 2021 e 2022, vamos coloca-lás juntas para cada empresa
# Para melhor organização, vamos separar as contas de receitas e lucros

base_cvm_aj <- base_cvm %>% 
  group_by(CD_CONTA, CD_CVM) %>% 
  arrange(base_cvm, DT_REFER, .by_group = T) %>% 
  ungroup()

# Verificar se há duplicidade de observações e excluí-las se houver

base_cvm_aj <- distinct(base_cvm_aj)

# No "distinct" (tidyverse), como não especificamos variáveis, considerou todas
# Vamos verificar se há 4 informações de cada empresa (2 para cada conta)

contagem <- base_cvm_aj %>% 
  count(CD_CVM, CD_CONTA)

# Há um resíduo no dataset, a empresa com CD_CVM = 26077 tem duplicidades
# Em análise adicional, verificou-se que há "versões" de relatórios
# Vamos manter a última versão disponibilizada (VERSAO = 3)

base_cvm_aj <- base_cvm_aj %>% 
  filter(!(CD_CVM == 26077 & VERSAO == 3))

# Uma nova contagem para cerificar

contagem_nova <- base_cvm_aj %>% 
  count(CD_CVM, CD_CONTA)

# Vamos adicionar os setores das empresas para fazer análises mais específicas

cadastrais <- read.csv("(3.3) CVM Dados Cadastrais.csv",
                       sep = ";", 
                       encoding = "latin1")

# Ambas as bases, por serem da mesma fonte, têm uma variável em comum (CD_CVM)
# Vamos utilizá-la para um merge (join)

# Como existem muitas variáveis de dados cadastrais, vamos selecionar e limpar

cadastrais <- cadastrais %>% 
  select (CD_CVM, SETOR_ATIV) %>% 
  filter(SETOR_ATIV != "") %>% 
  distinct()
# Fazendo o merge

base_cvm_aj <- base_cvm_aj %>% 
  left_join(cadastrais, by = "CD_CVM")

# Por fim, vamos calcular a variação percentual e gerar a variável de interesse
# Aqui utilizaremos a função lag(), que traz valores anteriores para o cálculo

base_cvm_aj <- base_cvm_aj %>% 
  group_by(CD_CVM, CD_CONTA) %>%
  mutate(VARIACAO = ((VL_CONTA - lag(VL_CONTA, n = 1L))/lag(VL_CONTA, n = 1L))) %>% 
  ungroup()

# Vamos ajustar as casas decimais

base_cvm_aj <- base_cvm_aj %>% 
  mutate(VARIACAO = round(VARIACAO, 3))

# Vamos utilizar o summarise e verificar informações preliminares

summarise(base_cvm_aj,
          observações=n(),
          média=mean(VARIACAO, na.rm = TRUE))

# O cálculo da variação gerou valores que poluíram a variável (infinitos)
# Tais elementos não permitem os cálculos no "summarise"

# Vamos limpar a variável utilizando os procedimentos a seguir e o "filter"

infinitos <- is.infinite(base_cvm_aj$VARIACAO)

base_cvm_aj <- base_cvm_aj %>% 
  mutate(INF = infinitos) %>% 
  filter(INF == FALSE)

# Note que sobraram os NAs, mas estes vamos ajustar diretamente no summarise
# Um novo comando de summarise para verificar a variável:

summarise(base_cvm_aj,
          observações=n(),
          média=mean(VARIACAO, na.rm = TRUE))

# Pode-se notar que existem valores muito extremos influenciando as descritivas

# Sem maiores análises ou fundamentação, vamos apenas excluir grandes variações
# Por exemplo, excluindo variações maiores do que 200% e menores do que -200%
# São indícios de variações significativas nos fundamentos da empresa


base_cvm_excl <- base_cvm_aj %>% 
  filter(!(VARIACAO > 2|VARIACAO < -2))

summarise(base_cvm_excl,
          observações=n(),
          média=mean(VARIACAO, na.rm = TRUE))

# Vamos gerar as informações mais detalhadas por tipo de conta e setor

base_cvm_excl %>% 
  group_by(CD_CONTA) %>% 
  summarise(média = mean(VARIACAO, na.rm = TRUE),
            n_obs = n()) %>% 
  ungroup()

tabela <- base_cvm_excl %>% 
  group_by(CD_CONTA, SETOR_ATIV) %>% 
  summarise(média = mean(VARIACAO, na.rm = TRUE),
            n_obs = n()) %>% 
  ungroup()

# Os números setoriais indicam que existem análises mais específicas a fazer
# Por exemplo, alguns setores podem ter poucas observações (média com viés)
# Mas, para fins de exemplos de ajustes em bases de dados, podemos parar aqui

# Uma forma mais adequada para comparação dos valores seria em termos reais
# A inflação no ano de 2022, medida pelo IPCA, foi 5,79% a.a.
# Vamos refazer os cálculos, atualizando os valores de 2021 pela inflação

base_cvm_atual <- base_cvm_aj %>% 
  mutate(ano = substr(DT_FIM_EXERC, 1, 4),
         VALORES_ATUAL = if_else(ano == "2021",
                                 VL_CONTA*1.0579,
                                 VL_CONTA*1)) %>%
  group_by(CD_CVM, CD_CONTA) %>%
  mutate(VARIACAO_ATUAL = ((VALORES_ATUAL - lag(VALORES_ATUAL, n = 1L))/lag(VALORES_ATUAL, n = 1L))) %>% 
  ungroup() %>%
  filter((!(VARIACAO_ATUAL > 2|VARIACAO_ATUAL < -2)))

# As novas descritivas, em termos reais, são:

base_cvm_atual %>% 
  group_by(CD_CONTA) %>% 
  summarise(média=mean(VARIACAO_ATUAL, na.rm = TRUE)) %>% 
  ungroup()

# FIM!