## ----libraries, message=FALSE, warning=FALSE, cache=FALSE-------------------------------------------------------------
library("dplyr")
library("ggplot2")


## ----set_seed---------------------------------------------------------------------------------------------------------
set.seed(2)


## ----center_of_mass, fig.height=2.9, out.width = "\\textwidth"--------------------------------------------------------
d <- data.frame(x = seq(0,1,by=0.05)) %>%
  mutate(y = 3*x^2)


ggplot(d, aes(x, ymin = 0, ymax = y)) + 
  geom_ribbon() +
  geom_point(data = data.frame(x = .75, y = -0.1), aes(x,y), 
             shape = 24, color = 'red', fill = 'red') + 
  labs(y = "probability density function") +
  theme_bw()


## ----fig.height=2-----------------------------------------------------------------------------------------------------
d = data.frame(x = seq(-0.5, 1.5, by=0.01)) %>%
  dplyr::mutate(pdf = 1 * (x>0) * (x < 1),
                cdf = x,
                cdf = ifelse(x<0, 0, x),
                cdf = ifelse(x>1, 1, x))

ggplot(d, aes(x, pdf)) +
  geom_line() +
  labs(title ="Standard uniform pdf", x = "x", y = "Probability density function") + 
  theme_bw()


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
inverse_cdf = function(u) u^(1/3)
x = inverse_cdf(runif(1e6))
mean(x)
var(x)


## ----fig.height = 3.3, out.width="\\textwidth"------------------------------------------------------------------------
hist(x, 100, prob = TRUE)
curve(3*x^2, col='red', add = TRUE, lwd=2)


## ----out.width="\\textwidth"------------------------------------------------------------------------------------------
d = data.frame(mu = c(0,0,1,1), sigma = c(1,2,1,2))
d$legend_name = paste("mu=", d$mu, ", sigma=", d$sigma)
plot(0,0, type = "n", xlim = c(-4,4), ylim = c(0,0.5), xlab = "x", 
     ylab = "Probability density function")
for (i in 1:nrow(d)) {
	mu = d$mu[i]; sigma = d$sigma[i]
	curve(dnorm(x, mu, sigma), add = TRUE, lty = mu+1, col = sigma)
}
legend("topleft", legend = d$legend_name,
			 lty = d$mu+1, col = d$sigma)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
pnorm(1.5) # default is mean=0, sd=1


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
1-pnorm((18-15)/2)         # by standardizing
1-pnorm(18, mean = 15, sd = 2) # using the mean and sd arguments


## ----echo = TRUE------------------------------------------------------------------------------------------------------
mu = 5.3
sigma = 0.1

1-diff(pnorm(c(5,6), mean = mu, sd = sigma))

