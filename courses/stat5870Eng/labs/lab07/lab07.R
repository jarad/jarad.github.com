# Author: Jarad Niemi
# Date:   2024-10-17
# Purpose: Introduce RMarkdown file format using Module 2 content
#-------------------------------------------------------------------------------


library("tidyverse")
library("Sleuth3")   # data
library("rmarkdown") # compiling RMarkdown files

case0401

n <- sum(case0401$Launch == "Warm")
y <- sum(case0401$Incidents[case0401$Launch == "Warm"] == 0)

## Frequentist analysis
binom.test(y, n)
prop.test( y, n) # based on CLT (not reasonable here)

binom.test(y, n)$conf.int # Q1.5

# Bayesian analysis
(1 + y) / (2 + n)
qbeta(c(.025, .975), 1 + y, 1 + n - y) # Credible interval
1 - pbeta(0.9, 1 + y, 1 + n - y)       # P(theta > 0.9 | y)

extrinsic <- case0101 |> 
  filter(Treatment == "Extrinsic") 

summary(extrinsic)

t.test(extrinsic$Score)

# Compute summary statistics from data
d <- case0401 |>
  group_by(Launch) |>
  summarize(
    n = n(),
    y = sum(Incidents == 0),
    p = y/n
  )

d

prop.test(d$y, d$n)

# Simulate from the posterior for each probability of success
nreps      <- 1e5                                           # make this large
prob_cool <- rbeta(nreps, 1 + d$y[1], 1 + d$n[1] - d$y[1]) 
prob_warm <- rbeta(nreps, 1 + d$y[2], 1 + d$n[2] - d$y[2])
diff       <- prob_cool - prob_warm

# Calculate quantities of interest
mean(diff < 0)                          # P(prob_warm > prob_cool | y)
quantile(-diff, probs = c(.025, 0.975)) # 95% credible interval for prob_warm - prob_cool

# Summary statistics
case0101 |>
  group_by(Treatment) |>
  summarize(
    n    = n(),
    mean = mean(Score),
    sd   = sd(Score)
  )

ggplot(case0101,
       aes(x = Treatment, 
           y = Score,
           color = Treatment,
           shape = Treatment)) +
  geom_jitter(width = 0.1)       # jitter the points makes sure points don't overlap

(tt <- t.test(Score ~ Treatment, data = case0101, var.equal = TRUE))

my_round <- function(x, nd = 2) {
  format(round(x, nd), nsmall = nd)
}
