## ----libraries, message=FALSE, warning=FALSE, cache=FALSE----------------
# library("reshape2")
library("dplyr")
library("xtable")

library("ggplot2")
library("GGally")
library("RColorBrewer")

library("rstan")
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## ----set_seed------------------------------------------------------------
set.seed(1)

## ----dawkins_data, results='hide'----------------------------------------
d = structure(list(date = structure(c(16L, 9L, 10L, 11L, 12L, 13L, 
14L, 15L, 20L, 17L, 18L, 19L, 21L, 7L, 8L, 1L, 2L, 3L, 4L, 5L, 
6L, 22L, 23L, 24L), .Label = c("1/11/14", "1/13/14", "1/18/14", 
"1/22/14", "1/25/14", "1/27/14", "1/4/14", "1/7/14", "11/12/13", 
"11/15/13", "11/18/13", "11/19/13", "11/24/13", "11/27/13", "11/29/13", 
"11/8/13", "12/16/13", "12/19/13", "12/28/13", "12/3/13", "12/31/13", 
"2/1/14", "2/4/14", "2/8/14"), class = "factor"), opponent = structure(c(5L, 
13L, 9L, 21L, 6L, 22L, 1L, 2L, 15L, 11L, 20L, 7L, 8L, 17L, 12L, 
4L, 23L, 16L, 14L, 10L, 18L, 19L, 24L, 3L), .Label = c("alabama", 
"arizona", "boston college", "clemson", "davidson", "east carolina", 
"eastern michigan", "elon", "florida atlantic", "florida state", 
"gardner-webb", "georgia tech", "kansas", "miami", "michigan", 
"nc state", "notre dame", "pitt", "syracuse", "ucla", "unc asheville", 
"vermont", "virginia", "wake forest"), class = "factor"), made = c(0L, 
0L, 5L, 3L, 0L, 3L, 0L, 1L, 2L, 4L, 1L, 6L, 5L, 1L, 1L, 0L, 1L, 
3L, 2L, 3L, 6L, 4L, 4L, 0L), attempts = c(0L, 0L, 8L, 6L, 1L, 
9L, 2L, 1L, 2L, 8L, 5L, 10L, 7L, 4L, 5L, 4L, 1L, 7L, 6L, 6L, 
7L, 9L, 7L, 1L)), .Names = c("date", "opponent", "made", "attempts"
), class = "data.frame", row.names = c(NA, -24L)) 

d = rbind(d, 
          
          # Add a total row
          data.frame(date     = NA, 
                     opponent = 'Total', 
                     made     = sum(d$made), 
                     attempts = sum(d$attempts))) %>%
  
  # Add posterior parameters
  mutate(a        = 0.5 + made,
         b        = 0.5 + attempts-made,
         lcl      = qbeta(0.025,a,b),
         ucl      = qbeta(0.975,a,b),
         Estimate = ifelse(opponent=="Total", "Combined", "Individual"),
         game     = 1:n())

## ----dawkins_plot, out.width='0.7\\textwidth', dependson="dawkins_data"----
ggplot(d, 
       aes(x     = lcl, 
           xend  = ucl, 
           y     = game, 
           yend  = game, 
           color = Estimate))+
  geom_segment(lwd=1) +
  scale_color_brewer(palette='Set1') + 
  labs(x=expression(theta), title='95% Credible Intervals') + 
  scale_y_reverse() +
  theme_bw()

## ----results='asis'------------------------------------------------------
xtable(d)
d = d %>% filter(opponent != "Total")

## ----informative_prior, echo=TRUE----------------------------------------
a = 20
b = 30
m = 0
C = 3

## ----informative_prior_plot, dependson='informative_prior', echo=TRUE----
n = 1e4

prior_draws = data.frame(mu  = rbeta(n, a, b), 
                         eta = rlnorm(n, m, C)) %>%
  mutate(alpha = eta*   mu,
         beta  = eta*(1-mu))

prior_draws %>%
  tidyr::gather(parameter, value) %>%
  group_by(parameter) %>%
  summarize(lower95 = quantile(value, prob = 0.025),
            median  = quantile(value, prob = 0.5),
            upper95 = quantile(value, prob = 0.975))

