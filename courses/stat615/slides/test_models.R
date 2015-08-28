library(rstan)

model = "
data {
  real y;
}
parameters {
  real mu;
}
model {
  y ~ normal(mu,1);
  mu ~ double_exponential(0,1);
}"

mod = stan_model(model_code = model)

samps = sampling(mod, list(y=1), iter=100000)
