#install.packages("MASS")
library("MASS")
library("rpart")

#uso de benchmark para validar produtização

set.seed(0)

#Baixa os dados
data <- Boston

#Uma olhada nos dados
head(data)
#Temos valores nulos?
data[is.na(data) == TRUE]

#Train-Test Split
train_test_split_index <- 0.8 * nrow(data)

train <- data.frame(data[1:train_test_split_index,])
test <- data.frame(data[(train_test_split_index+1): nrow(data),])

#CART

# árvore
fit_tree <- rpart(medv ~.,method="anova", data=train)
tree_predict <- predict(fit_tree,test)
mse_tree <- mean((tree_predict - test$medv)^2)

#Padronizar dados para melhor performance
#Explicar apply
set.seed(0)
max_data <- apply(data, 2, max) 
min_data <- apply(data, 2, min)
scaled <- scale(data,center = min_data, scale = max_data - min_data)

index = sample(1:nrow(data),round(0.70*nrow(data)))
train_data <- as.data.frame(scaled[index,])
test_data <- as.data.frame(scaled[-index,])

library(neuralnet)

#abrir o CRAN para mostrar

#Fit de neuralnet
#Executar testes com diferentes arquiteturas
nn <- neuralnet(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat,data=train_data,hidden=c(5,4,3,2),
linear.output=T)
plot(nn)


pr.nn <- compute(nn,test_data[,1:13])
pr.nn_ <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test_data$medv)*(max(data$medv)-min(data$medv))+min(data$medv)
MSE_nn <- mean((pr.nn_ - test.r)^2)


#Plot

plot(test_data$medv,type = 'l',col="red",xlab = "x", ylab = "Valor Residencia")
lines(pr.nn$net.result,col = "blue")
########################################################
#Exercicio 1)

library(ISLR)
library(neuralnet)


#Olhar os dados - data wrangling?
data <- College
#is.na(data)
#View(data)

#private = as.numeric(College$Private)-1
private <- ifelse(data$Private == 'Yes', 1, 0)

#Padronizar dados para melhor performance
data <- data[,2:18]
max_data <- apply(data, 2, max) 
min_data <- apply(data, 2, min)
scaled <- data.frame(scale(data,center = min_data, scale = max_data - min_data))

#Inclui variável explicada (target)
scaled$Private <- private


set.seed(0)
#train test split
index = sample(1:nrow(data),round(0.70*nrow(data)))
train_data <- as.data.frame(scaled[index,])
test_data <- as.data.frame(scaled[-index,])

#Utiliza o neuralnet
set.seed(0)
n = names(train_data)
f <- as.formula(paste("Private ~", paste(n[!n %in% "Private"], collapse = " + ")))
nn <- neuralnet(f,data=train_data,hidden=c(5,4),linear.output=F)
plot(nn)

pr.nn <- compute(nn,test_data[,1:17])
#Explica sapply
pr.nn$net.result <- sapply(pr.nn$net.result,round,digits=0)
pr.nn$net.result

table(test_data$Private,pr.nn$net.result)

Acc <- (61+152) / (61+152+8+12)

#CART comparação

set.seed(0)

# árvore
fit_tree <- rpart(f,method="class", data=train_data)
tree_predict <- predict(fit_tree,test_data,type = "class")
table(test_data$Private,tree_predict)

Acc_tree <- (58+159) / (58+159+11+5)





