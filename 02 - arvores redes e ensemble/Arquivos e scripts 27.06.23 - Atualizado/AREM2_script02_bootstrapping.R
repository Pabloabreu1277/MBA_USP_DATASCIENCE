# Gerar um dataframe com dados aleatórios
set.seed(123)  # Definir a semente para reprodução dos resultados

# Exemplo: dataframe com uma coluna chamada "dados" e 100 observações
df <- data.frame(dados = rnorm(100))

# Função para calcular o erro padrão da média
calcular_erro_padrao_media <- function(data, n_boot=1000) {
  n <- length(data)
  medias_boot <- numeric(n_boot)  # Vetor para armazenar as médias bootstrap
  
  for (i in 1:n_boot) {
    # Amostragem bootstrap
    bootstrap_sample <- sample(data, size = n, replace = TRUE)
    # Cálculo da média da amostra bootstrap
    medias_boot[i] <- mean(bootstrap_sample)
  }
  
  return(medias_boot)
}

# Chamada da função para calcular o erro padrão da média no dataframe
amostra_bootstrap <- calcular_erro_padrao_media(df$dados)

hist(amostra_bootstrap)
sd(amostra_bootstrap)

