library("tidyverse")
library("xtable")

d <- data.frame(z = seq(0, 3.49, by = 0.01)) |>
  mutate(p = round(pnorm(z), 4),
         last_digit = (z * 100) %% 10,
         last_digit = round(last_digit / 100,2),
         z = floor(z*10)/10,
         last_digit = as.character(last_digit)) |>
  pivot_wider(
    id_cols = z,
    names_from = last_digit,
    values_from = p
  ) |>
  arrange(z)

d |>
  xtable(
    caption = "Cumulative distribution function, $P(Z \\le z)$, for standard normal",
    align   = "rl|llllllllll",
    digits  = c(NA,1,rep(4,10))
  ) |>
  print.xtable(
    file = "ztable.tex",
    include.rownames = FALSE,
    caption.placement = "top"
  )
  