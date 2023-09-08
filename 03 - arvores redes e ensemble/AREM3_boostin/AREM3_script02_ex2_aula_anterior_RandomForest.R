##############################################################################
# Carregar o pacote mlbench (se ainda não estiver instalado)
# install.packages("mlbench")

# Carregar a base de dados Housing

# Visualizar as primeiras linhas da base de dados
head(BostonHousing)

# Desenvolva o seu modelo livremente (de preferência dentro do que vimos em aula) e venha preparado na próxima aula
# A nossa variável resposta aqui é o MEDV, que é o valor mediano do imóvel
# Tente fazer um modelo que indique o valor mediano de um imóvel dadas as características da região
#######################################
# Dicionário de dados:
#######################################

# CRIM: Taxa de criminalidade per capita por região.
# ZN: Proporção de terrenos residenciais divididos em lotes com mais de 25.000 pés quadrados (cerca de 2.322 metros quadrados).
# INDUS: Proporção de acres não comerciais por cidade.
# CHAS: Variável fictícia (dummy) que indica se o imóvel faz fronteira com o rio Charles (1 se faz fronteira, 0 caso contrário).
# NOX: Concentração de óxidos nítricos (partes por 10 milhões).
# RM: Média de número de quartos por habitação.
# AGE: Proporção de unidades ocupadas pelos proprietários construídas antes de 1940.
# DIS: Distância ponderada até cinco centros de emprego em Boston.
# RAD: Índice de acessibilidade a rodovias radiais.
# TAX: Taxa de imposto sobre propriedades de valor total por $10.000.
# PTRATIO: Razão aluno-professor por cidade.
# B: 1000(Bk - 0.63)^2, onde Bk é a proporção de pessoas de origem afro-americana por cidade.
# LSTAT: Porcentagem de status inferior da população.
# MEDV: Valor mediano das residências ocupadas pelos proprietários em milhares de dólares.



# Fique à vontade para usar as funções que vimos
# Fique à vontade para consultar as inteligências que quiser, naturais ou não

dim(BostonHousing)


####################################################
# 1) Dividir amostras de treino, validação e teste #
####################################################

# Sortear, de 1 a 3 para cada linha onde:
# 1 - indica que a linha participará da base de treino
# 2 - indica que a linha participa da base de validação
# 3 - indica que a linha participa da base de teste
set.seed(123)
separacao <- sample(c('Treino', 'Validação', 'Teste'),
            size = nrow(BostonHousing),
            replace = TRUE,
            prob=c(0.6, 0.2, 0.2))

# Verificando os sorteios
table(separacao)

# Gerando bases de treino, validação e teste
treino    <- BostonHousing[separacao == 'Treino',]
nrow(treino)
validacao <- BostonHousing[separacao == 'Validação',]
nrow(validacao)
teste     <- BostonHousing[separacao == 'Teste',]
nrow(teste)


#########################################
# 2) Etapa descritiva  #
#########################################
tmp <- BostonHousing
tmp$crim %>% hist
tmp$crim_cat <- quantcut(tmp$crim, 5)
descritiva2("crim_cat", "medv", tmp)

tmp$zn %>% hist
tmp$zn_cat <- quantcut(tmp$zn, 5)
descritiva2("zn_cat", "medv", tmp)


tmp$indus %>% hist
tmp$indus_cat <- quantcut(tmp$indus, 5)
descritiva2("indus_cat", "medv", tmp)

tmp %>% colnames

#########################################
# 3) Primeira opção de modelo - árvore  #
#########################################

# 2.0 - primeira versão de árvore (profundidade = 2)
set.seed(123)
arvore0 <- rpart::rpart(medv~., 
              data=treino,
              control=rpart.control(maxdepth = 2, cp=0))
paleta <- scales::viridis_pal(begin=.75, end=1)(20)

#Visualizar a árvore
plot <- rpart.plot::rpart.plot(arvore0,
                               box.palette = paleta) # Paleta de cores

# 2.0.1 - Função para avaliar a árvore
avalia_regressao <- function(p_var, y_var){
  n <- length(y_var)
  SQE <- sum((y_var - p_var)^2)
  QME <- SQE/n
  
  # Cálculo do SSE (Sum of Squares Total)
  SST <- sum((y_var - mean(y_var, na.rm=TRUE))**2)
  QMT <- SST/n
  
  # Cálculo do R-quadrado
  R_squared <- 1 - SQE/SST
  
  # Imprimindo os resultados
  cat("SQE: ", SQE, "QME : ", QME, "\n")
  cat("SST: ", SST, "QMT: ", QMT, "\n")
  cat("R-quadrado: ", R_squared, "\n")
  
}
avalia_regressao(predict(arvore0, treino), treino$medv)
avalia_regressao(predict(arvore0, validacao), validacao$medv)

# 2.1 - segunda versão de árvore, um pouco maior
arvore1 <- rpart::rpart(medv~., 
                        data=treino,
                        control=rpart.control(maxdepth = 3, cp=0))

