# Exercício 1

library(dplyr)
library(RBM)

set.seed(0)

data(Fashion)


#'The labels are as follows: 
#'0: T-shirt/tops 
#'1: Trouser 
#'2: Pullover 
#'3: Dress 
#'4: Coat 
#'5: Sandal 
#'6: Shirt 
#'7: Sneaker 
#'8: Bag 
#'9: Ankle Boot 

image(matrix(Fashion$trainX[,108], nrow = 28))

Fashion$trainY[102]
Fashion$trainY[108]

#Diminui o tamanho para melhorar processamento
Fashion$trainX <- Fashion$trainX[,1:2000]
Fashion$trainY <- Fashion$trainY[1:2000]
Fashion$testX <- Fashion$testX[,1:200]
Fashion$testY <- Fashion$testY[1:200]

train <- t(Fashion$trainX)

#RBM
modelRBM <- RBM(x = train, n.iter = 1000, n.hidden = 100, size.minibatch = 10, plot = TRUE)

test <- t(Fashion$testX)

ReconstructRBM(test = test[112,], model = modelRBM)
