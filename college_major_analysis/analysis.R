mydf <- college
mydf$major <- as.factor(mydf$major)
mydf$major_category <- as.factor(mydf$major_category)

fit1 <- lm(median ~ major_category, mydf)
plot(mydf$major_category, mydf$median)
anova(fit1)

# I pick percent men since it seems like that would be a category that could
# affect median earnings.
fit2 <- lm(median ~ major_category + perc_men, mydf)
anova(fit2)

fit3 <- lm(median ~ major_category + perc_men + major_category * perc_men, mydf)
anova(fit3)
# We get a low p-value for the interaction between percent men and major
# category, meaning that median incomes are differently sensitive to percent of 
# men depending on their individual category.

library(ggplot2)
g <- ggplot(mydf, aes(x=perc_men, y=median, color=major_category))
g + geom_point() + geom_smooth(method='lm', se=FALSE) + theme_minimal()
# We see an extremely positive trend for the Business major category.

library(dplyr)
fit4 <- mydf %>% filter(major_category=='Business') %>% lm(median ~ perc_men, .)
anova(fit4)
# We confirm that percentage of men is statistically significant for Business 
# major (category) income.