#Visualizar a árvore
plot <- rpart.plot::rpart.plot(arvore1,
                               box.palette = paleta) # Paleta de cores

avalia_regressao(predict(arvore1, treino), treino$medv)
avalia_regressao(predict(arvore1, validacao), validacao$medv)


# 2.2 terceira versão de árvore
set.seed(123)
arvore2 <- rpart::rpart(medv~., 
                        data=treino,
                        control=rpart.control(maxdepth = 4, cp=0))

#Visualizar a árvore
plot <- rpart.plot::rpart.plot(arvore2,
                               box.palette = paleta) # Paleta de cores

avalia_regressao(predict(arvore2, treino), treino$medv)
avalia_regressao(predict(arvore2, validacao), validacao$medv)

# 2.3 quarta versão de árvore
set.seed(123)
arvore3 <- rpart::rpart(medv~., 
                        data=treino,
                        control=rpart.control(maxdepth = 5, cp=0))

#Visualizar a árvore
plot <- rpart.plot::rpart.plot(arvore3,
                               box.palette = paleta) # Paleta de cores

avalia_regressao(predict(arvore3, treino), treino$medv)
avalia_regressao(predict(arvore3, validacao), validacao$medv)


# Suponha que vamos ficar com esta última árvore.
# E se quisermos avaliar esta árvore na base de testes?
p3_teste <- predict(arvore3, teste)
avalia_regressao(predict(arvore3, teste), teste$medv)


# 2.4 Vamos tunar a base com o CP usando o k-fold como visto anterior
# Agregar as bases de treino e validação 
#    - o K-fold já vai fazer a validação pra nós
treino_combinado <- rbind(treino, validacao)

# Rodar uma árvore bem grande
#    vamos usar o max-depth como 30 que é o máximo
#    vamos usar CP=0, que dá a maior árvore possível
set.seed(123)
arvore_grande <- rpart::rpart(medv~., 
                        data=treino_combinado,
                        control=rpart.control(maxdepth = 30, 
                                              cp=0,
                                              xval=10))

# Não plotar essa árvore! Visualizar a árvore
# plot <- rpart.plot::rpart.plot(arvore3,
#                                box.palette = paleta) # Paleta de cores

# Esse comando nos dá todos os possíveis custos de complexidade
#   e os respectivos erros em validação cruzada (usando k-fold)
tab_cp <- rpart::printcp(arvore_grande)
# Aqui uma visualização gráfica do CP vs erro em validação cruzada
rpart::plotcp(arvore_grande)

# Com esse comando vamos pegar o melhor CP na validação cruzada
cp_min <- tab_cp[which.min(tab_cp[,'xerror']),'CP']
cp_min

# E rodar a melhor árvore
set.seed(123)
arvore_tunada <- rpart::rpart(medv~., 
                          data=treino_combinado,
                          control=rpart.control(maxdepth = 30, 
                                                cp=cp_min,
                                                xval=0))

# RECAPITULANDO: a árvore foi treinada na base consolidada
# A árvore foi tunada usando o k-fold (abrindo mão o mínimo de dados)
# Agora vamos avaliá-la na base de testes (uma base isenta)
pTunada_treino <- predict(arvore_tunada, treino_combinado) 
pTunada_teste  <- predict(arvore_tunada, teste) 

avalia_regressao(pTunada_treino, treino_combinado$medv)
# Essa é a avaliação da nossa melhor árvore na base de testes
avalia_regressao(pTunada_teste, teste$medv)


#########################################
# 3) Random Forest                      #
#########################################
# Vamos agora avaliar um Random Forest para comparar
set.seed(123)
rf <- randomForest::randomForest(
  medv ~ .,
  data = treino_combinado,
  ntree = 50
)

# Vamos avaliar esse Random Forest
# Lembra como ficou o R-quadrado na melhor árvore na base de testes?
# Compare com este aqui:
pRF_treino <- predict(rf, treino_combinado)
pRF_teste  <- predict(rf, teste)
avalia_regressao(pRF_treino, treino_combinado$medv)
avalia_regressao(pRF_teste, teste$medv)

#####################################
# 3.2) Tunando o random-forest      #
#####################################

# Definir os hiperparâmetros para o grid search
# Criar o grid de hiperparâmetros
hyperparameters <- expand.grid(mtry = c(3, 4, 5, 6, 7, 8))

# Definir a função de controle para validação cruzada
ctrl <- trainControl(method = "cv", # CV indica "k-fold cross validation"
                     number = 5)  # 5 é o número de "folds"

# Realizar o grid search com validação cruzada
set.seed(123)
gridsearch_kfold <- train(medv ~ ., 
               data = treino_combinado, 
               method = "rf", 
               trControl = ctrl, 
               tuneGrid = hyperparameters)

print(gridsearch_kfold)
plot(gridsearch_kfold)

p_rftunada <- predict(gridsearch_kfold, teste)
avalia_regressao(p_rftunada, teste$medv)