cor(prior_draws$alpha, prior_draws$beta)

## ----stan, echo=TRUE-----------------------------------------------------
model_informative_prior = "
data {
  int<lower=0> N;    // data
  int<lower=0> n[N];
  int<lower=0> y[N]; 
  real<lower=0> a;   // prior
  real<lower=0> b;
  real<lower=0> C;
  real m;
}
parameters {
  real<lower=0,upper=1> mu;
  real<lower=0> eta;
  real<lower=0,upper=1> theta[N];
}
transformed parameters {
  real<lower=0> alpha;
  real<lower=0> beta;

  alpha = eta*   mu ;
  beta  = eta*(1-mu);
}
model {
  mu    ~ beta(a,b);
  eta   ~ lognormal(m,C);

  // implicit joint distributions
  theta ~ beta(alpha,beta); 
  y     ~ binomial(n,theta);
}
"

## ----stan_run, dependson=c('informative_prior','stan',"dawkins_data"), echo=TRUE, results='hide'----
dat = list(y=d$made, n=d$attempts, N=nrow(d),a=a, b=b, m=m, C=C)
m = stan_model(model_code=model_informative_prior)
r = sampling(m, dat, c("mu","eta","alpha","beta","theta"), 
             iter = 10000,
             control = list(adapt_delta = 0.9))

## ----stan_post, dependson="stan_run", echo=TRUE--------------------------
r

## ----stan_plot, dependson="stan_run", message=TRUE, echo=TRUE, out.width='0.5\\textwidth'----
plot(r, pars=c('eta','alpha','beta'))

## ----stan_plot2, dependson="stan_run", echo=TRUE, out.width='0.7\\textwidth'----
plot(r, pars=c('mu','theta'))

## ----quantiles, dependson="stan_run", out.width='0.7\\textwidth'---------
d$model = "independent"

tmp = data.frame(summary(r)$summary[,c(4,8)])
new_d = mutate(d,
               model = "hierarchical",
               lcl = tmp[5:28,1],
               ucl = tmp[5:28,2])

e = 0.2
ggplot(rbind(d, new_d), aes(x=lcl, 
                     xend=ucl, 
                     y=game+e*(model=="hierarchical"), 
                     yend=game+e*(model=="hierarchical"), 
                     color=model))+
  geom_segment(lwd=1, alpha=0.5) + 
  labs(x=expression(theta), y="game", title='95% Credible Intervals') +
  scale_color_brewer(palette='Set1') + 
  scale_y_reverse() +
  theme_bw()

## ----stan2_run, echo=TRUE, results='hide'--------------------------------
model_default_prior = "
data {
  int<lower=0> N;
  int<lower=0> n[N];
  int<lower=0> y[N];
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
  real<lower=0,upper=1> theta[N];
}

model {
  // default prior
  target += -5*log(alpha+beta)/2;

  // implicit joint distributions
  theta ~ beta(alpha,beta); 
  y     ~ binomial(n,theta);
}
"

m2 = stan_model(model_code=model_default_prior)
r2 = sampling(m2, dat, c("alpha","beta","theta"), iter=10000,
              control = list(adapt_delta = 0.9))

## ----stan_post2, dependson=c("stan2_run","stan_run"), echo=TRUE, out.width='0.7\\textwidth'----
r2

## ----stan2_plot, dependson="stan2_run", echo=TRUE, out.width='0.7\\textwidth'----
plot(r2, pars=c('alpha','beta'))

## ----stan2_plot2, dependson="stan2_run", out.width='0.7\\textwidth'------
plot(r2, pars=c('theta'))

## ----quantiles2, dependson=c("stan_run","stan2_run"), out.width='0.7\\textwidth'----
d$prior     = "independent"
new_d$prior = "informative"

tmp = data.frame(summary(r2)$summary[,c(4,8)])
new_d2 = mutate(new_d,
                prior = "default",
                lcl = tmp[3:26,1],
                ucl = tmp[3:26,2])

bind_d = rbind(d,new_d,new_d2)
bind_d$prior = factor(bind_d$prior, c('informative','default','independent'))

