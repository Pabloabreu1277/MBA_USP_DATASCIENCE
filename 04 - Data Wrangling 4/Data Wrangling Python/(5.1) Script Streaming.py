# -*- coding: utf-8 -*-
"""
Data Wrangling Python

Material Complementar - MBA DSA (USP/ESALQ)

Wilson Tarantin Junior
"""

#%% Carregando os pacotes

import pandas as pd

#%% Carregando os datasets

# Fonte: https://www.kaggle.com/datasets/ruchi798/tv-shows-on-netflix-prime-video-hulu-and-disney

dados_filmes = pd.read_csv('(5.2) Filmes Streaming.csv', sep=',')
dados_series = pd.read_csv('(5.3) Séries Streaming.csv', sep=',')

#%% Selecionado colunas e realizando a junção dos bancos de dados

dados_filmes = dados_filmes.iloc[:,0:12]

dados_completo = pd.concat([dados_filmes, dados_series], ignore_index=True)

dados_completo.drop(dados_completo.columns[[0]], axis=1, inplace=True)

#%% Extrair as notas e transformar em variável numérica

dados_completo['Ajuste_IMDB'] = dados_completo['IMDb'].str.slice(0, 4)
dados_completo['Ajuste_Rotten'] = dados_completo['Rotten Tomatoes'].str.slice(0, 3)

dados_completo['Ajuste_IMDB'] = dados_completo['Ajuste_IMDB'].str.rstrip('/').astype('float')
dados_completo['Ajuste_Rotten'] = dados_completo['Ajuste_Rotten'].str.rstrip('/').astype('float')

#%% Gerando estatísticas sobre as notas

# Atribuindo labels
muda_numeros = {0: 'filme', 1: 'série'}
dados_completo = dados_completo.assign(labels_text = dados_completo.Type.map(muda_numeros))

# Agrupando o dataset
descritivas = dados_completo.groupby(['labels_text'])

# Gerando estatísticas por variável
print(descritivas['Ajuste_IMDB'].describe().T)
print(descritivas['Ajuste_Rotten'].describe().T)

#%% Criando um indicador dos "melhores" filmes e séries 

melhores_series = dados_completo[dados_completo['labels_text']=='série']
melhores_filmes = dados_completo[dados_completo['labels_text']=='filme']

#%% Séries

melhores_series['Categ_IMDB'] = pd.qcut(melhores_series.Ajuste_IMDB,
                                        q=[0, 0.95, 1.0],
                                        labels=['menores',
                                                'maiores'])

melhores_series['Categ_Rotten'] = pd.qcut(melhores_series.Ajuste_Rotten,
                                          q=[0, 0.95, 1.0],
                                          labels=['menores',
                                                  'maiores'])

melhores_series = melhores_series[(melhores_series['Categ_IMDB']=='maiores') & 
                                  (melhores_series['Categ_Rotten']=='maiores')]

#%% Filmes

melhores_filmes['Categ_IMDB'] = pd.qcut(melhores_filmes.Ajuste_IMDB,
                                        q=[0, 0.95, 1.0],
                                        labels=['menores',
                                                'maiores'])

melhores_filmes['Categ_Rotten'] = pd.qcut(melhores_filmes.Ajuste_Rotten,
                                          q=[0, 0.95, 1.0],
                                          labels=['menores',
                                                  'maiores'])

melhores_filmes = melhores_filmes[(melhores_filmes['Categ_IMDB']=='maiores') & 
                                  (melhores_filmes['Categ_Rotten']=='maiores')]

#%% FIM!