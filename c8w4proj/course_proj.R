library(tidyverse)
library(tidymodels)
raw_training <- read_csv('pml-training.csv')
raw_training %>% glimpse

# First column is simply the index (can cut it out of regression), last is 
# the outcome

training <- raw_training %>% mutate(classe=as.factor(classe)) %>% 
	mutate(user_name=as.factor(user_name))
training$classe %>% levels
training %>% map(~ mean(is.na(.))) %>% glimpse
# A lot of these variables have a very high NA rate and we can probably
# get rid of them, they seem to be summary statistics. We can also get
# rid of timestamps and other indexes

set.seed(123)
folds <- vfold_cv(training, v = 5, strata = classe)

rec <- recipe(classe ~ ., data=training) %>% 
	step_rm(`...1`, raw_timestamp_part_1, raw_timestamp_part_2, 
		cvtd_timestamp, new_window, num_window) %>% 
	step_filter_missing(all_predictors(), threshold=.95) %>% 
	step_impute_median(all_numeric_predictors()) %>% 
	step_normalize(all_numeric_predictors()) %>% 
	step_nzv(all_predictors())

mod <- rand_forest(trees = 200, mtry = 10, min_n = 5) %>%
	set_engine("ranger", importance='permutation') %>%
	set_mode("classification")

wf <- workflow() %>% add_recipe(rec) %>% add_model(mod)

results <- fit_resamples(
	wf, resamples = folds,
	metrics = metric_set(accuracy, kap, mn_log_loss),
	control = control_resamples(save_pred = FALSE)
)

collect_metrics(results) %>% arrange(desc(mean))

final_fit <- fit(wf, data=training)


raw_testing <- read_csv('pml-testing.csv')
testing <- raw_testing %>% mutate(user_name=as.factor(user_name))
pred_class <- predict(final_fit, new_data = testing)
pred_class

# Compare to a linear model
library(glmnet)
lin_mod <- parsnip::multinom_reg(penalty=double(1)) %>% set_engine('glmnet')
lin_wf <- workflow() %>% add_recipe(rec) %>% add_model(lin_mod)
lin_results <- fit_resamples(
	lin_wf, resamples = folds,
	metrics = metric_set(accuracy, kap, mn_log_loss),
	control = control_resamples(save_pred = FALSE)
)
collect_metrics(lin_results)
# Terrible metrics -> we did good with our initial nonlinear model.