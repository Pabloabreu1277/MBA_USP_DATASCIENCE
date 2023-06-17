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

# "dados_tempo" - Fonte: Fávero & Belfiore (2017, Cap. 12)

dados_tempo = pd.read_excel('(1.2) dataset_principal.xls')
dados_merge = pd.read_excel('(1.3) dataset_join.xls')

#%% Visualizando informações básicas do dataset e variáveis

# Printar objetos no console
print(dados_tempo)

# Somente os nomes das variáveis
print(dados_tempo.columns)

# Somente primeiras "n" observações + nomes das variáveis
print(dados_tempo.head(n=5))

# Somente as últimas n observações + nome das variáveis
print(dados_tempo.tail(n=3))

# Informações detalhadas sobre as variáveis
print(dados_tempo.info())

# object = variável de texto
# int ou float = variável numérica (métrica)
# category = variável categórica (qualitativa)

#%% Alterando os nomes das variáveis

# Não é necessário trocar todos os nomes, pode ser um ou alguns deles

dados_tempo = dados_tempo.rename(columns={'Estudante':'estudante',
                                          'Tempo para chegar à escola (minutos)':'tempo',
                                          'Distância percorrida até a escola (quilômetros)': 'distancia',
                                          'Quantidade de semáforos': 'semaforos',
                                          'Período do dia': 'periodo',
                                          'Perfil ao volante': 'perfil'})

#%% Alterando os nomes das variáveis

# Para reescrever o mesmo objeto, poderia utilizar: inplace = True

dados_tempo.rename(columns={'Estudante':'estudante',
                            'Tempo para chegar à escola (minutos)':'tempo',
                            'Distância percorrida até a escola (quilômetros)': 'distancia',
                            'Quantidade de semáforos': 'semaforos',
                            'Período do dia': 'periodo',
                            'Perfil ao volante': 'perfil'}, inplace=True)

#%% Ajustar o tipo das variáveis categóricas

dados_tempo['periodo'] = dados_tempo['periodo'].astype('category')
dados_tempo['perfil'] = dados_tempo['perfil'].astype('category')

print(dados_tempo.info())

#%% Obtendo os valores únicos das variáveis

print(dados_tempo['tempo'].unique())
print(dados_tempo['periodo'].unique())

#%% Visualizando estatísticas descritivas

# Variáveis quantitativas
print(dados_tempo.describe())

#%% Visualizando estatísticas descritivas

# Frequências das variáveis qualitativas
print(pd.value_counts(dados_tempo['periodo']))
print(pd.value_counts(dados_tempo['perfil']))

#%% Visualizando estatísticas descritivas

# Frequências para pares de variáveis qualitativas
print(pd.crosstab(dados_tempo['periodo'], dados_tempo['perfil']))

#%% Adicionando variáveis em um novo objeto

novo_tempo = dados_tempo.copy()
numeros = pd.Series([1,2,3,4,5,6,7,8,9,10])
novo_tempo['numeros'] = numeros

#%% Alterando e adicionando novas colunas ao dataset

# Adicionando uma variavel no objeto original

dados_tempo['numeros'] = numeros

#%% Alterando e adicionando novas colunas ao dataset

# Criando uma nova variável em função de outros
dados_tempo['dobro_tempo'] = dados_tempo['tempo']*2

#%% Alterando e adicionando novas colunas ao dataset

# Trocando textos por textos
novos_labels = {'calmo':'Perfil_1',
                'moderado': 'Perfil_2',
                'agressivo': 'Perfil_3'}

ajuste_1 = dados_tempo.assign(labels_perfil = dados_tempo.perfil.map(novos_labels))
print(ajuste_1.info())

# A nova variável está formada no tipo categórica (como na var. original)

#%% Alterando e adicionando novas colunas ao dataset

# Trocando textos por números
novos_numeros = {'calmo': 1,
                 'moderado': 2,
                 'agressivo': 3}

ajuste_2 = dados_tempo.assign(labels_num = dados_tempo.perfil.map(novos_numeros))

# Caso seja correto para a aplicação, pode transformar a variável para número
# ATENÇÃO: Não realizar ponderação arbitrária
ajuste_2['labels_num'] = ajuste_2['labels_num'].astype('float')
print(ajuste_2.info())

#%% Alterando e adicionando novas colunas ao dataset

# Trocando números por textos
muda_numeros = {0: 'zero',
                1: 'um',
                2: 'dois',
                3: 'três'}

ajuste_3 = dados_tempo.assign(labels_text = dados_tempo.semaforos.map(muda_numeros))
print(ajuste_3.info())

# A nova variável está formatada no tipo texto

#%% Alterando e adicionando novas colunas ao dataset

# Utilizando condições (where)
dados_tempo['categ'] = np.where(dados_tempo['tempo']<=20, 'Rápido',
                       np.where((dados_tempo['tempo']>20) & (dados_tempo['tempo']<=40), 'Médio',
                       np.where(dados_tempo['tempo']>40, 'Demorado',
                                "Demais")))

#%% Alterando e adicionando novas colunas ao dataset

# Criando variáveis binárias (todas as categorias)
dados_dummies_1 = pd.get_dummies(dados_tempo, prefix='Categoria_', columns=['periodo', 'perfil'])

# Excluindo a primeira categoria
dados_dummies_2 = pd.get_dummies(dados_tempo, prefix='Categoria_', columns=['periodo', 'perfil'], drop_first=True)

#%% Organizando as observações por meio de critério

# Organizando em ordem crescente
org_tempo_1 = dados_tempo.sort_values(by=["tempo"], ascending=True)

