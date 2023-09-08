################################################
# XGBoosting                                ####

# Buscar reprodutibilidade
set.seed(2360873)
load("titanic.Rda")
colSums(is.na(titanic))

# Gera 80% de 1´s e 20% de 2´s para separar as amostras
n <- sample(1:2, # vamos amostrar elementos do conjunto c(1,2)
            size=nrow(titanic), # O tamanho da amostragem é 891
            replace=TRUE, # Amostragem com reposição (de c(1,2))
            prob=c(0.8,0.2)) # A probabilidade de ser 1 é 80%, de ser 2 é 20%

######################################
# Dividir amostras de treino e teste #

# Amostra de treino: n==1 (os 80%)
treino <- titanic[n==1,]
# Amostra de teste: n==2 (os 20%)
teste <- titanic[n==2,]

# parâmetros do trainControl
#number: number of folds or resampling iterations
#repeats: for repeated k-fold cross-validation, the number of complete sets of folds to compute
tempo_ini <- Sys.time()

controle <- caret::trainControl(
  "cv",
  number = 10,
  summaryFunction = twoClassSummary, # Função de avaliação de performance
  classProbs = TRUE # Necessário para calcular a curva ROC
)
# trainControl("cv", 
#              number = 10)
grade_de_busca <- expand.grid(
  nrounds = c(50, 100, 150),
  max_depth = c(2, 3),
  gamma = c(0),
  eta = c(0.1, 0.4),
  colsample_bytree = c(0.6, 0.8),
  min_child_weight = c(1),
  subsample = c(0.75, 1)
)
set.seed(2360873)
modelo <- caret::train(
  Survived ~., 
  data = treino, 
  method = "xgbTree",
  trControl = controle,
  tuneGrid = grade_de_busca,
  verbosity = 0)

modelo

tempo_fim <- Sys.time()
tempo_fim - tempo_ini

###################################
# Avaliar o XGBoosting            #
###################################
avalia <- function(modelo, nome_modelo="modelo"){
  p_treino <- predict(modelo, treino, type='prob') # Probabilidade predita
  c_treino <- predict(modelo, treino)              # Classificação
  
  #Base de teste
  p_teste <- predict(modelo, teste, type='prob')
  c_teste <- predict(modelo, teste)
  
  # Data frame de avaliação (Treino)
  aval_treino <- data.frame(obs=treino$Survived, 
                            pred=c_treino,
                            Y = p_treino[,2],
                            N = 1-p_treino[,2]
  )
  
  # Data frame de avaliação (Teste)
  aval_teste <- data.frame(obs=teste$Survived, 
                           pred=c_teste,
                           Y = p_teste[,2],
                           N = 1-p_teste[,2]
  )
  
  tcs_treino <- caret::twoClassSummary(aval_treino, 
                                       lev=levels(aval_treino$obs))
  tcs_teste <- caret::twoClassSummary(aval_teste, 
                                      lev=levels(aval_teste$obs))
  ##########################
  # Curva ROC              #
  
  CurvaROC <- ggplot2::ggplot(aval_teste, aes(d = obs, m = Y, colour='1')) + 
    plotROC::geom_roc(n.cuts = 0, color="blue") +
    plotROC::geom_roc(data=aval_treino,
                      aes(d = obs, m = Y, colour='1'),
                      n.cuts = 0, color = "red") +
    scale_color_viridis_d(direction = -1, begin=0, end=.25) +
    theme(legend.position = "none") +
    ggtitle(paste("Curva ROC | ", nome_modelo, " | AUC-treino=",
                  percent(tcs_treino[1]),
                  "| AUC_teste = ",
                  percent(tcs_teste[1]))
    )
  
  print('Avaliação base de treino')
  print(tcs_treino)
  print('Avaliação base de teste')
  print(tcs_teste)
  CurvaROC
}
avalia(modelo, nome_modelo="XGBoosting")
