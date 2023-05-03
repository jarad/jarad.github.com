## ----packages, message=FALSE, warning=FALSE---------------------------------------
library("tidyverse")
theme_set(theme_bw())
library("randomForest")
library("nnet")
library("xgboost")
library("DT")


## ----data, cache=TRUE, cache.extra=tools::md5sum("data/train.csv")----------------
d <- read_csv("data/train.csv",

  # Good practice to formally define variable types.
  col_types = c(
    id          = col_character(),
    RainingDays = col_integer(),
    clonesize   = col_integer(),
    .default    = col_double()
  )
)


## ---------------------------------------------------------------------------------
anyNA(d)


## ----variables--------------------------------------------------------------------
names(d)


## ---------------------------------------------------------------------------------
all(diff(d$id) == 1)


## ---------------------------------------------------------------------------------
ggplot(d, aes(x = yield)) +
  geom_histogram(aes(y = after_stat(density)),
    fill = "gray"
  ) +
  stat_function(
    fun = dnorm,
    args = list(
      mean = mean(d$yield),
      sd   = sd(d$yield)
    ),
    color = "blue",
    linewidth = 2
  )


## ---------------------------------------------------------------------------------
d %>% filter(yield == min(yield))
d %>% filter(yield == max(yield))


## ----clonesize--------------------------------------------------------------------
ggplot(d, aes(x = clonesize, y = yield)) +
  geom_point(position = position_jitter(width = 0.5))


## ---------------------------------------------------------------------------------
d %>%
  group_by(clonesize) %>%
  summarize(
    n = n(),
    mean = mean(yield),
    sd = sd(yield),
    max = max(yield),
    min = min(yield)
  )


## ----bee, cache=TRUE, dependson="data"--------------------------------------------
bee <- d %>% select(honeybee:osmia, yield)


## ---------------------------------------------------------------------------------
summary(bee)


## ---------------------------------------------------------------------------------
bee_long <- bee %>%
  pivot_longer(honeybee:osmia)

ggplot(bee_long, aes(x = value)) +
  geom_histogram() +
  facet_wrap(~name, scales = "free")


## ---------------------------------------------------------------------------------
sort(unique(bee_long$value)) * 50


## ---------------------------------------------------------------------------------
bee %>% filter(honeybee > 15)


## ---- cache=TRUE, dependson="bee"-------------------------------------------------
pairs(bee)


## ---------------------------------------------------------------------------------
cor(bee) %>% round(3)


## ----temp, dependson="data"-------------------------------------------------------
temp <- d %>% select(MaxOfUpperTRange:AverageOfLowerTRange, yield)


## ---------------------------------------------------------------------------------
temp_long <- temp %>%
  select(-yield) %>%
  pivot_longer(everything())

ggplot(temp_long, aes(x = value)) +
  geom_histogram() +
  facet_wrap(~name)


## ---------------------------------------------------------------------------------
with(d, table(MaxOfUpperTRange, MinOfUpperTRange))


## ---------------------------------------------------------------------------------
temp %>%
  # select(MaxOfUpperTRange:AverageOfLowerTRange) %>%
  cor() %>%
  round(3)


## ----fruit, cache=TRUE, dependson="data"------------------------------------------
fruit <- d %>% select(fruitset:yield)


## ---------------------------------------------------------------------------------
fruit_long <- fruit %>%
  pivot_longer(-yield)

ggplot(fruit_long, aes(x = value)) +
  geom_histogram() +
  facet_wrap(~name, scales = "free")


## ---------------------------------------------------------------------------------
fruit %>%
  cor() %>%
  round(3)


## ---- cache=TRUE, dependson="fruit"-----------------------------------------------
pairs(fruit)


## ----train, cache=TRUE, dependson="data"------------------------------------------
set.seed(20230503)

# Construct our own train and test
u <- sample(c(TRUE, FALSE),
  size = nrow(d),
  prob = c(.8, .2), # 80% for training, 20% for testing
  replace = TRUE
)

train <- d[u, ] %>% select(-id) # remove id to exclude it as an explanatory variable
test <- d[!u, ] %>% select(-id)


## ---------------------------------------------------------------------------------
mad <- function(p) {
  mean(abs(p - test$yield))
}


## ----lasso-train, cache=TRUE, dependson="train"-----------------------------------
m_lasso <- caret::train(yield ~ ., data = train, method = "lasso")


