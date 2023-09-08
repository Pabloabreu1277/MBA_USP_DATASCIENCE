library(tidyverse)
library(lubridate)
library(stringr)
library(viridis)

getwd()
arquivo <- "cubo-20230626-utf8.csv"

dados <- read.delim(arquivo, header = TRUE, sep = ";")
dados %>% head

# Eliminando a terceira coluna
dados <- dados[,-3]

# Convertendo campo de data em tipo data
dados$Data <- as.POSIXct(dados$Data, format = "%d/%m/%Y %H:%M")

dados %>% head
dados %>% tail

# Eliminar linhas vazias
ultima_linha = which(is.na(dados$Data))[1]-1
ultima_linha
dados <- dados[1:ultima_linha,]

dados %>% dim
dados %>% head



# Convertendo a variável resultado em um tempo em segundos
dados <- dados %>%
  mutate(Resultado = case_when(
    str_detect(Resultado, ":") ~ {
      min_sec <- str_split(Resultado, ":", simplify = TRUE)
      as.numeric(min_sec[, 1]) * 60 + as.numeric(min_sec[, 2])
    },
    TRUE ~ as.numeric(Resultado)
  ))

head(dados)
dados %>% str

# Checando por missings
dados %>% is.na %>% sum

dados['Ordem'] <- seq(1:ncol(dados))
dados['OrdemInv'] <- nrow(dados) - seq(1:nrow(dados)) + 1
dados %>% colnames
colnames(dados) <- c("DataHora", "Resultado", "Ordem", "OrdemInv")

# Extrair a data e a hora
dados <- dados %>%
  mutate(Data = as.Date(DataHora), # extrair somente a data
         Horario = format(DataHora, "%H:%M:%S"))  # extrair somente a hora

dados %>% head

# Cria o sequencial do treino no dia
j <- 1
dados['OrdemDia'] = 1
for (i in 2:nrow(dados)){
  if (dados[i,'Data'] == dados[i-1,'Data']){
    print('Atualiza J')
    j <- j+1
  }
  else{
    print('Zera J')
    j <- 1
  }
  dados[i,'OrdemDia'] <- j
}

# Cria a variável DiaDeTreino
dados <- dados %>%
  arrange(Data) %>% # Garante que os dados estão ordenados por data
  mutate(DiaDeTreino = as.integer(as.factor(Data))) # Cria a variável DiaDeTreino

dados

# Plotar os resultados conforme os treinos
ggplot(dados, aes(x = OrdemInv, y = Resultado)) +
  geom_line(color = viridis(1)) +
  labs(x = "Ordem", y = "Resultado") +
  theme_minimal()

# Plotar os resultados conforme a data
ggplot(dados, aes(x = as.factor(as.Date(Data, format = "%d/%m/%Y")), y = Resultado)) +
  geom_boxplot() +
  labs(x = "Data", y = "Resultado") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))

# Define o controle de validação cruzada com 10 partições
ctrl <- trainControl(method = "cv", number = 10)

# Ajusta o modelo de Random Forest com validação cruzada
rf <- train(Resultado ~ Ordem + OrdemDia + DiaDeTreino, 
            data = dados, 
            method = "rf", 
            trControl = ctrl,
            ntree=1000)

# Imprime o resumo do modelo
print(rf)

# Obtém as previsões do modelo no conjunto de teste
predicoes <- predict(rf, newdata = dados)
