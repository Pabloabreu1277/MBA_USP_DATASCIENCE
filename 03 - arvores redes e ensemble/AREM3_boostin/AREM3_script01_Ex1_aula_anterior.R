####################################################
# Tarefa para casa:
# carregar a base tips conforme abaixo
# ajustar uma árvore de regressão para classificar
# o valor do percentual da gorjeta conforme
# as variáveis disponíveis

# A base de dados que vamos usar está na liv 'reshape2'
# library("reshape2")

data(tips)

tips %>% head

# 1) construir o percentual de gorjeta
tips$pct_tip <- tips$tip/(tips$total_bill - tips$tip)

boxplot(tips$pct_tip)
# Criando o boxplot com ggplot2
ggplot(tips, aes(x = "", y = pct_tip)) +
  geom_boxplot(fill = viridis_pal(begin=1)(0.15)) +
  labs(title = "Boxplot da variável pct_tip") +
  theme_minimal()

# Eliminando o outlier:
#  Vamos filtrar valores de gorjeta menores que 100%
tips <- tips[tips$pct_tip<1,]

# Repetindo o boxplot
ggplot(tips, aes(x = "", y = pct_tip)) +
  geom_boxplot(fill = viridis_pal(begin=1)(0.15)) +
  labs(title = "Boxplot da variável pct_tip") +
  theme_minimal()

# Etapa descritiva
#   Quais variáveis parecem explicar o percentual da gorjeta?
descritiva2("sex", "pct_tip", tips)
descritiva2("smoker", "pct_tip", tips)
descritiva2("day", "pct_tip", tips)
descritiva2("size", "pct_tip", tips)
tips$total_bill_cat <- quantcut(tips$total_bill, 5)
descritiva2("total_bill_cat", "pct_tip", tips)

# 2) treinar a árvore (não incluir o valor da gorjeta como explicativa)
set.seed(123)
arvore_reg <- rpart::rpart(pct_tip ~  sex 
                           + smoker 
                           + day 
                           + time 
                           + size,
                           data=tips,
                           xval=10,
                           control = rpart.control(cp = 0, 
                                                   minsplit = 2,
                                                   maxdepth = 2)
)

paleta <- scales::viridis_pal(begin=.75, end=1)(20)
#Visualizar a árvore
plot <- rpart.plot::rpart.plot(arvore_reg,
                               box.palette = paleta) # Paleta de cores
# Pergunta interpretativa: Quais mesas você priorizaria?


# Avaliar a árvore (R-quad)
# função auxiliar de avaliação
metricas <- function(p_var, y_var){
  SQE <- sum((y_var - p_var)**2)

  # Cálculo do SSE (Sum of Squares Total)
  SST <- sum((y_var - mean(y_var))**2)

  # Cálculo do R-quadrado
  R_squared <- 1 - SQE/SST
  
  # Imprimindo os resultados
  cat("SQE: ", SQE, "QME : ", SQE/length(y_var), "\n")
  cat("SST: ", SST, "QMT: ", SST/length(y_var), "\n")
  cat("R-quadrado: ", R_squared, "\n")
  
}

# Calcular o R-quadrado
metricas(predict(arvore_reg, tips), tips$pct_tip)


# vamos otimizar a árvore
set.seed(123)
arvore_grande <- rpart::rpart(pct_tip ~  sex 
                           + smoker 
                           + day 
                           + time 
                           + size,
                           data=tips,
                           xval=10,
                           control = rpart.control(cp = 0, 
                                                   minsplit = 2,
                                                   maxdepth = 30)
)

# Calcular o R-quadrado
metricas(predict(arvore_grande, tips), tips$pct_tip)

# Vamos achar o hiperparâmetro ótimo para o CP:
# Esta linha guarda todos os valores de CP para cada folha da árvore grande
tab_cp <- rpart::printcp(arvore_grande)
# Aqui uma visualização gráfica do CP vs erro em validação cruzada
rpart::plotcp(arvore_grande)

# Com esse comando vamos pegar o melhor CP na validação cruzada
cp_min <- tab_cp[which.min(tab_cp[,'xerror']),'CP']
cp_min

set.seed(123)
arvore_tunada <- rpart::rpart(pct_tip ~  sex 
                              + smoker 
                              + day 
                              + time 
                              + size,
                              data=tips,
                              xval=20,
                              control = rpart.control(cp = cp_min, 
                                                      minsplit = 2,
                                                      maxdepth = 30)
)
metricas(predict(arvore_tunada, tips), tips$pct_tip)

#Visualizar a árvore tunada:
plot <- rpart.plot::rpart.plot(arvore_tunada,
                               box.palette = paleta) # Paleta de cores


