## ---------------------------------------------------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
set.seed(20230307)


## ---------------------------------------------------------------------------------------------------------------------------------------
r <- 3 # rate

ggplot(data.frame(x = 0:(4/r))) + 
  stat_function(fun = dexp, args = list(rate = r)) 


## ---------------------------------------------------------------------------------------------------------------------------------------
ggplot(data.frame(x = 0:(4/r))) + 
  stat_function(fun = pexp, args = list(rate = r)) 


## ----conditional_exponential------------------------------------------------------------------------------------------------------------
c <- 1

# Check probability 
1-pexp(c, rate = r) # if this probability is too small, the simulation will take a while

# Simulate exponential random variables that are greater than c
x <- rexp(1e4, rate = r)
for (i in seq_along(x)) {
  while (x[i] < c)
    x[i] <- rexp(1, rate = r)
}


## ---- dependson="conditional_exponential"-----------------------------------------------------------------------------------------------
ggplot(
  data.frame(x=x), 
  aes(x-c)         # performs the shift
) +
  stat_ecdf() +
  stat_function(fun = pexp, args = list(rate = r), color = "red") 


## ---------------------------------------------------------------------------------------------------------------------------------------
set.seed(20230309)
n <- 30

d <- data.frame(
  x = runif(n),
  y = runif(n),
  species = sample(c("E","S","ES","P"), size = n, replace = TRUE, 
                   prob = c(0.2,0.6,0.1,0.1)),
  speed = runif(n,0.05, 0.1),
  direction = runif(n, max = 2*pi)
) %>%
  mutate(
    xend = x + speed*cos(direction),
    yend = y + speed*sin(direction),
    species = factor(species, levels = c("E","S","ES","P"))
  )



ggplot(d, aes(x = x, y = y, xend = xend, yend=yend,
              color = species, shape = species)) +
  geom_point(size = 5) +
  geom_segment(arrow = arrow(length = unit(0.2, "cm")), color = "black") +
  scale_color_manual(
    values = c(
      "E" = "red",
      "S" = "blue",
      "ES" = "purple",
      "P" = "green"
    )
  ) +
  scale_shape_manual(
    values = c(
      "E" = 4,
      "S" = 0,
      "ES" = 7,
      "P" = 19
    )
  )


## ----PrePost----------------------------------------------------------------------------------------------------------------------------
Pre <- rbind(
#   E  S ES  P
  c(1, 1, 0, 0),
  c(0, 0, 1, 0),
  c(0, 0, 1, 0)
)

rownames(Pre) <- c("I","II","III")
colnames(Pre) <- c("E","S","ES","P")
Pre

Post <- rbind(
#   E  S ES  P
  c(0, 0, 1, 0),
  c(1, 1, 0, 0),
  c(1, 0, 0, 1)
)

rownames(Post) <- c("I","II","III")
colnames(Post) <- c("E","S","ES","P")
Post


## ----stoichiometry, dependson="PrePost"-------------------------------------------------------------------------------------------------
A <- Post - Pre # reaction
S <- t(A)       # stoichiometry

A
S


## ---- dependson="stoichiometry"---------------------------------------------------------------------------------------------------------
x0 <- c(5, 100, 1, 0)
x0 + S[,1]
x0 + S[,2]
x0 + S[,3]


## ----simulate_michaelis_menton_transition-----------------------------------------------------------------------------------------------
michaelis_menton_reaction_matrix <- rbind(
  #  E   S  ES P
  c(-1, -1,  1, 0),
  c( 1,  1, -1, 0),
  c( 1,  0, -1, 1)
)

#' Function to simulate a single Michaelis-Menton transition
#' 
#' This function will simulate a single predator-prety transition based on the 
#' current `state` of the system and the reaction `rates`
simulate_michaelis_menton_transition <- function(state, rate, initial_time) {
  propensity <- c(
    rate[1] * state[1] * state[2],
    rate[2] * state[3] ,
    rate[3] * state[3]
  )
  
  time_increment <- rexp(1, rate = sum(propensity))
  reaction       <- sample(1:3, 1, prob = propensity)
  
  state <- state + michaelis_menton_reaction_matrix[reaction,]
  
  return(
    list(
      time  = initial_time + time_increment,
      state = state
    ))
}


## ----simulate_michaelis_menton_system, dependson="simulate_michaelis_menton_transition"-------------------------------------------------
simulate_michaelis_menton_system <- function(initial_state, rate, max_rxns = 1e3) {
  # Create storage structures for state and time
  n_possible_rxns <- max_rxns + 1
  state <- matrix(initial_state, nrow = 4, ncol = n_possible_rxns)
  n_rxns <- 1
  time   <- rep(0, n_possible_rxns) 
  
  # Simulate outbreak
  while(any(state[2:3,n_rxns] > 0) & n_rxns <= max_rxns) {
    tmp <- simulate_michaelis_menton_transition(state[,n_rxns], rate, time[n_rxns])
    n_rxns         <- n_rxns + 1
    time[n_rxns]   <- tmp$time
    state[,n_rxns] <- tmp$state
  }
  
  d <- data.frame(
    E  = state[1, ],
    S  = state[2, ],
    ES = state[3, ],
    P  = state[4, ],
    time = time
  ) %>%
    pivot_longer(-time, names_to = "state", values_to = "count") %>%
    mutate(
      state = factor(state, levels = c("E","S","ES","P"))
    )
}


## ---- dependson="simulate_michaelis_menton_system"--------------------------------------------------------------------------------------
set.seed(1)
d <- simulate_michaelis_menton_system(c(5, 100, 0, 0), rate = c(1,1,.1), max_rxns = 1e3)

ggplot(d, aes(x = time, y = count, color = state)) + 
  geom_step()


