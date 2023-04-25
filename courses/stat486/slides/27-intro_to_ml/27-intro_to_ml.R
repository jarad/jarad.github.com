## ----packages-------------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("Sleuth3")
library("knitr")
library("kableExtra")


## ---- echo=FALSE----------------------------------------------------------------------------------------------
synonyms <- tribble(
  ~statistics, ~`machine learning`,
  "explanatory/independent variable","feature",
  "response/dependent variable", "target/label",
  "clustering","unsupervised learning",
  "classification","supervised learning",
  "dummy variables","one-hot encoding",
  "estimation","learning/training",
  "transformation","feature creation"
) %>%
  DT::datatable()


## -------------------------------------------------------------------------------------------------------------
set.seed(20230424)

n <- 1000
x <- rnorm(n)
y <- rnorm(n, x)
d <- data.frame(y = y, x = x)

# Split data
p <- 0.5 # split 50/50 (on average)
b <- sample(c(FALSE,TRUE), size = n*p, replace = TRUE)

train <- d[ b,]
test  <- d[!b,]

# Estimate
m <- lm(y~x, data = train)
mean(residuals(m)^2) # in-sample error

# Predict
p <- test %>% mutate(yhat = predict(m, newdata = test))

# Evaluate
mean((p$y - p$yhat)^2) # out-of-sample error


## -------------------------------------------------------------------------------------------------------------
# k folds
k <- 10
fold  <- sample(k, size = n, replace = TRUE)
error <- data.frame(
  in_sample     = numeric(k),
  out_of_sample = numeric(k)
)

# iterate over the folds
for (i in 1:k) {
  train <- d[fold != i,]
  test  <- d[fold == i,]
  
  m <- lm(y ~ x, data = train)
  error$in_sample[i] <- mean(residuals(m)^2)
  
  p <- test %>% mutate(yhat = predict(m, newdata = test))
  error$out_of_sample[i] <- mean((p$y - p$yhat)^2) 
}

error
mean(error$out_of_sample)
sd(  error$out_of_sample) 


## -------------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::ex0722, aes(Height, Force, color = Species)) + 
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE)


## -------------------------------------------------------------------------------------------------------------
m <- lm(Force ~ Height*Species, data = Sleuth3::ex0722)
summary(m)


## -------------------------------------------------------------------------------------------------------------
y    <- runif(n)
yhat <- y*10 + rnorm(n)
cor(y,yhat)^2

plot(yhat, y, ylim = c(0,10), xlim = c(0,10))
abline(0, 1, col = "red")


## -------------------------------------------------------------------------------------------------------------
n <- 100
p <- 50 

train <- matrix(rnorm(n*p), nrow = n, ncol = p) %>%
  as.data.frame() %>%
  mutate(y = V1 + V2 + V3 + V4 + V5 + rnorm(n)) %>%
  select(y, everything())

test <- matrix(rnorm(n*p), nrow = n, ncol = p) %>%
  as.data.frame() %>%
  mutate(y = V1 + V2 + V3 + V4 + V5 + rnorm(n))  %>%
  select(y, everything())

mse <- numeric(p)
for (i in 1:p) {
  m <- lm(y ~ ., data = train[,1:(i+1)])
  yhat <- predict(m, newdata = test)
  mse[i] <- sqrt(mean(test$y - yhat)^2)
}

plot(mse)


## -------------------------------------------------------------------------------------------------------------
d <- data.frame(
  observed = c(0,1),
  predicted = c(0,1,1,0),
  number = c(84, 97, 17, 23)
) 

d %>% 
  pivot_wider(names_from = predicted, values_from = number) %>%
  knitr::kable(caption = "Confusion matrix") %>%
  add_header_above(c(" " = 1, "predicted" = 2))


## -------------------------------------------------------------------------------------------------------------
TP <- d %>% filter(observed == 1, predicted == 1) %>% pull(number) # True positives
TN <- d %>% filter(observed == 0, predicted == 0) %>% pull(number) # True negatives
FP <- d %>% filter(observed == 0, predicted == 1) %>% pull(number) # False positives
FN <- d %>% filter(observed == 1, predicted == 0) %>% pull(number) # False negatives

allP <- TP + FN
allN <- TN + FP


## -------------------------------------------------------------------------------------------------------------
(TP + TN) / (allP + allN) # Classification accuracy

TP / allP # Sensitivity (true positive rate)
TN / allN # Specificity (true negative rate)

