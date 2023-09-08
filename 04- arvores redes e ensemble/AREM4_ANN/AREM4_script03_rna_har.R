#####################################
# Rodar uma random forest inicial

# Arrumando a variável resposta
niveis = c("andando",  "subindo", "descendo", "sentado",  "em_pe", "deitado")
levels(HAR_train$y) <- niveis
levels(HAR_test$y) <- niveis

tempo_ini <- Sys.time()
set.seed(2244000)
rf <- randomForest::randomForest(y ~ ., # Variáveis do modelo
                   data=HAR_train[,2:563], # Dados (pula a primeira coluna "y")
                   ntree=50, # Número de árvores
                   mtry=100, # Variáveis por passo
                   subsample=0.8) # Tamanho da amostragem bootstrap

# Fim do cronômetro
tempo_fim <- Sys.time()
tempo_fim - tempo_ini

rf

# Gerar as previsões do modelo
pred <- predict(rf, HAR_test[,2:563])

# Gerar a matriz de confusão e estatísticas
cm <- caret::confusionMatrix(pred, HAR_test$y)
cm

# Gerar um data frame temporário para avaliar o modelo
rf_aval <- data.frame(
  pred = predict(rf, HAR_test[,2:563]),
  obs = HAR_test$y
)

# Calcular métricas de avaliação
multiClassSummary(rf_aval, lev = niveis)

# Predição da árvore
c_test <- predict(rf, HAR_test)
c_test[1:10]


#######################

# Observando as importâncias das variáveis
rf %>% names
rf$importance

rf$importance %>% summary

tmp = as.data.frame(rf$importance)
tmp$variaveis <- rownames(tmp)
tmp_ord <- tmp[rev(order(tmp$MeanDecreaseGini)),]
tmp_ord[1:10,]

variaveis_selecionadas <- rf$importance %>% as.data.frame() %>% top_n(6) %>% row.names

variaveis_selecionadas

HAR_train$y %>% table

nnGrid <-  expand.grid(.size=c(6), .decay = c(0))

ctrl <- caret::trainControl(method='cv', number=4, classProbs=TRUE)

nnfit <- caret::train(y ~ .,
                      data=HAR_train[,c(variaveis_selecionadas, 'y')],
                      method='nnet',
                      metric='Accuracy',
                      tuneGrid=nnGrid,
                      trControl=ctrl,
                      maxit=100,
                      verboseIter = FALSE
)

# Resultados do grid search
nnfit$results

# Gerar um data frame temporário para avaliar o modelo
nnfit_aval <- data.frame(
  pred = predict(nnfit, HAR_test[,2:563]),
  obs = HAR_test$y
)
nnfit_aval
# Calcular métricas de avaliação
multiClassSummary(nnfit_aval, lev = niveis)

