## ----packages------------------------------------------------------------------------------
library("tidyverse")
theme_set(theme_bw())
library("rpart")
library("rpart.plot")
library("randomForest")
library("DT")


## ------------------------------------------------------------------------------------------
set.seed(20230425) # This matches what was used in a previous set of slides
n <- 100
d <- diamonds %>%
  dplyr::select(-cut, -color, -clarity) %>%
  rename(lprice = price) %>%
  mutate(lprice = log(lprice))

train <- d %>% sample_n(n)
test <- d %>% sample_n(n)


## ------------------------------------------------------------------------------------------
error <- read_csv("../28-penalty/error.csv")


## ------------------------------------------------------------------------------------------
m <- rpart(lprice ~ ., data = train)


## ------------------------------------------------------------------------------------------
rpart.plot(m, uniform = TRUE)


## ------------------------------------------------------------------------------------------
m


## ------------------------------------------------------------------------------------------
train %>%
  mutate(
    X1 = (x < 5.705)*(z < 3.07)*(x < 4.37),
    X2 = (x < 5.705)*(z < 3.07)*(x >= 4.37),
    X3 = (x < 5.705)*(z >= 3.07),
    X4 = (x >= 5.705)*(carat < 1.18)*(x < 6.105),
    X5 = (x >= 5.705)*(carat < 1.18)*(x >= 6.105),
    X6 = (x >= 5.705)*(carat >= 1.18)*(x < 7.345),
    X7 = (x >= 5.705)*(carat >= 1.18)*(x >= 7.345)
  ) %>%
  summarize(
    mean1 = sum(lprice*X1)/sum(X1),
    mean2 = sum(lprice*X2)/sum(X2),
    mean3 = sum(lprice*X3)/sum(X3),
    mean4 = sum(lprice*X4)/sum(X4),
    mean5 = sum(lprice*X5)/sum(X5),
    mean6 = sum(lprice*X6)/sum(X6),
    mean7 = sum(lprice*X7)/sum(X7)
  ) %>%
  round(1) %>%
  pivot_longer(everything())


## ---- include=FALSE------------------------------------------------------------------------
summary(m)


## ------------------------------------------------------------------------------------------
p <- bind_rows(
  test  %>% mutate(p = predict(m, newdata = test),  type = "test"),
  train %>% mutate(p = predict(m, newdata = train), type = "train")
)

ggplot(p, aes(x = p, y = lprice, shape = type, color = type)) + 
  geom_abline(intercept = 0, slope = 1, color = "gray") + 
  geom_point(position = position_dodge(width = 0.1)) 


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Tree",
    method        = "default",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
args(rpart.control)


## ------------------------------------------------------------------------------------------
m <- rpart(lprice ~ ., data = train,
           control = rpart.control(
             minsplit = 40,
             minbucket = 20,
             cp = 0.1
           ))


## ------------------------------------------------------------------------------------------
rpart.plot(m)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Tree",
    method        = "underfit",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m <- rpart(lprice ~ ., data = train,
           control = rpart.control(
             minsplit = 10,
             minbucket = 5,
             cp = 0.001
           ))


## ------------------------------------------------------------------------------------------
rpart.plot(m)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Tree",
    method        = "overfit",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m <- randomForest(lprice ~ ., data = train)
m


## ------------------------------------------------------------------------------------------
plot(m)


## ------------------------------------------------------------------------------------------
p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Random forest",
    method        = "default",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ---- eval=FALSE---------------------------------------------------------------------------
## ?randomForest


## ------------------------------------------------------------------------------------------
m <- randomForest(lprice ~ ., data = train,
                  sampsize = nrow(train), 
                  mtry = 6,
                  nodesize = 2 
                  )
m

p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Random forest",
    method        = "overfit?",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
m <- randomForest(lprice ~ ., data = train,
                  sampsize = 0.5*nrow(train), # training set is same size as data
                  mtry = 2, # number of variables to try at eac hsplit
                  nodesize = 10, # number of observations in each leaf
                  ntree = 50
                  )
m

p_train <- predict(m, newdata = train)
p_test  <- predict(m, newdata = test)

error <- bind_rows(
  error,
  data.frame(
    group         = "Random forest",
    method        = "underfit?",
    in_sample     = mean((p_train - train$lprice)^2),
    out_of_sample = mean((p_test  -  test$lprice)^2)
  )
)


## ------------------------------------------------------------------------------------------
error %>%
  datatable(
    rownames = FALSE,
    caption = "In and out-of-sample error for various prediction methods",
    filter = "top"
  ) %>%
  formatRound(columns = c("in_sample","out_of_sample"), digits = 3)