# Organizando em ordem decrescente
org_tempo_2 = dados_tempo.sort_values(by=["tempo"], ascending=False)

# Também é possível organizar variáveis texto e categóricas
org_tempo_3 = dados_tempo.sort_values(by=["estudante"], ascending=True)
org_tempo_4 = dados_tempo.sort_values(by=["perfil"], ascending=False)

#%% Selecionando variáveis de interesse

# Selecionando com base nas posições (1º linhas, 2º colunas)
# ATENÇÃO: A contagem inicia em 0
print(dados_tempo.iloc[3,:]) # argumento : indicam vazio na coluna
print(dados_tempo.iloc[:,4]) # argumento : indicam vazio na linha
print(dados_tempo.iloc[2:5,:]) # note que exclui a posição final
print(dados_tempo.iloc[:,3:5]) # note que exclui a posição final
print(dados_tempo.iloc[2:4,3:5]) # note que exclui as posições finais
print(dados_tempo.iloc[5,4])

# Também foi possível selecionar linhas com base nestes comandos

#%% Selecionando variáveis de interesse

# Aqui também é possível alterar a ordem das variáveis
tempo_selec_1 = dados_tempo[['estudante', 'periodo', 'tempo']]

# Copiando para um novo objeto
tempo_copia = dados_tempo[['estudante','tempo']].copy()

# Excluindo variáveis do banco de dados
tempo_selec_2 = dados_tempo.drop(columns=['semaforos','perfil'])

# Selecionando por meio de um início em comum
tempo_selec_3 = dados_tempo.loc[:, dados_tempo.columns.str.startswith('per')]

# Selecionando por meio de um final em comum
tempo_selec_4 = dados_tempo.loc[:, dados_tempo.columns.str.endswith('o')]

#%% Filtros de observações

# Variáveis categóricas
perfil_calmo = dados_tempo[dados_tempo['perfil'] == "calmo"]
periodo_manha = dados_tempo[dados_tempo['periodo'] == "Manhã"]

# Interseção entre critérios (&)
dados_intersecao = dados_tempo[(dados_tempo['perfil'] == 'calmo') & (dados_tempo['periodo'] == 'Tarde')]

# União entre critérios (|)
dados_uniao = dados_tempo[(dados_tempo['perfil'] == 'calmo') | (dados_tempo['periodo'] == 'Tarde')]

# Critério de diferente (!=)
dados_dif = dados_tempo[(dados_tempo['perfil'] != 'calmo')]

# Utilizando operadores em variáveis métricas
tempo_1 = dados_tempo[dados_tempo['tempo'] >= 25]

tempo_2 = dados_tempo[(dados_tempo['tempo'] > 30) & (dados_tempo['distancia'] <= 25)]

tempo_3 = dados_tempo[dados_tempo['tempo'].between(25, 40, inclusive="both")]
# inclusive: "both", "neither", "left" ou "right"

# Comparando com valores de outro objeto (isin())
nomes = pd.Series(["Gabriela", "Gustavo", "Leonor", "Ana", "Júlia"])

contidos = dados_tempo[dados_tempo["estudante"].isin(nomes)]

nao_contidos = dados_tempo[dados_tempo["estudante"].isin(nomes)==False]

#%% Junção de bancos de dados (merge)

# Inicialmente, deixar as colunas de id com o mesmo nome nos dois datasets
dados_merge.rename(columns={'Estudante':'estudante'}, inplace=True)

# Parâmetros de configuração na função merge:
    # how: é a direção do merge (quais ids restam na base final)
    # on: é a coluna com a chave para o merge

# Observações de dados_merge -> dados_tempo (ficam os ids de dados_tempo)
merge_1 = pd.merge(dados_tempo, dados_merge, how="left", on="estudante")

# Observações de dados_tempo -> dados_merge (ficam os ids de dados_merge)
merge_2 = pd.merge(dados_tempo, dados_merge, how="right", on="estudante")

# Observações das duas bases de dados constam na base final (ficam todos os ids)
merge_3 = pd.merge(dados_tempo, dados_merge, how="outer", on="estudante")

# Somente os ids que constam nas duas bases ficam na base final (interseção)
merge_4 = pd.merge(dados_tempo, dados_merge, how="inner", on="estudante")

# É importante verificar a existência de duplicidades de observações antes do merge

#%% Group by

# Criando um banco de dados agrupado
dados_periodo = dados_tempo.groupby(["periodo"])

# Gerando estatísticas descritivas
print(dados_periodo.describe())

# Caso a tabela gerada esteja com visualização ruim no print, pode transpor
print(dados_periodo.describe().T)

#%% Group by

# Criando um banco de dados agrupado por mais de um critério
dados_criterios = dados_tempo.groupby(["periodo", "perfil"])

# Gerando estatísticas descritivas
print(dados_criterios.describe())

# Caso a tabela gerada esteja com visualização ruim no print, pode transpor
print(dados_criterios.describe().T)

#%% Excluindo valores faltantes (NA)

# Identificando variáveis com valores faltantes (isna())
print(merge_3.isna())

# Apresentando a contagem de NAs em cada variável
print(merge_3.isna().sum())

# Excluindo observações que apresentem valores faltantes
merge_exclui = merge_3.dropna()

#%% Anexando linhas ao banco de dados

dados_1 = pd.DataFrame({'var1': ['obs1','obs2','obs3'], 'var2':[10,20,30]})
dados_2 = pd.DataFrame({'var1': ['obs4','obs5'], 'var2':[40,50]})

dados_concat = pd.concat([dados_1, dados_2], ignore_index=True)

#%% FIM!