## ----simulate_sir_transition------------------------------------------------------------------------------------------------------------
sir_reaction_matrix <- rbind(
  #  S   I  R
  c(-1,  1, 0),
  c( 0, -1, 1)
)

#' Function to simulate a single SIR transition
#' 
#' This function will simulate a single SIR transition based on the current 
#' `state` of the system and the reaction `rates`
simulate_sir_transition <- function(state, rate, initial_time) {
  propensity <- c(
    rate[1] * state[1] * state[2] / sum(state),
    rate[2] * state[2]
  )
  
  time_increment <- rexp(1, rate = sum(propensity))
  reaction       <- sample(1:2, 1, prob = propensity)
  
  # Update state according to stoichiometry
  state <- state + sir_reaction_matrix[reaction,]
  
  return(
    list(
      time  = initial_time + time_increment,
      state = state
    ))
}


## ----simulate_sir_outbreak, dependson="simulate_sir_transition"-------------------------------------------------------------------------
simulate_outbreak <- function(initial_state, rate, max_rxns = 5000) {
  # Create storage structures for state and time
  n_possible_rxns <- min(2*initial_state[1] + initial_state[2]+1, max_rxns + 1)
  state <- matrix(initial_state, nrow = 3, ncol = n_possible_rxns)
  n_rxns <- 1
  time   <- rep(0, n_possible_rxns) 
  
  # Simulate outbreak
  while(state[2,n_rxns] > 0 & n_rxns <= max_rxns ) {
    tmp <- simulate_sir_transition(state[,n_rxns], rate, time[n_rxns])
    n_rxns         <- n_rxns + 1
    time[n_rxns]   <- tmp$time
    state[,n_rxns] <- tmp$state
  }
  
  # Clean up data frames
  n <- which(state[2,] == 0)
  
  d <- data.frame(
    S = state[1, 1:n],
    I = state[2, 1:n],
    R = state[3, 1:n],
    time = time[1:n]
  ) %>%
    pivot_longer(-time, names_to = "state", values_to = "count") %>%
    mutate(
      state = factor(state, levels = c("S","I","R"))
    )
}


## ---- dependson="simulate_sir_outbreak"-------------------------------------------------------------------------------------------------
set.seed(1)
d <- simulate_outbreak(c(1000, 1, 0), rate = c(2,1))

ggplot(d, aes(x = time, y = count, color = state)) + 
  geom_step()


## ---- dependson="simulate_sir_outbreak"-------------------------------------------------------------------------------------------------
set.seed(4)
d <- simulate_outbreak(c(1000, 1, 0), rate = c(2,1))

ggplot(d, aes(x = time, y = count, color = state)) + 
  geom_step()


## ---------------------------------------------------------------------------------------------------------------------------------------
X0 <- c(1000, 2, 0)
rate <- c(2,1)

die_out <- replicate(1e3, {
  d <- simulate_outbreak(X0, rate)
  return(max(d$time) < 5)
})

mean(die_out)
binom.test(sum(die_out), length(die_out))$conf.int


## ---------------------------------------------------------------------------------------------------------------------------------------
X0 <- c(1000, 1, 0)
rate <- c(2,1)

infected <- replicate(1e3, {
  d <- simulate_outbreak(X0, rate)
  while(max(d$time) < 5)
    d <- simulate_outbreak(X0, rate)
  return(max(d$count[d$state == "R"]))
})

t.test(infected)$conf.int


## ----simulate_predator_prey_transition--------------------------------------------------------------------------------------------------
predator_prey_reaction_matrix <- rbind(
  #  R   F
  c( 1,  0),
  c(-1,  1),
  c( 0, -1)
)

#' Function to simulate a single predator-prey transition
#' 
#' This function will simulate a single predator-prety transition based on the 
#' current `state` of the system and the reaction `rates`
simulate_transition <- function(state, rate, initial_time) {
  propensity <- c(
    rate[1] * state[1],
    rate[2] * state[1] * state[2],
    rate[3] * state[2]
  )
  
  time_increment <- rexp(1, rate = sum(propensity))
  reaction       <- sample(1:3, 1, prob = propensity)
  
  # Update state according to reaction matrix
  state <- state + predator_prey_reaction_matrix[reaction,]
  
  return(
    list(
      time  = initial_time + time_increment,
      state = state
    ))
}


## ----simulate_predator_prey_system, dependson="simulate_predator_prey_transition"-------------------------------------------------------
simulate_predator_prey_system <- function(initial_state, rate, max_rxns = 1e4) {
  # Create storage structures for state and time
  n_possible_rxns <- max_rxns + 1
  state <- matrix(initial_state, nrow = 2, ncol = n_possible_rxns)
  n_rxns <- 1
  time   <- rep(0, n_possible_rxns) 
  
  # Simulate outbreak
  while(state[2,n_rxns] > 0 & n_rxns <= max_rxns ) {
    tmp <- simulate_transition(state[,n_rxns], rate, time[n_rxns])
    n_rxns         <- n_rxns + 1
    time[n_rxns]   <- tmp$time
    state[,n_rxns] <- tmp$state
  }
  
  d <- data.frame(
    R = state[1, ],
    F = state[2, ],
    time = time
  ) %>%
    pivot_longer(-time, names_to = "state", values_to = "count") %>%
    mutate(
      state = factor(state, levels = c("R","F"))
    )
}


## ---- dependson="simulate_predator_prey_system"-----------------------------------------------------------------------------------------
set.seed(1)
d <- simulate_predator_prey_system(c(20,20), rate = c(1,.01,1), max_rxns = 1e5)

ggplot(d, aes(x = time, y = count, color = state)) + 
  geom_step()