## ----lasso-predict, cache=TRUE, dependson="lasso-train"---------------------------
p_lasso <- predict(m_lasso, newdata = test)


## ----rf-train, cache=TRUE, dependson="train"--------------------------------------
m_rf <- randomForest(yield ~ ., data = train)


## ----rf-predict, cache=TRUE, dependson="rf-train"---------------------------------
p_rf <- predict(m_rf, newdata = test)


## ----nn-train, cache=TRUE, dependson="train"--------------------------------------
m_nnet <- nnet(yield ~ .,
  data = train,
  size = 5,
  decay = 5e-4,
  rang = .01
) # rang*max(abs(x)) ~= 1

# Code modified from
# https://stats.stackexchange.com/questions/209678/nnet-package-is-it-neccessary-to-scale-data
# m_nnet <- caret::train(yield ~ ., data = train, method = "nnet",
#                        preProcess = c("center","scale"),
#                          trace = FALSE,
#                         tuneGrid = expand.grid(size=1:8, decay=3**(-6:1)),
#                         trControl = trainControl(method = 'repeatedcv',
#                                                 number = 10,
#                                                 repeats = 10,
#                                                 returnResamp = 'final'))


## ----nn-predict, cache=TRUE, dependson=c("nn-train","test_normalized")------------
# Need to unscale predictions
p_nnet <- predict(m_nnet, newdata = test)
unique(p_nnet)


## ----xgbtree-train, cache=TRUE, dependson="train", message=FALSE------------------
m_xgbtree <- xgboost(
  data = train %>% select(-yield) %>% as.matrix(),
  label = train$yield,
  params = list(booster = "gbtree"),
  nrounds = 20, # Increasing this reduces train RMSE
  verbose = 0
)

# This code only increased MAD by 1
# m_xgbtree <- caret::train(yield ~ ., data = train, method = "xgbTree",
#                        verbose = 0)


## ----xgbtree-predict, cache=TRUE, dependson="xgbtree-train"-----------------------
p_xgbtree <- predict(m_xgbtree, newdata = as.matrix(test %>% select(-yield)))


## ----xgblinear-train, cache=TRUE, cache=TRUE, dependson="train", message=FALSE----
# m_xgblinear <- xgboost(data = train %>% select(-yield) %>% as.matrix,
#                      label = train$yield,
#                      params = list(booster = "gblinear"),
#                      nrounds = 10, # Increasing this reduces train RMSE
#                      verbose = 0)

m_xgblinear <- caret::train(yield ~ .,
  data = train, method = "xgbLinear",
  verbose = 0
)

## ----xgblinear-predict, cache=TRUE, dependson="xgblinear-train"-------------------
p_xgblinear <- predict(m_xgblinear, newdata = as.matrix(test %>% select(-yield)))


## ----mae, cache=TRUE, dependson=paste0(c("lasso","rf","nnet","xgbtree","xgblinear"),"-predict")----
error <- tribble(
  ~method, ~`test-mad`,
  "lasso", mad(p_lasso),
  "rf", mad(p_rf),
  "nnet", mad(p_nnet),
  "xgbtree", mad(p_xgbtree),
  "xgblinear", mad(p_xgblinear)
)


## ----comparison, dependson="mae"--------------------------------------------------
error |>
  datatable(
    rownames = FALSE,
    caption = "Test Mean Absolute Deviation (MAD)"
  ) |>
  formatRound(columns = c("test-mad"), digits = 0)


## ----kaggle-train, cache=TRUE, cache.extra=tools::md5sum("data/train.csv")--------
train <- read_csv("data/train.csv") %>% select(-id)

m <- xgboost(
  data = train %>% select(-yield) %>% as.matrix(),
  label = train$yield,
  params = list(booster = "gbtree"),
  nrounds = 20, # Increasing this reduces train RMSE
  verbose = 0
)


## ---- kaggle-test, cache=TRUE, dependson="kaggle-train", cache.extra=tools::md5sum("data/test.csv")----
test <- read_csv("data/test.csv")

prediction <- test %>%
  mutate(
    yield = predict(m, newdata = as.matrix(test %>% select(-id))),

    # Since the training yield data seem to have a fixed min/max
    # truncate data to that range
    yield = ifelse(yield > max(train$yield), max(train$yield), yield),
    yield = ifelse(yield < min(train$yield), min(train$yield), yield)
  )

write_csv(prediction %>% select(id, yield),
  file = "submission.csv"
)

