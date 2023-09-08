library("devtools")

#Mostrar pacote no GITHUB
#https://github.com/TimoMatzen/RBM


install_github("TimoMatzen/RBM")
library("RBM")

#Vamos dar uma olhada na imagem
# visualize the digits
data(MNIST)
image(matrix(MNIST$trainX[2, ], nrow = 28))
MNIST$trainY[2]

set.seed(0)
train <- MNIST$trainX
modelRBM <- RBM(x = train, n.iter = 1000, n.hidden = 100, size.minibatch = 10, plot = TRUE)

#Reconstroi uma imagem
set.seed(0)
test <- MNIST$testX
testY <- MNIST$testY

test[100,]
testY[5]

ReconstructRBM(test = test[100, ], model = modelRBM)

#DBN
set.seed(0)
library(devtools)
library(RBM)

set.seed(0)

train <- MNIST$trainX
test <- MNIST$testX
#stack empilhamento de camadas
modStack <- StackRBM(x = train, layers = c(100, 100, 100), n.iter = 1000, size.minibatch = 10)
testY[3]
ReconstructRBM(test = test[3, ], model = modStack, layers = 3)

# Teste 2 - Classificar Imagens - uso da atriz de confusão

library(devtools)
library(RBM)

#Ler Artigo:
#Larochelle, H., Mandel, M., Pascanu, R., & Bengio, Y. (2012). Learning algorithms for the classification restricted boltzmann machine. Journal of Machine Learning Research, 13(Mar), 643-669.
#Vamos dar uma olhada na imagem
# visualize the digits
data(MNIST)
MNIST$trainY[102]

image(matrix(MNIST$trainX[102, ], nrow = 28))

# 5 - Acha matriz de confusão/medição da acuracia
set.seed(0)
train <- MNIST$trainX
TrainY <- MNIST$trainY

modelClassRBM <- RBM(x = train, y = TrainY, n.iter = 1000, n.hidden = 100, size.minibatch = 10)

test <- MNIST$testX
TestY <- MNIST$testY

p <- PredictRBM(test = test, labels = TestY, model = modelClassRBM)

p
