# -*- coding: utf-8 -*-
"""
Data Wrangling Python

Material Complementar - MBA DSA (USP/ESALQ)

Wilson Tarantin Junior
"""

#%% Carregando os pacotes

import pandas as pd
import numpy as np

#%% Importando os bancos de dados

# Fonte: https://dados.cvm.gov.br/dataset/cia_aberta-doc-dfp

dados_cvm = pd.read_csv('(3.2) CVM Resultado.csv', 
                        sep=';',
                        encoding='latin1')

dados_cadastro = pd.read_csv('(3.3) CVM Dados Cadastrais.csv', 
                        sep=';',
                        encoding='latin1')

#%% Registros únicos das contas

contas = dados_cvm['DS_CONTA'].unique()

#%% Filtrar as observações de interesse

# A receita principal da empresa é 3.01 e lucro/prejuízo líquido é 3.11
dados_sel = dados_cvm[(dados_cvm['CD_CONTA'] == '3.01') | (dados_cvm['CD_CONTA'] == '3.11')]

#%% Organizar as observações 

# Colocando as informações de 2021 e 2022 juntas
# Separando as duas contas
dados_sel = dados_sel.sort_values(by=['CD_CONTA', 'CD_CVM'], ascending=True)

#%% Análise de duplicidades de observações

contagem = dados_sel.groupby(['CD_CVM', 'CD_CONTA'])['VL_CONTA'].count()

# Há um resíduo no dataset, a empresa com CD_CVM = 26077 tem duplicidades

#%% Exclusão do resíduo

# Vamos manter a primeira versão disponibilizada pela empresa 26077
dados_sel = dados_sel[~((dados_sel['CD_CVM'] == 26077) & (dados_sel['VERSAO'] == 3))]

# A inversão do critério de filtro foi feita por meio do ~

#%% Ajustando a base dos dados cadastrais

cadastrais = dados_cadastro[['CD_CVM', 'SETOR_ATIV']]

cadastrais = cadastrais[cadastrais['SETOR_ATIV'].notnull()] # elimina missings

# Vamos manter apenas registros únicos (evitando duplicidade no merge)
cadastrais.drop_duplicates(subset=['CD_CVM', 'SETOR_ATIV'], keep=False, inplace=True)

#%% Realizando o merge

dados_sel = pd.merge(dados_sel, cadastrais, how="left", on="CD_CVM")

#%% Vamos calcular a variação percentual

# Criar uma nova variável com o valor defasado
dados_sel['VALOR_LAG'] = dados_sel.groupby(['CD_CVM', 'CD_CONTA'])['VL_CONTA'].shift(1)

# Criando uma nova variável com o resultado da variação
dados_sel['VARIACAO'] = ((dados_sel['VL_CONTA'] - dados_sel['VALOR_LAG']) / dados_sel['VALOR_LAG'])

#%% Estatísticas descritivas

# Vamos separar um dataset reduzido e limpar a variável de interesse
variavel_analise = dados_sel[['DENOM_CIA', 'SETOR_ATIV', 'CD_CONTA', 'VARIACAO']]

variavel_analise = variavel_analise[~ variavel_analise['VARIACAO'].isin([np.nan, np.inf, -np.inf])]

print(variavel_analise['VARIACAO'].describe())

# Existem valores muito extremos influenciando as descritivas

#%% Vamos apenas excluir grandes variações

# Por exemplo, excluindo variações maiores do que 200% e menores do que -200%
# São indícios de variações significativas nos fundamentos da empresa

variavel_analise = variavel_analise[variavel_analise['VARIACAO'].between(-2, 2, inclusive="both")]

#%% Novas estatísticas descritivas

print(variavel_analise['VARIACAO'].describe())

#%% Informações mais detalhadas por tipo de conta e setor

# Por tipo de conta: 3.01 = Receitas 3.11 = Lucro
print(variavel_analise.groupby(['CD_CONTA'])['VARIACAO'].describe().T)

#%% Informações mais detalhadas por tipo de conta e setor

# Por setor
desc_setor = variavel_analise.groupby(['SETOR_ATIV'])['VARIACAO'].describe()

#%% FIM!