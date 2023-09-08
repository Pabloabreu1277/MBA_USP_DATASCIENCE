#########################################
# Árvore com variável resposta contínua #
# Esse código é continuação do script01 #
#########################################

#################################################################
# 1) Gerando os dados                                           #
# Vamos gerar apenas duas variáveis,                            #
# X, entre 0 e 1, e y como um polinômio de segundo grau em X    #
#################################################################

# x é uma sequencia de valores entre 0 e 1
x <- seq(0,1, length.out=1000)

# y segue uma relação quadrática com estes coeficientes
a <- 0
b <- 10
c <- -10

set.seed(2360873)
# Gerando y
y <- a + b*x + c*x**2 + rnorm(length(x), mean=0, sd=.1)

#juntando ambos em um data frame
df <- data.frame(x, y)

###################################
# 1.1) Primeiro gráfio de X por Y #
###################################


p0 <- ggplot(df, aes(x,y)) + 
  geom_point(aes(colour='Observado')) +
  scale_color_viridis(discrete=TRUE, begin=0, end=.85, name = "Valor") +
  theme(legend.position="bottom",
        legend.spacing.x = unit(0, 'cm')) +
  labs(title="Dispersão de X vs Y")

p0

###############################
# Boosting: 
# Vamos construir uma árvore e calcular o erro
# A próxima árvore vai tentar ajustar o erro da primeira
# Podemos fazer mais e mais árvores em sequencia
# Esta é a ideia básica do boosting
###############################


##############################################
# 2) Construindo a primeiraárvore            #
# Esta árvore terá profundidade máxima = 2   #
##############################################
tree <- rpart(y~x, # Modelo: y como resposta e x como única explicativa
              data=df, # nosso dataframe
              control=rpart.control(maxdepth = 2, cp=0)# hiperparâmetros
              )

# Plotando a árvore
paleta = scales::viridis_pal(begin=.75, end=1)(20)
rpart.plot::rpart.plot(tree,
                       box.palette = paleta) # Paleta de cores

# Valores preditos
df['p'] = predict(tree, df)
# calculando os erros
df['r'] = df$y - df$p

#####################################
# 2.1 Visualização gráfica          #
# Valores esperados e observados    #
# sobrepostos com a previsão        #
#####################################
boost0_O_vs_E <- ggplot(df, aes(x,y)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Observado')) +
  geom_path(aes(x,p, colour='Predito')) + #Ploting
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  theme_bw() +
  theme(legend.position="bottom") +
  # guides(colour = guide_legend(label.position = "bottom")) +
  labs(title="Valores observados vs preditos") +
  scale_y_continuous(name= "y") +
  scale_x_continuous(name= "x")

boost0_O_vs_E

# Gráfico de resíduos
boost0_res <- ggplot(df) + 
  geom_point(alpha=.7, size=.5, aes(colour='Resíduo', x,r)) +
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  theme_bw() +
  theme(legend.position="bottom") +
  labs(title="Gráfico de resíduos") +
  scale_y_continuous(name= "r") +
  scale_x_continuous(name= "x")
boost0_res

# plotando os dois gráficos lado a lado
ggpubr::ggarrange(boost0_O_vs_E, boost0_res, 
                  ncol = 2, nrow = 1)

##############################################
# 3) Primeira interação do boosting          #
# Esta árvore terá profundidade máxima = 2   #
##############################################
tree1 <- rpart(r~x, 
               data=df,
               control=rpart.control(maxdepth = 2, cp=0))

df['p1'] = predict(tree1, df)  # Predito da árvore neste passo
df['P1'] = df$p + df$p1        # Predito do boosting (acumulado)
df['r1'] = df$r - df$p1        # resíduo do boosting


##############################################
# 3.1 Gráfico da primeira iteração de boosting manual
# O QUE O MODELO ESTÁ FAZENDO
boost1_r_vs_E <- ggplot(df, aes(x,r)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Observado')) +
  geom_path(aes(x,p1, colour='Predito')) + #Ploting
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Variável resposta neste passo") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "r - Resíduo 1") +
  scale_x_continuous(name= "x")

# O QUE ACONTECE COM O MODELO FINAL
boost1_O_vs_E <- ggplot(df, aes(x,y)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Observado')) +
  geom_path(aes(x,P1, colour='Predito')) + #Ploting
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Observado vs Predito (final)") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "y") +
  scale_x_continuous(name= "x")

# Primeira árvore, segunda árvore e a composição geral
ggpubr::ggarrange(boost0_O_vs_E, boost1_r_vs_E, boost1_O_vs_E,
                  ncol = 3, nrow = 1)

# Gráfico de resíduos
boost1_r <- ggplot(df, aes(x,r1)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Resíduo')) +
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Gráfico de resíduos (final)") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "r") +
  scale_x_continuous(name= "x")

# Visualizando três coisas:
  # - O que foi modelado nesta etapa, 
  # - O resultado nos dados originais
  # - O que restou de erro

ggpubr::ggarrange(boost1_r_vs_E, boost1_O_vs_E, boost1_r,
                  # labels = c("A", "B"),
                  ncol = 3, nrow = 1)

###################################################
# Terceira iteração do boosting
# A árvore é montada para prever o que restou de erro na etapa anterior
tree2 <- rpart(r1~x, 
               data=df,
               control=rpart.control(maxdepth = 2, cp=0))

df['p2'] = predict(tree2, df) # predito da árvore tree2
df['P2'] = df$P1 + df$p2      # predito do boosting neste passo
df['r2'] = df$r1 - df$p2      # resíduo da árvore neste passo (resíduo do boosting)
# df['r2'] = df$y - df$P2     # O mesmo que a linha acima


# Gráfico da primeira iteração de boosting manual
# O QUE O MODELO ESTÁ FAZENDO
boost2_r_vs_E <- ggplot(df, aes(x,r1)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Observado')) +
  geom_path(aes(x,p2, colour='Predito')) + #Ploting
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Variável resposta neste passo") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "y(i)") +
  scale_x_continuous(name= "x")


# Visualização do modelo final nos dados originais
boost2_O_vs_E <- ggplot(df, aes(x,y)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Observado')) +
  geom_path(aes(x,P2, colour='Predito')) + #Ploting
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Observado vs Predito (final)") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "y") +
  scale_x_continuous(name= "x")

# O que restou de erro nesta etapa
boost2_r <- ggplot(df, aes(x,r2)) + 
  geom_point(alpha=.7, size=.5, aes(colour='Resíduo')) +
  scale_color_viridis(discrete=TRUE, begin=0, end=.8, name = "Dado: ") +
  labs(title="Gráfico de resíduos (final)") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_y_continuous(name= "r") +
  scale_x_continuous(name= "x")

boost2_O_vs_E

###################################
# Modelo final na etapa anterior
# O 'totozinho' a ser aplicado nesta etapa
# O resultado final
ggpubr::ggarrange(boost1_O_vs_E, boost2_r_vs_E, boost2_O_vs_E,
                  # labels = c("A", "B"),
                  ncol = 3, nrow = 1)


###################################
# O 'totozinho' a ser aplicado nesta etapa
# O resultado final
# O que restou de resíduo nesta etapa
ggpubr::ggarrange(boost2_r_vs_E, boost2_O_vs_E, boost2_r,
                  # labels = c("A", "B"),
                  ncol = 3, nrow = 1)

