library(tidyverse)
raw <- read_csv("dev_data.csv")
raw %>% glimpse


# Turn dates into datetime object
df1 <- raw
df1$Date <- df1$Date %>% as.Date(format = "%m/%d/%y")
df2 <- df1 %>% group_by(Ticker)


# Plot to get a feel for the data
library(ggplot2)
df2 %>%	ggplot(aes(x = Date, y = Open, color=Ticker)) +
	geom_line()


# Add some simple features
# 1. Add a simple daily return and excess return per ticker
df3 <- df2 %>% mutate(ret_1 = log(lead(Open)) - log(Open))


# Check correlation
cor_df <- df3 %>% select(Ticker, Date, ret_1) %>% 
	pivot_wider(names_from = Ticker, values_from = ret_1) %>% 
	select(-Date) %>% 
	cor(use='pairwise.complete.obs') %>% 
	as.table() %>% 
	as.data.frame()

ggplot(cor_df, aes(x=Var1, y=Var2, fill=Freq)) +
	geom_tile() +
	scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
	theme(axis.text.x = element_text(angle = 90, hjust = 1))
#	D correlated with F, H, G


# Split training/testing
library(tidymodels)
split <- df3 %>% initial_time_split(prop=0.75)
train <- split %>% training()
test <- split %>% testing()

