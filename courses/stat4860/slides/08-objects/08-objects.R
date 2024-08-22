## -------------------------------------------------------------------------------------
library("tidyverse")


## -------------------------------------------------------------------------------------
nums <- c(2.5, -3.2, 9, pi, 2, 0.2)
ints <- c(1L, 5L, 99L, 103L)
chrs <- c("my character vector")
lgls <- c(TRUE, FALSE, FALSE, TRUE)


## -------------------------------------------------------------------------------------
is.vector(nums)
is.vector(ints)
is.vector(chrs)
is.vector(lgls)


## -------------------------------------------------------------------------------------
length(nums)
length(ints)
length(chrs)
length(lgls)


## -------------------------------------------------------------------------------------
typeof(nums)
typeof(ints)
typeof(chrs)
typeof(lgls)


## -------------------------------------------------------------------------------------
ints
typeof(c(1,5,99,103))


## -------------------------------------------------------------------------------------
mode(nums)
mode(ints)
mode(chrs)
mode(lgls)


## -------------------------------------------------------------------------------------
storage.mode(nums)
storage.mode(ints)
storage.mode(chrs)
storage.mode(lgls)


## -------------------------------------------------------------------------------------
class(nums)
class(ints)
class(chrs)
class(lgls)


## -------------------------------------------------------------------------------------
attributes(nums)


## -------------------------------------------------------------------------------------
names(nums) <- LETTERS[1:length(nums)]
nums
names(nums)


## -------------------------------------------------------------------------------------
attributes(nums)


## -------------------------------------------------------------------------------------
dim(nums)


## -------------------------------------------------------------------------------------
dim(nums) <- c(2,3)
nums
names(nums)
dim(nums)
attributes(nums)


## -------------------------------------------------------------------------------------
is.vector(nums)
typeof(nums)


## -------------------------------------------------------------------------------------
is.matrix(nums)
colnames(nums) <- LETTERS[1:ncol(nums)]
rownames(nums) <- letters[1:nrow(nums)]
nums
attributes(nums)
typeof(nums)
mode(nums)
storage.mode(nums)
class(nums)


## -------------------------------------------------------------------------------------
nums <- as.data.frame(nums)
is.matrix(nums)
is.data.frame(nums)
nums
attributes(nums)
typeof(nums)
mode(nums)
storage.mode(nums)
class(nums)


## -------------------------------------------------------------------------------------
nums <- as.list(nums)
is.data.frame(nums)
is.list(nums)
length(nums)

nums
nums[[1]]
nums$B
attributes(nums)
typeof(nums)
mode(nums)
storage.mode(nums)
class(nums)


## -------------------------------------------------------------------------------------
l <- list(
  x = 1:10,
  y = rnorm(10)
)
l$model <- lm(l$y ~ l$x)

l
l$model
attributes(nums)
typeof(nums)
mode(nums)
storage.mode(nums)
class(nums)

attributes(l$model)
typeof(l$model)
mode(l$model)
storage.mode(l$model)
class(l$model)


## -------------------------------------------------------------------------------------
attributes(ToothGrowth)
typeof(ToothGrowth)
mode(ToothGrowth)
storage.mode(ToothGrowth)
class(ToothGrowth)


## -------------------------------------------------------------------------------------
attributes(ToothGrowth$supp)


## -------------------------------------------------------------------------------------
comps <- c(1i, 2+2i, 3+4i)
attributes(comps)
typeof(comps)
mode(comps)
storage.mode(comps)
class(comps)


## -------------------------------------------------------------------------------------
raws <- raw(3)
attributes(raws)
typeof(raws)
mode(raws)
storage.mode(raws)
class(raws)


## -------------------------------------------------------------------------------------
is.factor(ToothGrowth$supp)

attributes(ToothGrowth$supp)
typeof(ToothGrowth$supp)
mode(ToothGrowth$supp)
storage.mode(ToothGrowth$supp)
class(ToothGrowth$supp)


## -------------------------------------------------------------------------------------
ToothGrowth$supp
summary(ToothGrowth$supp)


## -------------------------------------------------------------------------------------
as.numeric(ToothGrowth$supp)    # integer representation
as.character(ToothGrowth$supp)

nlevels(ToothGrowth$supp)
levels(ToothGrowth$supp)   # LOOKUP table


## -------------------------------------------------------------------------------------
my_char <- c(letters[1:3], LETTERS[1:3])
my_char

my_fact <- as.factor(my_char)
my_fact
levels(my_fact)


## -------------------------------------------------------------------------------------
my_fact2 <- factor(my_fact, levels = c(letters[1:3], LETTERS[1:3]))
my_fact2
levels(my_fact2)


## -------------------------------------------------------------------------------------
ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_boxplot()


## -------------------------------------------------------------------------------------
my_fact <- factor(c("a1", "a2", "a10"))
levels(my_fact)


## -------------------------------------------------------------------------------------
m <- lm(len ~ supp, data = ToothGrowth)
coef(m)


## -------------------------------------------------------------------------------------
d <- ToothGrowth %>%
  mutate(supp = relevel(supp, ref = "VC"))

m <- lm(len ~ supp, data = d)
coef(m)

