# -*- coding: utf-8 -*-
"""
Data Wrangling Python

Material Complementar - MBA DSA (USP/ESALQ)

Wilson Tarantin Junior
"""

#%% Carregando os pacotes

import pandas as pd

#%% Importando os bancos de dados

# Fonte: https://databank.worldbank.org/source/world-development-indicators

dados_wdi = pd.read_excel('(2.2) WDI World Bank.xlsx', na_values='..')
dados_grupo = pd.read_excel('(2.3) WDI Income Group.xlsx')

# Foi utilizado um argumento de ajuste de NAs já na importação (dados_wdi)

#%% Informações básicas dos dados

print(dados_wdi.info())

#%% Elementos únicos das variáveis

print(dados_wdi['Country Name'].unique())
print(dados_wdi['Series Name'].unique())
print(dados_wdi['Topic'].unique())

#%% Alterando os nomes das variáveis

dados_wdi.rename(columns={'Country Name':'pais',
                          'Country Code':'cod_pais',
                          'Series Name': 'serie',
                          'Series Code': 'cod_serie',
                          '2021 [YR2021]': 'ano_2021',
                          'Topic': 'topico'}, inplace=True)

#%% Analisando as últimas linhas do dataset

print(dados_wdi['pais'].tail(n=20))

# As últimas linhas do banco de dados não são observações

#%% Excluindo as linhas finais

dados_wdi = dados_wdi.iloc[0:383572,:]

print(dados_wdi['pais'].tail(n=20))

#%% Selecionando os tópicos de saúde

dados_saude = dados_wdi[dados_wdi['topico'].str.startswith("Health")]

#%% Colocando as séries nas colunas

# As séries se tornam variáveis e as observações são os países

dados_wide = pd.pivot(dados_saude, 
                      index=['pais','cod_pais'], 
                      columns=['serie'], 
                      values='ano_2021')

# Voltando para o índice numérico

dados_wide = dados_wide.reset_index()

#%% Adicionar a categoria "income group" ao dataset final

dados_grupo_select = dados_grupo[['Code', 'Income Group']]

dados_grupo_select.rename(columns={'Code':'cod_pais'}, inplace=True)

dados_final = pd.merge(dados_wide, dados_grupo_select, how="left", on="cod_pais")

#%% Excluindo variáveis somente NAs

dados_final = dados_final.dropna(axis=1, how='all')

#%% Reorganizando a posição da coluna

organizar = dados_final.pop('Income Group')

dados_final.insert(2, 'Income Group', organizar)

#%% FIM!