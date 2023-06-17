# -*- coding: utf-8 -*-
"""
Data Wrangling Python

Material Complementar - MBA DSA (USP/ESALQ)

Wilson Tarantin Junior
"""

#%% Carregando os pacotes

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

#%% Importando o banco de dados

# Fonte: Fonte: https://www.kaggle.com/datasets/mcarujo/fifa-world-cup-2022-catar?select=matches_world_cup_2022_catar.csv

dados_jogos = pd.read_csv('(4.2) Jogos Copa 22.csv', sep=',')

#%% Informações básicas do dataset

print(dados_jogos.info())

#%% Criando uma variável com o time vencedor do jogo

dados_jogos['venceu'] = np.where((dados_jogos['team_home_score'] - dados_jogos['team_away_score'] > 0), 'mandante',
                        np.where((dados_jogos['team_home_score'] - dados_jogos['team_away_score'] < 0), 'visitante',
                        np.where((dados_jogos['team_home_score'] - dados_jogos['team_away_score'] == 0), 'empate',
                                "Demais")))

#%% Ajustando classe das variáveis numéricas

# Primeiramente, substituir os textos Falses por NAs
dados_jogos['pens_home_score'] = dados_jogos['pens_home_score'].replace("False", np.nan)
dados_jogos['pens_away_score'] = dados_jogos['pens_away_score'].replace("False", np.nan)

# Em seguida, convertendo para variáveis numéricas
dados_jogos['pens_home_score'] = dados_jogos['pens_home_score'].astype('float')
dados_jogos['pens_away_score'] = dados_jogos['pens_away_score'].astype('float')

#%% Ajustando a variável com o time vencedor do jogo

dados_jogos['venceu'] = np.where(dados_jogos['pens_home_score'] - dados_jogos['pens_away_score'] > 0, 'mandante',
                        np.where(dados_jogos['pens_home_score'] - dados_jogos['pens_away_score'] < 0, 'visitante',
                        np.where(dados_jogos['pens_home_score'].isna(), dados_jogos['venceu'],
                                "Demais")))

#%% Contagem dos vencedores

print(dados_jogos['venceu'].value_counts())

#%% Gerando um gráfico com as informações dos vencedores

sns.countplot(x=dados_jogos['venceu'])

#%% Identificando a fase da competição

dados_jogos['fase'] = dados_jogos['stage'].str.split(' ').str[0]

#%% Vencedores por fase da competição

print(dados_jogos.groupby(['fase'])['venceu'].value_counts())

#%% Gerando um gráfico com as informações dos vencedores por fase

sns.countplot(data=dados_jogos, y='fase', hue='venceu')
plt.legend(loc='upper right', title='Vencedor')
plt.xlabel('Quantidade')
plt.ylabel('Fase')
plt.xticks(np.arange(0, 21, step=1))

#%% Extraindo os jogadores que fizeram gols

extrai_gol = dados_jogos['events_list'].str.extractall("'Goal', 'action_player_1': '\\w*(.*?)\\w*\\'")

#%% Extraindo os jogadores que fizeram gols de pênaltis

extrai_penalti = dados_jogos['events_list'].str.extractall("'event_type': 'Penalty', 'action_player_1': '\\w*(.*?)\\w*\\'")

#%% Unindo os datasets

gols = pd.concat([extrai_gol, extrai_penalti], ignore_index=True)

print(gols.value_counts().head(n=10))

#%% FIM!