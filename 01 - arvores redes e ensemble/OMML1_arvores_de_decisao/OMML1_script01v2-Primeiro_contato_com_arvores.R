######################################
# Vamos trabalhar com a base titanic #
# cuja fonte está na library(titanic)#

titanic %>% head

#################################
# Nosso objetivo:
#      Classificar passageiros sobreviventes de acordo 
#      somente com variáveis do registro deles
################################


#################################### 
# Vamos fazer uma breve descritiva #

# Vamos criar uma base temporária para manter a base original intacta
tmp <- titanic
tmp$survived <- as.integer(titanic$Survived=="Y")

##########################################
# Função para fazer a análise descritiva #
# Vamos avaliar a distribuição de sobreviventes por cada variável X
# Sumarizamos então y por categoria de X e montamos um gráfico de perfis


descritiva("Sex")
descritiva("Pclass")
descritiva("Embarked")
descritiva("SibSp")
descritiva("Parch")

# Vamos categorizar as variáveis contínuas para analisar
tmp$cat_age <- quantcut(tmp$Age, 15)
descritiva("cat_age")

tmp$cat_fare <- quantcut(tmp$Fare, 10)
descritiva("cat_fare")

# Listagem das variáveis com algumas características
titanic %>% str

#############################################
# Vamos construir a árvore de classificação #
arvore <- rpart::rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                data=titanic,
                parms = list(split = 'gini'), # podemos trocar para  'information'
                method='class' # Essa opção indica que a resposta é qualitativa
)

#########################
# Visualizando a árvore #

# Definindo uma paleta de cores
paleta = scales::viridis_pal(begin=.75, end=1)(20)
# Plotando a árvore

rpart.plot::rpart.plot(arvore,
                       box.palette = paleta) # Paleta de cores

##############################
# Avaliação básica da árvore #

# Predizendo com a árvore

# Probabilidade de sobreviver
prob = predict(arvore, titanic)

# Classificação dos sobreviventes
class = prob[,2]>.5
# Matriz de confusão
tab <- table(class, titanic$Survived)
tab

acc <- (tab[1,1] + tab[2,2])/ sum(tab)
acc

