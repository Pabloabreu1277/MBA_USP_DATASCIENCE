
## Data Wrangling R
## MBA DSA USP ESALQ

# Prof. Wilson Tarantin Junior

# Atividade de Análise nº 4 - Dataset Jogos da Copa do Mundo de Futebol 2022
# Fonte: https://www.kaggle.com/datasets/mcarujo/fifa-world-cup-2022-catar?select=matches_world_cup_2022_catar.csv

# Carregando os pacotes
library(tidyverse)

# Importando o banco de dados
jogos <- read.csv("(4.2) Jogos Copa 22.csv")

glimpse(jogos)

# De forma geral, o dataset já está bastante organizado
# As observações são os jogos que acontecetaram ao longo do campeonato
# As variáveis são as informações pertinentes aos jogos

# Uma variável que não consta na lista é o time vencedor do jogo
# Vamos criar usando o mutate e a função case_when para definir a fórmula
# O case_when funciona como um "se -> então"

jogos <- jogos %>% mutate(time_vencedor = case_when(
  team_home_score - team_away_score > 0 ~ "mandante",
  team_home_score - team_away_score < 0 ~ "visitante",
  team_home_score - team_away_score == 0 ~ "empate")) %>%
  relocate(time_vencedor, .after = team_away_score)

jogos <- jogos %>% mutate(pens_home_score = as.double(pens_home_score),
                          pens_away_score = as.double(pens_away_score),
                          time_vencedor = case_when(
                            pens_home_score - pens_away_score > 0 ~ "mandante",
                            pens_home_score - pens_away_score < 0 ~ "visitante",
                            is.na(pens_home_score - pens_away_score) ~ time_vencedor))
  
# Vamos gerar um gráfico para visualizar melhor a informação resultante
  
ggplot(jogos) + 
  geom_bar(aes(x = time_vencedor), fill = "blue") + 
  labs(x = "Vencedor",
       y = "Contagem") + 
  theme_light()

# Vamos identificar as fases da competição e fazer uma análise mais específica:

fases <- word(jogos$stage, 1)
print(fases)

# Vamos adicionar a variável ao dataset, mas renomeando as categorias

jogos <- jogos %>% 
  mutate(fases = recode(fases,
                        "Group" = 1,
                        "Round" = 2,
                        "Quarter-finals" = 3,
                        "Semi-finals" = 4,
                        "Match" = 5,
                        "Final"= 6)) %>% 
  relocate(fases, .after = stage)

# Vamos analisar o gráfico de acordo com as fases da competição:

ggplot(jogos) + 
  geom_bar(aes(x = interaction(time_vencedor, fases), fill=factor(fases))) + 
  labs(x = "Vencedor por Fase",
       y = "Contagem") + 
  scale_fill_brewer(palette=18)

# No banco de dados há informações sobre as previsões de vitória
# Vamos analisar se a previsão foi confirmada

jogos <- jogos %>% mutate(previsao = case_when(
  prediction_team_home_win > prediction_team_away_win ~ "mandante",
  prediction_team_home_win < prediction_team_away_win ~ "visitante"),
  analise_prev = case_when(
    previsao == time_vencedor ~ "acerto",
    previsao != time_vencedor ~ "erro"))

# Resultado no gráfico

ggplot(jogos) + 
  geom_bar(aes(x = analise_prev), fill = "green") + 
  geom_text(aes(x = analise_prev, label = ..count..), stat = "count", vjust = 2) +
  labs(x = "Previsões",
       y = "Contagem") + 
  theme_light()

# Uma informação interessante seria identificar os jogadores que fizeram os gols
# Esta informação está na variável "events_list" que é uma string mais complexa
# Precisamos retirar a informação específica, então vamos procurar um padrão
# A informação que queremos está após -- 'Goal', 'action_player_1': ' --

extrai_gol <- str_extract_all(jogos$events_list, 
                     "'Goal', 'action_player_1': '\\w*(.*?)\\w*\\'",
                     simplify = TRUE)

# Acima, utilizamos regex (regular expression), úteis para trabalhar em strings
# Embora não seja nosso foco, é importante conhecer a existência
# O str_extract_all pede para extrair em todas as ocorrências do padrão

# Pedimos para extrair qualquer palavra (\w) contida entre as extremidades:
# Extremidade 1: 'Goal', 'action_player_1': '
# Extremidade 2: ' (só o apóstrofo)
# A seguir, apenas faremos uma limpeza no texto

extrai_gol <- gsub("'Goal', 'action_player_1': ' ", "", extrai_gol)
extrai_gol <- gsub(" '", "", extrai_gol)

# O mesmo critério vamos usar para extrair os gols de pênalti

extrai_penalti <- str_extract_all(jogos$events_list,
              "'event_type': 'Penalty', 'action_player_1': '\\w*(.*?)\\w*\\'",
              simplify = TRUE)

extrai_penalti <- gsub("'event_type': 'Penalty', 'action_player_1': ' ", "", extrai_penalti)
extrai_penalti <- gsub(" '", "", extrai_penalti)

# Por fim, podemos pedir uma tabela de frequências dos gols

sort(table(cbind(extrai_gol, extrai_penalti)), decreasing = T)

# FIM!

