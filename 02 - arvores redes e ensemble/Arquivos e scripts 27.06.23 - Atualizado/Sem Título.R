n %>% length

n%>% table

titanic %>% head


x %>% hist()


preds <- runif(100)
actual <- preds + rnorm(100)
rss <- sum((preds - actual) ^ 2)  ## residual sum of squares
tss <- sum((actual - mean(actual)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq

plot(preds, actual)
