# Author:  Jarad Niemi
# Date:    2024-02-08
# Execute: execute script from its directory
# Purpose: Code to generate movies 
#-------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("stringr")

# 4k video settings
width  <- 3840
height <- 2160


#-------------------------------------------------------------------------------
# Binomial model
# Convergence of conjugate prior to normal distribution
#-------------------------------------------------------------------------------

dir.create("binomial", showWarnings = FALSE)

theta0 <- 0.3
sample_size <- 1000
z <- rbinom(sample_size, size = 1, prob = theta0)

# Prior 
a <- b <- 1

for (n in 10:sample_size) {
  y <- sum(z[1:n])
  
   
  yp <- a + y - 1
  np <- a + b + n - 2
  theta_hat <- yp / np # mode of beta
  
  d <- data.frame(x = seq(0, 1, length = 1001)) |>
    mutate(
      beta = dbeta(x, 
                   a + y, 
                   b + n - y),
      normal = dnorm(x, 
                     theta_hat, 
                     sqrt(theta_hat*(1-theta_hat)/np))) |>
    pivot_longer(beta:normal, 
                 names_to  = "Distribution",
                 values_to = "density")
        

  
  g <- ggplot(d, 
              aes(x = x, 
                  y = density,
                  color = Distribution,
                  linetype = Distribution
              )) +
    geom_line()
  
  ggsave(
    filename = paste0("binomial/binomial_conjugateprior-",
                      stringr::str_pad(n, 4, pad = "0"),
                              ".jpg"),
    width = width,
    height = height,
    units = "px"
  )
}
