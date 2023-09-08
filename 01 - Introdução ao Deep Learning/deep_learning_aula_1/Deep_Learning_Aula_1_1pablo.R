
quadrado_numero <- function(x){
  y <- x*x
  return(y)
  
}

quadrado_numero(7)

set.seed()

data<-read.csv(file = "winequality-red.csv")

data<-scale(data)

#train test split

train_teste_split_index <- nrow(data)*0.8

train <- data.frame(data[1:train_teste_split_index,])
test <- data.frame(data[(train_teste_split_index+1):nrow(data),])

#Padronizar dados para melhor performance
train_x <- data.frame(train[1:11])
train_y <- data.frame(train[12])

test_x <- data.frame(test[1:11])
test_y <- data.frame(test[12])

#transposição da matriz para facilitar
train_x <- t(train_x)
train_y <- t(train_y)

test_x <- t(test_x )
test_y <- t(test_y)

# Função 1 - Criar arquitetura da rede
getLayerSize <- function(X, y, hidden_neurons) {
  n_x <- dim(X)[1] #quantidade de linhas de x = neurônios da camada de entrada
  n_h <- hidden_neurons #quantidade de neurônios na camada escondida
  n_y <- dim(y)[1] #quantidade de linhas de y = neurônios da camada de saída
  
  size <- list("n_x" = n_x,
               "n_h" = n_h,
               "n_y" = n_y)
  
  return(size)
}