e = 0.2
ggplot(bind_d, 
       aes(x     = lcl, 
           xend  = ucl, 
           y     = game+e*(prior=="independent")-e*(prior=="informative"), 
           yend  = game+e*(prior=="independent")-e*(prior=="informative"), 
           color = prior))+
  geom_segment(lwd=1, alpha=0.5) + 
  labs(x=expression(theta), y="game", title='95% Credible Intervals') + 
  scale_color_brewer(palette='Set1') + 
  scale_y_reverse() +
  theme_bw()

## ----stan3_run, echo=TRUE, results='hide',dependson="stan_run"-----------
# Marginalized (integrated) theta out of the model
model_marginalized = "
data {
  int<lower=0> N;
  int<lower=0> n[N];
  int<lower=0> y[N];
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
}
model {
  target += -5*log(alpha+beta)/2;
  y     ~ beta_binomial(n,alpha,beta);
}
"

m3 = stan_model(model_code=model_marginalized)
r3 = sampling(m3, dat, c("alpha","beta"))

## ----stan3_post, dependson="stan3_run"-----------------------------------
r3

## ----stan3_alpha_beta, dependson="stan3_run", echo=TRUE, out.width='0.7\\textwidth'----
samples = extract(r3, c("alpha","beta"))
ggpairs(data.frame(log_alpha = log(as.numeric(samples$alpha)), log_beta  = log(as.numeric(samples$beta))),
        lower  = list(continuous='density'))

## ----stan3_theta, dependson="stan3_run", fig.width=10, echo=TRUE---------
samples = extract(r3, c("alpha","beta"))
game = 22
theta22 = rbeta(length(samples$alpha), 
              samples$alpha + d$made[game], 
              samples$beta  + d$attempts[game] - d$made[game])
hist(theta22, 100, 
     main=paste("Posterior for game against", d$opponent[game], "on", d$date[game]),
     xlab="3-point probability", 
     ylab="Posterior")

## ----stan3_thetas, dependson='stan3_run'---------------------------------
game = 23
theta23 = rbeta(length(samples$alpha), 
              samples$alpha + d$made[game], 
              samples$beta  + d$attempts[game] - d$made[game])
ggpairs(data.frame(theta22=theta22,theta23=theta23), lower=list(continuous='density'))

## ----season_data, results='asis'-----------------------------------------
d = data.frame(season=1:4, y=c(36,64,67,64), n=c(95,150,171,152))
xtable(d, digits=0)

## ----stan_season, dependson='season_data', echo=TRUE, results='hide'-----
model_seasons = "
data {
  int<lower=0> N; int<lower=0> n[N]; int<lower=0> y[N];
  real<lower=0> a; real<lower=0> b; real<lower=0> C; real m;
}
parameters {
  real<lower=0,upper=1> mu;
  real<lower=0> eta;
}  
transformed parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
  alpha = eta *    mu;
  beta  = eta * (1-mu);
}
model {
  mu  ~ beta(a,b);
  eta ~ lognormal(m,C);
  y   ~ beta_binomial(n,alpha,beta);
}
generated quantities {
  real<lower=0,upper=1> theta[N];
  for (i in 1:N) theta[i] = beta_rng(alpha+y[i], beta+n[i]-y[i]);
}
"

dat  = list(N = nrow(d), y = d$y, n = d$n, a = 20, b = 30, m = 0, C = 2)
m4 = stan_model(model_code = model_seasons)
r_seasons = sampling(m4, dat, c("alpha","beta","mu","eta","theta"))

## ----stan_season_summary, dependson="stan_season"------------------------
r_seasons

## ----stan_season_posteriors, dependson="stan_season"---------------------
posterior = extract(r_seasons, "theta") %>%
  tidyr::gather()

names(posterior)[2] = "season"
posterior$season = factor(posterior$season)
ggplot(posterior, aes(x=value, fill=season)) + geom_density(alpha=0.5) +
  theme_bw()

## ----stan_season_comparison, echo=TRUE, dependson="stan_season"----------
theta = extract(r_seasons, "theta")[[1]] 
mean(theta[,4] > theta[,1])
mean(theta[,4] > theta[,2])
mean(theta[,4] > theta[,3])

