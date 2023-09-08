# carregar os dados
load(file='EPA_19.RData')

# checar a estrutura
df %>% str

# colunas quantitativas para padronizar entre 0 e 1
cols <- c("fuel_economy_combined", 'eng_disp', 'num_cyl', 'num_gears', 'batt_capacity_ah')

# função para padronizar
range01 <- function(x){(x-min(x, na.rm=TRUE))/(max(x, na.rm=TRUE)-min(x, na.rm=TRUE))}

# padronizar variaveis quantitativas
df[cols] <- lapply(df[cols], range01)

df %>% head


##################### 
# Criar uma matriz de dados com somente numéricos

# criar a fórmula tipo y ~ x1 + x2 ... + xn
n <- names(df)

df %>% str

m <- model.matrix(fuel_economy_combined ~ ., data = df)
m <- as.matrix(data.frame(m, df[, 1]))

#######################################
# Criar uma fórmula para a matriz m
colnames(m)[28] <- "fuel_economy_combined"

nomes <- colnames(m)
nomes
# Treinando um Linear Perceptron
set.seed(1729)
start_time <- Sys.time() # Marca o tempo de início
nn <- neuralnet(fuel_economy_combined ~ ., # Fórmula
                data=m, # dados
                linear.output = TRUE # indica resposta contínua
                )
end_time <- Sys.time() # Marca o tempo de fim
t <- end_time - start_time # Mostra o tempo de execução
t

plot(nn)

pred <- predict(nn, m)
plot(x = pred, y = df$fuel_economy_combined)
caret::postResample(pred, df$fuel_economy_combined)

N <- nrow(m)

################################################
# Vamos fazer uma rede com camadas escondidas

start_time <- Sys.time() # Marca o tempo de início
nn <- neuralnet(fuel_economy_combined ~ ., 
                data=m, 
                hidden = c(7, 3), 
                linear.output = TRUE)
end_time <- Sys.time() # Marca o tempo de fim
t <- end_time - start_time # Mostra o tempo de execução
t

pred <- predict(nn, m)
plot(x = pred, y = df$fuel_economy_combined)
caret::postResample(pred, df$fuel_economy_combined)

###################################################### 
# Agora vamos fazer um k-fold para avaliar o modelo

# montando um k-fold
k <- 10 #número de folds
m2 = m[sample(1:nrow(m)), ] # m2 é uma permutação de m para fazermos os folds
N <- nrow(m2)

grid_camadas <- list(c(7, 3), c(7, 4))
# [1] "#########################"
# [1] "Número de camadas:  2"
# [1] "Neurônios em cada camada:"
# [1] 7 3
# [1] "Desempenho da rede na base de validação cruzada:"
# RMSE   Rsquared        MAE 
# 0.04531638 0.87066201 0.03143038 
# [1] "#########################"
# [1] "Número de camadas:  2"
# [1] "Neurônios em cada camada:"
# [1] 7 4
# [1] "Desempenho da rede na base de validação cruzada:"
# RMSE   Rsquared        MAE 
# 0.04674262 0.86338132 0.03148469 

grid_camadas <- list(c(7, 3))
# a nossa semente
set.seed(1729)

for (camadas in grid_camadas){
  print('#########################')
  print(paste('Número de camadas:    ', length(camadas)))
  print('Neurônios em cada camada:')
  print(camadas)
  
  stats <- NULL # Inicializando a qualidade dos modelos do fold
  # Inicializando o pred
  pred <- data.frame(matrix(ncol = ncol(m2), nrow = 0))
  
  for (i in 0:(k-1)){
    # A base de validação do passo i
    # Todas as observações entre i/N e (i+1)/N
    ind_cv <- seq(N)>N*(i/k) & seq(N)<=N*((i+1)/k)
    # A base de treino são todos os demais
    ind_treino <- !(seq(N)>N*(i/k) & seq(N)<=N*((i+1)/k))
    
    # Rodar a rede neural
    nn <- neuralnet(fuel_economy_combined ~ ., 
                    data=m2[ind_treino,], 
                    hidden = camadas, 
                    # threshold = 0.8,
                    linear.output = TRUE)
    
    # Classificar a base de validação cruzada
    pred_tmp <- predict(nn, m2[ind_cv,])
    pred <- rbind(pred, pred_tmp)

  }
  # Calcular medidas de desempenho
  stats_tmp <- caret::postResample(pred, m2[,28])
  # Acumular as medidas de desempenho no objeto stats
  stats <- rbind(stats, stats_tmp)
  
  print('Desempenho da rede na base de validação cruzada:')
  print(stats_tmp)
}

# Último passo: Treinar a RNA vencedora com todas as observações
nn <- neuralnet(fuel_economy_combined ~ ., 
                data=m2, 
                hidden = c(7, 3), 
                linear.output = TRUE)


# Atenção: esse plot pode ser bem pesado. 
# plot(nn)

pred <- predict(nn, m)
plot(x = pred, y = df$fuel_economy_combined)
caret::postResample(pred, df$fuel_economy_combined)

##############################
# Tunando a RNA

# CV Grid Search para 'tunar' o parâmetro decay
nnGrid <-  expand.grid(.size=7, .decay = c(0, .005, .01, 0.015, 0.02, 0.025))

ctrl <- caret::trainControl(method='cv')

nnfit <- caret::train(fuel_economy_combined ~.,
                      data=m2,
                      method='nnet',
                      tuneGrid=nnGrid,
                      trControl=ctrl,
                      maxit=1000,
                      verboseIter = FALSE
                      )

nnfit$results

modelo.final <- nnfit$finalModel

pred <- predict(modelo.final, m)
plot(x = pred, y = df$fuel_economy_combined)
caret::postResample(pred, df$fuel_economy_combined)

