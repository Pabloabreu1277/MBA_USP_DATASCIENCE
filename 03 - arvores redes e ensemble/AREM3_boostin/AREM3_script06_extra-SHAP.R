##################################

library(xgboost)
library(shapr)

data("Boston", package = "MASS")

x_var <- c("lstat", "rm", "dis", "indus")
y_var <- "medv"

x_train <- as.matrix(Boston[-1:-6, x_var])
y_train <- Boston[-1:-6, y_var]
x_test <- as.matrix(Boston[1:6, x_var])

colSums(is.na(Boston))

# Ajustando um XGBoost básico
model <- xgboost(
  data = x_train,
  label = y_train,
  nround = 20,
  verbose = FALSE
)

# Prepara os dados para as explicações
explainer <- shapr(x_train, model)

# Especificar o phi_0, i.e. as previsões sem nenhuma variável
p <- mean(y_train)

# Computando os valores do Shapley
# Valores empíricos condicionais
explanation <- explain(
  x_test,
  approach = "empirical",
  explainer = explainer,
  prediction_zero = p
)

# Imprimindo os valores Shap para a base de testes.
print(explanation$dt)

# Plotar os resultados para as observações 1 e 6
plot(explanation, plot_phi0 = FALSE, index_x_test = c(1, 6))

# Para mais, consultar :
#   https://cran.r-project.org/web/packages/iml/vignettes/intro.html
#   https://bradleyboehmke.github.io/HOML/iml.html
