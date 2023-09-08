#############################################
# Modelagem de 'human activity recognition' #
#############################################


#############################################
# Etapa 1 - tratamento dos dados            #
#############################################

# o único tratamento aqui é deixar a variável resposta como factor
# e eliminar a variável y
load("HAR_train.RData")
load("HAR_test.RData")
HAR_train %>% colnames

# transformando a variável em fator
HAR_train$V1 <- as.factor(HAR_train$V1)
levels(HAR_train$V1) <- c("andando",  "subindo", "descendo", "sentado",  "em_pe", "deitado")

HAR_test$V1 <- as.factor(HAR_test$V1)
levels(HAR_test$V1) <- c("andando",  "subindo", "descendo", "sentado",  "em_pe", "deitado")

# Avaliando a variável resposta
HAR_train$V1 %>% table

HAR_train %>% colnames

# eliminando a variável y
HAR_train <- subset(HAR_train, select = -y)
HAR_test <- subset(HAR_test, select = -y)


#############################################
# Etapa 2 - descritiva básica               #
#############################################
#############################################
# Criar o boxplot
ggplot(HAR_train) +
  geom_boxplot(aes(x = V1, y = HAR_train[,2])) +
  xlab("Atividade realizada") +
  ylab(colnames(HAR_train)[2]) +
  ggtitle("Aceleração média(x) por atividade")

ggplot(HAR_train) +
  geom_boxplot(aes(x = V1, y = HAR_train[,4])) +
  xlab("Atividade realizada") +
  ylab(colnames(HAR_train)[2]) +
  ggtitle("Aceleração média(x) por atividade")

ggplot(HAR_train) +
  geom_boxplot(aes(x = V1, y = HAR_train[,15])) +
  xlab("Atividade realizada") +
  ylab(colnames(HAR_train)[2]) +
  ggtitle("Aceleração média(x) por atividade")

#############################################
# Etapa 3 - treinar o modelo                #
#############################################


# Seleção de variáveis
# Um ótimo método de se fazer seleção de variáveis é utilizando
# as 'variable importances' fornecidas pela árvore tradicional
set.seed(1729)
arvore <- rpart::rpart(V1 ~ .,
             data=HAR_train,
             control = rpart.control(cp = 0.1, 
                                     minsplit = 2,
                                     maxdepth = 6)
)

variaveis <- arvore$variable.importance %>% sort %>% names
variaveis <- variaveis[1:3]
variaveis
# trainControl("cv", 
#              number = 10)

controle <- caret::trainControl(
  "cv",
  number = 2,
  summaryFunction = multiClassSummary, # Função de avaliação de performance
  classProbs = TRUE # Necessário para calcular a curva ROC
)

grade_de_busca <- expand.grid(
  nrounds = c(50),
  max_depth = c(1, 4),
  gamma = c(0),
  eta = c(0.05, 0.4),
  colsample_bytree = c(.7),
  min_child_weight = c(1),
  subsample = c(.7)
)

# inicia o cronometro
tempo_ini <- Sys.time()

# roda o modelo
set.seed(1729)
modelo <- caret::train(
  V1 ~ ., 
  data = HAR_train[,c(variaveis, "V1")], 
  method = "xgbTree",
  trControl = controle,
  tuneGrid = grade_de_busca,
  verbosity = 0
)
# finaliza o cronometro
tempo_fim <- Sys.time()
tempo_fim - tempo_ini

# output do modelo
modelo

class_HAR_train <- predict(modelo, HAR_train)
class_HAR_test <- predict(modelo, HAR_test)

acc_treino <- sum(class_HAR_train == HAR_train$V1)/nrow(HAR_train)
acc_treino

acc_teste <- sum(class_HAR_test == HAR_test$V1)/nrow(HAR_test)
acc_teste


###########################################
# Para casa:
# 1) Veja se você consegue melhorar este XGB
# 2) Ajuste uma Random Forest
# 3) Compare os resultados
# 4) Veja se consegue colocar mais uma variável
# 5) Reflita sobre o desafio de equilibrar execução e desempenho

