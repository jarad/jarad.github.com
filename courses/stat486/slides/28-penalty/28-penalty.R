## ----packages------------------------------------------------------------------------------
library("tidyverse")
theme_set(theme_bw())
library("MASS")
library("MuMIn")
library("glmnet")
library("knitr")
library("kableExtra")


## ------------------------------------------------------------------------------------------
set.seed(20230425)
n <- 100
d <- diamonds %>%
  dplyr::select(-cut, -color, -clarity) %>%
  rename(lprice = price) %>%
  mutate(lprice = log(lprice))

train <- d %>% sample_n(n)
test <- d %>% sample_n(n)


## ------------------------------------------------------------------------------------------
m <- lm(lprice ~ 1, data = train)
p <- predict(m, newdata = test)

error <- data.frame(
  group = "Regression",
  method = "Intercept-only",
  in_sample = mean(m$residuals^2),
  out_of_sample = mean((p - test$lprice)^2)
)


## ------------------------------------------------------------------------------------------
m <- lm(lprice ~ ., data = train)
p <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Regression",
    method = "Main effects",
    in_sample = mean(m$residuals^2),
    out_of_sample = mean((p - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m <- lm(lprice ~ .^2, data = train)
p <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Regression",
    method = "Interactions",
    in_sample = mean(m$residuals^2),
    out_of_sample = mean((p - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m1 <- lm(lprice ~ ., data = train)
m2 <- lm(lprice ~ .^2, data = train)
anova(m1, m2)


## ------------------------------------------------------------------------------------------
extractAIC(m1)
extractAIC(m2)


## ------------------------------------------------------------------------------------------
extractAIC(m1, k = log(n))
extractAIC(m2, k = log(n))


## ------------------------------------------------------------------------------------------
m_forward <- step(lm(lprice ~ 1, data = train),
  scope = formula(lm(lprice ~ .^2, data = train)),
  direction = "forward"
)


## ------------------------------------------------------------------------------------------
summary(m_forward)$coef


## ------------------------------------------------------------------------------------------
p <- predict(m_forward, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Selection",
    method = "Forward",
    in_sample = mean(m_forward$residuals^2),
    out_of_sample = mean((p - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m_backward <- step(lm(lprice ~ .^2, data = train),
  direction = "backward"
)


## ------------------------------------------------------------------------------------------
summary(m_backward)$coef


## ------------------------------------------------------------------------------------------
p <- predict(m_backward, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Selection",
    method = "Backward",
    in_sample = mean(m_backward$residuals^2),
    out_of_sample = mean((p - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m_both <- step(lm(lprice ~ ., data = train),
  scope = formula(lm(lprice ~ .^2, data = train)),
  direction = "both"
)


## ------------------------------------------------------------------------------------------
summary(m_both)$coef


## ------------------------------------------------------------------------------------------
p <- predict(m_both, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Selection",
    method = "Forward and backward",
    in_sample = mean(m_both$residuals^2),
    out_of_sample = mean((p - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m_avg <- lm(lprice ~ ., data = train, na.action = na.fail) %>%
  MuMIn::dredge()


## ------------------------------------------------------------------------------------------
mp <- m_avg %>%
  get.models(subset = cumsum(weight) <= .99) %>%
  model.avg()

p_train <- predict(mp, newdata = train)
p_test <- predict(mp, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group = "Model averaging",
    method = "AIC",
    in_sample = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test - test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
train <- list(
  y = train$lprice,
  x = subset(train, select = -c(lprice)) %>% as.matrix()
)

test <- list(
  y = test$lprice,
  x = subset(test, select = -c(lprice)) %>% as.matrix()
)


## ------------------------------------------------------------------------------------------
m <- glmnet(
  x = train$x,
  y = train$y,
  alpha = 0 # ridge regression
)


## ------------------------------------------------------------------------------------------
plot(m, xvar = "lambda", label = TRUE)


## ------------------------------------------------------------------------------------------
cv_m <- cv.glmnet(
  x = train$x,
  y = train$y,
  alpha = 0, # ridge regression

  # default sequence used values of lambda that are too big
  lambda = seq(0, 0.01, length = 100)
)


## ------------------------------------------------------------------------------------------
plot(cv_m)


## ------------------------------------------------------------------------------------------
best_lambda <- cv_m$lambda.min
m <- glmnet(
  x = train$x,
  y = train$y,
  alpha = 0, # ridge regression
  lambda = best_lambda
)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newx = train$x)
p_test <- predict(m, newx = test$x)

error <- bind_rows(
  error,
  data.frame(
    group         = "Regularization",
    method        = "Ridge",
    in_sample     = mean((p_train - train$y)^2),
    out_of_sample = mean((p_test - test$y)^2)
  )
)


## ------------------------------------------------------------------------------------------
m <- glmnet(
  x = train$x,
  y = train$y,
  alpha = 1 # LASSO
)


## ------------------------------------------------------------------------------------------
plot(m, xvar = "lambda", label = TRUE)


## ------------------------------------------------------------------------------------------
cv_m <- cv.glmnet(
  x = train$x,
  y = train$y,
  alpha = 1 # LASSO
)


## ------------------------------------------------------------------------------------------
plot(cv_m)


## ------------------------------------------------------------------------------------------
best_lambda <- cv_m$lambda.min
m <- glmnet(
  x = train$x,
  y = train$y,
  alpha = 1, # LASSO
  lambda = best_lambda
)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newx = train$x)
p_test <- predict(m, newx = test$x)

error <- bind_rows(
  error,
  data.frame(
    group         = "Regularization",
    method        = "LASSO",
    in_sample     = mean((p_train - train$y)^2),
    out_of_sample = mean((p_test - test$y)^2)
  )
)


## ------------------------------------------------------------------------------------------
cv_m <- cv.glmnet(
  x = train$x,
  y = train$y,
  alpha = 0.5 # LASSO
)


## ------------------------------------------------------------------------------------------
best_lambda <- cv_m$lambda.min
m <- glmnet(
  x = train$x,
  y = train$y,
  alpha = 0.5, # LASSO
  lambda = best_lambda
)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newx = train$x)
p_test <- predict(m, newx = test$x)

error <- bind_rows(
  error,
  data.frame(
    group         = "Regularization",
    method        = "Elastic net (alpha=0.5)",
    in_sample     = mean((p_train - train$y)^2),
    out_of_sample = mean((p_test - test$y)^2)
  )
)


## ------------------------------------------------------------------------------------------
error %>%
  dplyr::select(-group) %>%
  kable(digits = 3) %>%
  pack_rows(index = table(fct_inorder(error$group))) %>%
  kable_styling()

