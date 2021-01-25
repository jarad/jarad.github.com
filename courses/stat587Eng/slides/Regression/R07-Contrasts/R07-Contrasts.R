## ----options, echo=FALSE, warning=FALSE, message=FALSE----------------------------------------------------------------
options(width=120)
opts_chunk$set(comment=NA, 
               fig.width=6, 
               fig.height=4.5, 
               size='tiny', 
               out.width='\\textwidth', 
               fig.align='center', 
               echo=FALSE,
               message=FALSE)


## ----libraries, message=FALSE, warning=FALSE, echo=FALSE--------------------------------------------------------------
library("tidyverse")
library("xtable")
library("Sleuth3")
library("emmeans")
library("ggResidpanel")


## ----set_seed, echo=FALSE---------------------------------------------------------------------------------------------
set.seed(2)


## ---------------------------------------------------------------------------------------------------------------------
ggplot(Sleuth3::case0501, aes(x = Diet, y = Lifetime)) + 
  geom_jitter(width = 0.1, height = 0) +
  stat_summary(fun = mean, fun.min = mean, fun.max = mean,
               geom = "crossbar", width = .5, color = "magenta") +
  theme_bw()


## ----K,echo=FALSE-----------------------------------------------------------------------------------------------------
K = rbind("early rest - none @ 50kcal"=c( 0, 0,-1, 0, 1, 0),
          "40kcal/week - 50kcal/week" =c( 0, 2,-1, 0,-1, 0) / 2, # note the denominator here
          "lo cal - hi cal"           =c(-2, 1, 1,-2, 1, 1) / 4) # and here
colnames(K) = levels(case0501$Diet)

## ----echo=FALSE,results='asis'----------------------------------------------------------------------------------------
print(xtable(K))


## ----echo = TRUE------------------------------------------------------------------------------------------------------
m = lm(Lifetime ~ Diet, data = Sleuth3::case0501) 
summary(m)


## ----echo = TRUE------------------------------------------------------------------------------------------------------
library("emmeans")
em = emmeans(m, ~ Diet)
em


## ---------------------------------------------------------------------------------------------------------------------
# (Complicated) code to construct list from data.frame by row
# https://stackoverflow.com/questions/3492379/data-frame-rows-to-a-list
# you could just construct lists from the beginning, but the K data.frame is 
# used previously in the code to construct the contrasts by hand
K_list <- split(K, seq(nrow(K)))
K_list <- setNames(split(K, seq(nrow(K))), rownames(K))


## ----echo = TRUE------------------------------------------------------------------------------------------------------
K_list


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
co = contrast(em, K_list)

# p-values (and posterior tail probabilities)
co

# confidence/credible intervals
confint(co)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
text = 
"inf trt row col
9  F3   4   1
12   O   4   2
18  S6   4   3
10 F12   4   4
24  S6   4   5
17 S12   4   6
30  S3   4   7
16  F6   4   8
10   O   3   1
7  S3   3   2
4 F12   3   3
10  F6   3   4
21  S3   3   5
24   O   3   6
29   O   3   7
12  S6   3   8
9  F3   2   1
7 S12   2   2
18  F6   2   3
30   O   2   4
18  F6   2   5
16 S12   2   6
16  F3   2   7
4 F12   2   8
9  S3   1   1
18   O   1   2
17 S12   1   3
19  S6   1   4
32   O   1   5
5 F12   1   6
26   O   1   7
4  F3   1   8"

d <- read.table(textConnection(text), header=TRUE) %>%
  mutate(sulfur = as.numeric(gsub("\\D","",trt))*100,
         sulfur = ifelse(is.na(sulfur), 0, sulfur),
         application = fct_recode(gsub("\\d","",trt), 
                                  fall = "F", 
                                  spring = "S",
                                  NULL = "O"),
         application = fct_explicit_na(application),
         treatment = factor(trt, 
               levels=c("F12","F6","F3","O","S3","S6","S12")))
         
d


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
plot(0,0, xlab="col", ylab="row", 
     main="Completely randomized design\n potato scab experiment",
     xlim=range(d$col)+c(-.5,.5), ylim=range(d$row)+c(-.5,.5), axes=F, type="n")
text(d$col, d$row, d$trt)
axis(1, 1:8, lwd=0)
axis(2, 1:4, lwd=0)
segments(1:9-.5,0.5,1:9-.5,4.5)
segments(0.5,1:5-.5,8.5,1:5-.5)


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
plot(0,0, xlab="Sulfur (lbs/acre)", ylab="Application", 
     main="Treatment visualization",
     type="n", axes=F,
     xlim=c(-100,1500), ylim=c(.5,2.5))
axis(1, c(0,300,600,1200), lwd=0)
axis(2, c(1,2), c("spring","fall"), lwd=0)
xc = c(0,300,300,600,600,1200,1200)
yc = c(1.5,1,2,1,2,1,2)
rect(xc-100,yc-.4,xc+100,yc+.4)
text(xc,yc, c(8,rep(4,6)))


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(d, 
       aes(treatment, inf)) + 
  geom_boxplot(color="gray", outlier.shape = NA) + 
  geom_jitter(height=0) +
  labs(x = "Sulfur", y = "Average scab percent") + 
  theme_bw()


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
ggplot(d %>% 
         mutate(application = fct_explicit_na(application)), 
       aes(sulfur, inf, shape=application, color=application)) + 
  geom_jitter(height=0, width=10) +
  labs(x = "Sulfur", y = "Average scab percent") + 
  theme_bw()


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
qplot(col, inf, data=d, shape=application, color = sulfur, geom="jitter", 
      xlab="Column ID", ylab="Average scab percent") + 
  theme_bw()


## ----echo=FALSE-------------------------------------------------------------------------------------------------------
qplot(row, inf, data=d, shape=application, color = sulfur, geom="jitter", 
      xlab="Row ID", ylab="Average scab percent") + 
  theme_bw()


## ----potato_in_R, echo = TRUE-----------------------------------------------------------------------------------------
K = 
#                                         F12 F6 F3  0 S3 S6 S12           
               list("sulfur - control" = c( 1, 1, 1,-6, 1, 1,  1)/6,
                    "fall - spring"    = c( 1, 1, 1, 0,-1,-1, -1)/3,
                    "linear trend"     = c( 6, 0,-3,-6,-3, 0,  6)/1)

m = lm(inf ~ treatment, data = d)
anova(m)


## ---------------------------------------------------------------------------------------------------------------------
resid_panel(m, plots = c("resid","qq","cookd","index","ls","lev"), 
            qqbands = TRUE, smoother = TRUE)


## ----echo=TRUE--------------------------------------------------------------------------------------------------------
em <- emmeans(m, ~treatment); em

co <- contrast(em, K)
confint(co)


## ---------------------------------------------------------------------------------------------------------------------
d$residuals <- residuals(m)
ggplot(d, aes(col, residuals)) + geom_point() + stat_smooth(se=FALSE) + theme_bw()

