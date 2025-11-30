library(AppliedPredictiveModeling)
library(caret)
library(pgmm)
library(rpart) # Necessary???
library(lubridate)
library(forecast)
library(dplyr)
library(e1071)
library(gbm)


# Question 1

# data(vowel.train)
# data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)

mod1 <- train(y ~ ., data=vowel.train, 
	      method="rf")
mod2 <- train(y ~ ., data=vowel.train,
	      method="gbm", verbose=F)

pred1 <- predict(mod1, vowel.test)
pred2 <- predict(mod2, vowel.test)

confusionMatrix(pred1, vowel.test$y)$overall[[1]]
confusionMatrix(pred2, vowel.test$y)$overall[[1]]
df <- data.frame(pred1, pred2, y=vowel.test$y)
ensemble_agreement <- df %>% rowwise() %>% 
	filter(n_distinct(
		c_across(1:2)) == 1)
ensemble_agreement %>% filter(pred1==y) %>% 
	nrow() / (ensemble_agreement %>% 
		    	nrow())


# Question 2

rm(list = ls())
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
set.seed(62433)

mod1 <- train(diagnosis~., data=training,
	      method="rf")
mod2 <- train(diagnosis~., data=training,
	      method="gbm", verbose=F)
mod3 <- train(diagnosis~., data=training,
	      method="lda")

pred1 <- predict(mod1, testing)
pred2 <- predict(mod2, testing)
pred3 <- predict(mod3, testing)

confusionMatrix(pred1, testing$diagnosis)$overall[[1]]
confusionMatrix(pred2, testing$diagnosis)$overall[[1]]
confusionMatrix(pred3, testing$diagnosis)$overall[[1]]

df <- data.frame(pred1, pred2, pred3, diagnosis=testing$diagnosis)
combMod <- train(diagnosis~., method="rf", data=df)
combPred <- predict(combMod, df)
confusionMatrix(combPred, testing$diagnosis)$overall[[1]]


# Question 3

library(elasticnet)
rm(list=ls())
set.seed(3523)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(233)

mod1 <- train(CompressiveStrength~., method="lasso", data=training)
mod1$finalModel %>% plot.enet(xvar="penalty", use.color = T)


# Question 4

rm(list=ls())
dat = read.csv("C:/Users/polop/Downloads/gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

mod1 <- bats(tstrain)
fcast <- forecast(mod1, level=95, h=dim(testing)[1])
sum(fcast$lower < testing$visitsTumblr & 
    	testing$visitsTumblr < fcast$upper) / 
	dim(testing)[1]


# Question 5

rm(list=ls())
set.seed(3523)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(325)

mod1 <- e1071::svm(CompressiveStrength~., data=training)
pred <- predict(mod1, testing)

sqrt(sum((testing$CompressiveStrength - pred)^2) / nrow(testing))
accuracy(pred, testing$CompressiveStrength)
