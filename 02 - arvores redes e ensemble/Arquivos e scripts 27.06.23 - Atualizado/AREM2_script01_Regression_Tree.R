#########################################
# Árvore com variável resposta contínua #


############################
# 1.0 Gerando os dados
############################
# x é uma sequencia de valores entre 0 e 1
set.seed(2360873)
x <- seq(0,1, length.out=1000)

# y segue uma relação quadrática
a <- 0
b <- 10
c <- -10

y <- a + b*x + c*x**2 + rnorm(length(x), mean=0, sd=.1)

df <- data.frame(x, y)

p0 <- ggplot(df, aes(x,y)) + 
  geom_point(aes(colour='Observado')) +
  scale_color_viridis(discrete=TRUE, begin=0, end=.85, name = "Valor") +
  theme(legend.position="bottom",
        legend.spacing.x = unit(0, 'cm'))
p0

########################
# 1.1 Construindo a árvore #
########################
tree <- rpart(y~x, 
              data=df,
              control=rpart.control(maxdepth = 2, cp=0))

# Valores preditos
df['p'] = predict(tree, df)
df$p %>% tail # investigar a previsão

df['r'] = df$y - df$p

# Plotando a árvore
plota_arvore <- function(arvore_){
  # paleta
  paleta <- scales::viridis_pal(begin=.75, end=1)(20)
  #definir a figura
  plot <- rpart.plot::rpart.plot(arvore_,
                         box.palette = paleta) # Paleta de cores
}
plota_arvore(tree)

#########################################
# 1.2 Calculando indicadores de avaliação
# Cálculo do SQE (Sum of Squares Error)
#####################################
n <- dim(df)[1]
SQE <- sum((df$y - df$p)**2)
QME <- SQE/n

# Cálculo do SST (Sum of Squares Total)
SST <- sum((df$y - mean(df$y))**2)
SST
QMT <- SST/n
# Cálculo do R-quadrado
R_squared <- 1 - SQE/SST

# Imprimindo os resultados
cat("SQE: ", SQE, "QME <var(e)>: ", QME, "\n")
cat("SST: ", SST, "QMT: <var(y)>", QMT, "\n")
cat("R-quadrado: ", R_squared, "\n")
?mean
# Transformando tudo isso numa função
metricas <- function(df_in, p_var, y_var){
  n <- dim(df_in)[1]
  SQE <- sum((df_in[y_var] - df[p_var])^2)
  QME <- SQE/n

  # Cálculo do SSE (Sum of Squares Total)
  SST <- sum((df_in[y_var] - (df_in[y_var] %>% sum)/n)**2)
  QMT <- SST/n
  
  # Cálculo do R-quadrado
  R_squared <- 1 - SQE/SST
  
  # Imprimindo os resultados
  cat("SQE: ", SQE, "QME : ", QME, "\n")
  cat("SST: ", SST, "QMT: ", QMT, "\n")
  cat("R-quadrado: ", R_squared, "\n")
  
}

metricas(df, "p", "y")

#################################
# 1.3 Análise gráfica
#################################

# Função para fazer plot x vs y com cor em z
scatterplot_color <- function(data, x_var, y_var, r_var) {
  ggplot(data) +
    geom_point(aes(x = !!sym(x_var), y = !!sym(y_var), color = !!sym(r_var))) +
    theme(legend.position="bottom") +
    ggtitle("Scatterplot") +
    scale_color_viridis_c()
}

# Exemplo de utilização da função
scatterplot_color(df, "p", "y", "r")

# Valores esperados e observados


grafico_x_obs_esp <- function(df_in, x_var, y_var, p_var, r_var){
  arvore_vs_E <- ggplot(df_in) + 
    geom_point(alpha=.7, size=.5, aes(!!sym(x_var),!!sym(y_var), color=!!sym(r_var))) +
    scale_color_viridis_c() +
    geom_path(aes(!!sym(x_var),!!sym(p_var))) + #Ploting
    theme_bw() +
    theme(legend.position="bottom") +
    # guides(colour = guide_legend(label.position = "bottom")) +
    labs(title="Valores observados vs esperados")
  arvore_vs_E
}

graf1 <- grafico_x_obs_esp(df, "x", "y", "p", "r")
graf1
# Gráfico de resíduos
graf2 <- scatterplot_color(df, "x", "r", "r")
graf2

# Consolidar 2 gráficos em uma figura
analise_grafica <- function(df_in, x_var, y_var, p_var, r_var){
  # Gráfico 1: x vs y colorido por resíduos + valores esperados
  gr1 <- grafico_x_obs_esp(df_in, x_var, y_var, p_var, r_var)
  # Gráfico2 de x vs resíduos colorido por resíduos
  gr2 <- scatterplot_color(df, x_var, r_var, r_var)
  # gr2
  # painel com os dois gráficos
  ggpubr::ggarrange(gr1, gr2,
                    # labels = c("A", "B"),
                    ncol = 2, nrow = 1)
}
# painel com os dois gráficos
analise_grafica(df, "x", "y", "p", "r")


#######################################
### Parte 2: Tunando a árvore
###
### Passos:
###    1) Treinar uma árvore sem travas
###    2) Observar a complexidade dos caminhos da árvore (cp)
###    3) Escolher o CP que otimiza o erro dessa árvore
###    4) Avaliar a árvore tunada

######################################
# 2.1 treinar a árvore sem travas
######################################

tree_hm <- rpart(y~x, 
              data=df,
              xval=10,
              control = rpart.control(cp = 0, 
                                      minsplit = 2,
                                      maxdepth = 30)
              )

df['p_hm'] = predict(tree_hm, df)
df$p %>% tail # investigar a previsão
df['r_hm'] = df$y - df$p_hm

######################################
# 2.2 avaliar a árvore hm
######################################

metricas(df, "p_hm", "y")
scatterplot_color(df, "p_hm", "y", "r_hm")
analise_grafica(df, "x", "y", "p_hm", "r_hm")

#
#
# NÃO TENTE PLOTAR ESTA ÁRVORE
#
#

######################################
# 2.3 Complexidade dos caminhos
######################################

tab_cp <- rpart::printcp(tree_hm)
rpart::plotcp(tree_hm)

######################################
# 2.4 Escolher o caminho que otimiza a impureza no cross validation
######################################

tab_cp[which.min(tab_cp[,'xerror']),]

cp_min <- tab_cp[which.min(tab_cp[,'xerror']),'CP']
cp_min

tree_tune <- rpart(y~x, 
              data=df,
              xval=0,
              control = rpart.control(cp = cp_min, 
                                      maxdepth = 30)
)
# Valores preditos
df['p_tune'] = predict(tree_tune, df)
df$p %>% tail # investigar a previsão
df['r_tune'] = df$y - df$p_tune


##############################################
## 2.5) Avaliar a árvore tunada
##############################################
metricas(df, "p_tune", "y")
scatterplot_color(df, "p_tune", "y", "r_tune")
analise_grafica(df, "x", "y", "p_tune", "r_tune")

