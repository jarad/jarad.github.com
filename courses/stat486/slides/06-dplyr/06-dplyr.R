## -----------------------------------------------------------------------------------
library("tidyverse")


## ---- eval=FALSE--------------------------------------------------------------------
## ?tibble


## -----------------------------------------------------------------------------------
ToothGrowth


## -----------------------------------------------------------------------------------
as_tibble(ToothGrowth)


## -----------------------------------------------------------------------------------
ToothGrowth[ToothGrowth$supp == "VC", ]
subset(ToothGrowth, supp == "VC")


## -----------------------------------------------------------------------------------
ToothGrowth[ToothGrowth$len < 10, ]
subset(ToothGrowth, len < 10)


## -----------------------------------------------------------------------------------
subset(ToothGrowth, len < 10 & supp == "VC") # using the AND operator &


## ---- eval=FALSE--------------------------------------------------------------------
## ?`::`


## -----------------------------------------------------------------------------------
dplyr::filter(ToothGrowth, supp == "VC")


## -----------------------------------------------------------------------------------
dplyr::filter(ToothGrowth, len < 10)


## -----------------------------------------------------------------------------------
dplyr::filter(ToothGrowth, len < 10, supp == "VC")


## -----------------------------------------------------------------------------------
ToothGrowth[order(ToothGrowth$len), ]


## -----------------------------------------------------------------------------------
arrange(ToothGrowth, len)


## -----------------------------------------------------------------------------------
arrange(ToothGrowth, supp, dose)


## -----------------------------------------------------------------------------------
ToothGrowth[, c("len","dose")]


## -----------------------------------------------------------------------------------
ToothGrowth[, c(1,3)]


## -----------------------------------------------------------------------------------
ToothGrowth[, -2]


## -----------------------------------------------------------------------------------
subset(ToothGrowth, select = c(len, dose))


## -----------------------------------------------------------------------------------
dplyr::select(ToothGrowth, len, dose)


## -----------------------------------------------------------------------------------
dplyr::select(ToothGrowth, c(1,3))


## -----------------------------------------------------------------------------------
dplyr::select(ToothGrowth, -2)


## -----------------------------------------------------------------------------------
dplyr::select(ToothGrowth, -supp)


## -----------------------------------------------------------------------------------
select(ToothGrowth, starts_with("len"))


## ---- eval=FALSE--------------------------------------------------------------------
## ?starts_with


## -----------------------------------------------------------------------------------
d <- ToothGrowth
names(d)
names(d) <- c("Length","Delivery","Dose")
head(d)


## ---- eval=FALSE--------------------------------------------------------------------
## ?make.names


## -----------------------------------------------------------------------------------
names(d)[2] <- "Delivery Method"
names(d)


## ---- error=TRUE--------------------------------------------------------------------
d$Delivery Method


## -----------------------------------------------------------------------------------
d$`Delivery Method`


## -----------------------------------------------------------------------------------
d <- ToothGrowth
names(d)

d <- rename(d,
  Length = len,
  `Delivery Method` = supp,
  Dose = dose
)
names(d)


## ---- eval=FALSE--------------------------------------------------------------------
## d <- ToothGrowth
## d$`Length (mm)` = d$len / 1000 # original length was in microns
## head(d)


## -----------------------------------------------------------------------------------
mutate(ToothGrowth, `Length (mm)` = len)


## -----------------------------------------------------------------------------------
mean(ToothGrowth$len)


## -----------------------------------------------------------------------------------
table(ToothGrowth$supp)


## -----------------------------------------------------------------------------------
dplyr::summarize(ToothGrowth, mean_len = mean(len))


## -----------------------------------------------------------------------------------
dplyr::summarize(
  ToothGrowth,
  n_VC = sum(supp == "VC"),
  n_OJ = sum(supp == "OJ"),               
)


## -----------------------------------------------------------------------------------
16 %>% sqrt()


## -----------------------------------------------------------------------------------
256 %>% sqrt() %>% sqrt()


## -----------------------------------------------------------------------------------
16 |> sqrt()


## -----------------------------------------------------------------------------------
ToothGrowth %>%
  filter(dose == 0.5, supp == "VC") %>%
  summarize(
    n = n(), 
    mean = mean(len),
    sd = sd(len))


## -----------------------------------------------------------------------------------
ToothGrowth %>%
  group_by(supp, dose) %>%
  summarize(
    n    = n(),
    mean = mean(len),
    sd   = sd(len),
    .groups = "drop"
  ) 


## -----------------------------------------------------------------------------------
s <- ToothGrowth %>%
  group_by(supp, dose) %>%
  summarize(
    n    = n(),
    mean = mean(len),
    sd   = sd(len),
    .groups = "drop"
  ) %>%
  mutate(
    ucl = mean + qt(.975, n-1)*sd/sqrt(n),
    lcl = mean - qt(.975, n-1)*sd/sqrt(n)
  )


## -----------------------------------------------------------------------------------
dw <- 0.1
ggplot(s, 
       aes(x = dose, color = supp, shape = supp)) +
  
  geom_point(
    data = ToothGrowth,
    aes(y = len),
    position = position_jitterdodge(dodge.width = dw, jitter.width = 0.05)) +
  
  geom_pointrange(
    data = s, 
    aes(y = mean, ymin = lcl, ymax = ucl),
    position = position_dodge(width = dw), 
    shape = 0,
    show.legend = FALSE
    ) +
  
  geom_line(
    aes(y = mean, group = supp),
    position = position_dodge(width = dw)) +
  
  scale_x_log10() +
  
  labs(
    x = "Dose (mg/day)", 
    y = "Length (\u00b5m)", # unicode \u00b5 is the Greek letter mu
    title = "Odontoblast length vs Vitamin C in Guinea Pigs",
    color = "Delivery Method",
    shape = "Delivery Method") +
  
  theme_bw() +
  theme(legend.position = c(0.8, 0.2),
        legend.background = element_rect(fill = "white",
                                        color = "black"))


## -----------------------------------------------------------------------------------
t <- s %>%
  mutate(ci = paste0(format(mean, digits = 1, nsmall = 1), 
                    " (", 
                    format(lcl,  digits = 1, nsmall = 1),
                    ", ",
                    format(ucl,  digits = 1, nsmall = 1),
                    ")")) %>%
  tidyr::pivot_wider(id_cols = dose, names_from = supp, values_from = ci) %>%
  rename(
    `Orange Juice` = "OJ",
    `Ascorbic Acid` = "VC",
    Dose = dose
  )

t


## -----------------------------------------------------------------------------------
library("xtable")
cap <- "Mean odonotoblast length (\u00b5m) with 95% CIs."
xt <- xtable::xtable(t, 
             caption=cap,
             align="rr|rr")


## ---- results='asis'----------------------------------------------------------------
print(xt, type = "html", 
      include.rownames = FALSE,
      caption.placement = "top")


## -----------------------------------------------------------------------------------
library("knitr")
knitr::kable(t, caption = cap, align = "r")

