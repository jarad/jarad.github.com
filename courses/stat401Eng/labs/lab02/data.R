# This produces a few data files for use in the lab. 


library(HootOwlHoot)
library(dplyr)

# Create blinded treatments
set.seed(20170116)
blinded_treatments <- expand.grid(first = LETTERS, second = LETTERS) %>%
  mutate(treatment_code <- paste0(first,second))

treatments <- expand.grid(n_players = 2:4, 
                         n_owls = 1:6,
                         n_cards_per_player = 2:4,
                         strategy = c("random",
                                      "last_owl_farthest",
                                      "last_owl_random"),
                         stringsAsFactors = FALSE) %>%
  mutate(code = sample(blinded_treatments$treatment_code, n()))

readr::write_csv(treatments, path = "treatment_codes.csv")


# Experiment
run_experiment_wrap <- function(d) {
  run_experiment(n_players          = d$n_players,
                 n_owls             = d$n_owls,
                 strategy           = d$strategy,
                 n_cards_per_player = d$n_cards_per_player)
}

missing_combos <- treatments[sample(nrow(treatments), nrow(treatments)-4),]
replicated <- bind_rows(missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos,
                        missing_combos)
replicated$rep <- rep(1:10, each=nrow(missing_combos))
missing_reps <- replicated[sample(nrow(replicated), nrow(replicated)-20),]

results <- missing_reps %>%
  rowwise %>%
  do(run_experiment_wrap(.))

experiments <- bind_cols(missing_reps, results) %>%
  select(code, rep, win, n_cards_played, n_suns_played, owl_score, n_owls_left)

readr::write_csv(experiments, path="experiments.csv")



