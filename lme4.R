rm(list = ls())
library(lme4)
library(data.table)
library(tictoc)

ratings <- fread("ml-20m/ratings.csv", drop = "timestamp")
ratings[, liked :=  rating > 3.5]
mean(ratings[["liked"]])
# sample_idx <- sample(1:nrow(ratings), 1000000)

fast_control <- glmerControl(optimizer = "nloptwrap",
                            calc.derivs = FALSE)
print(tic())
m <- glmer(liked ~ 1 + (1 | userId) + (1 | movieId),
          control = fast_control,
          family = binomial,
          data=ratings)
          # data = ratings[sample_idx, ])
VarCorr(m)
print(toc())

# 100K -> 75s
# 500K -> 1060 seconds . varcorr = list(userId=0.894, movieId=1.017)
# 1000K -> 3000 seconds varcorr = list(userId=0.917, moveIed=1.05)
