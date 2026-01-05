library(shiny)
library(ggplot2)

simulate_gbm <- function(S0, mu, sigma, T_years, steps, n_sims, seed = NULL) {
	set.seed(12345)
	dt <- T_years / steps
	t <- seq(0, T_years, length.out=steps+1)
	
	Z <- matrix(rnorm(steps * n_sims), nrow = steps, ncol = n_sims)
	increments <- (mu - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * Z
	
	log_paths <- apply(increments, 2, cumsum)            # steps x n_sims
	log_paths <- rbind(rep(0, n_sims), log_paths)        # add time 0
	paths <- S0 * exp(log_paths)                         # (steps+1) x n_sims
	
	list(t = t, paths = paths)
}

function(input, output, session) {
	sim <- eventReactive(input$run, {
		set.seed(12345)
		
		validate(
			need(input$S0 > 0, "Initial Price must be > 0"),
			need(input$steps >= 1, "# Steps must be >= 1"),
			need(input$n_sims >= 1, "# Simulations must be >= 1"),
			need(input$sigma >= 0, "Ann. Volatility must be >= 0")
		)
		
		simulate_gbm(
			S0 = input$S0,
			mu = input$mu,
			sigma = input$sigma,
			T_years = input$T,
			steps = input$steps,
			n_sims = input$n_sims,
		)
	})
	
	output$mc_plot <- renderPlot({
		s <- sim()
		req(s)
		
		t <- s$t
		paths <- s$paths
		k <- min(input$show_paths, ncol(paths))
		idx <- seq_len(k)
		
		q <- apply(paths, 1, quantile, probs = c(0.05, 0.5, 0.95))
		df_band <- data.frame(
			t = t,
			q05 = q[1,],
			q50 = q[2,],
			q95 = q[3,]
		)
		
		# long df for sample paths
		df_paths <- data.frame(
			t = rep(t, times = k),
			sim = rep(paste0("sim_", idx), each = length(t)),
			price = as.vector(paths[, idx])
		)
		
		ggplot() +
			geom_line(data = df_paths, aes(t, price, group = sim), alpha = 0.25) +
			geom_ribbon(data = df_band, aes(t, ymin = q05, ymax = q95), alpha = 0.25) +
			geom_line(data = df_band, aes(t, q50), linewidth = 1) +
			labs(x = "Time (years)", y = "Price", title = "Sample paths + 5/50/95% bands") +
			theme_minimal()
	})
	
	output$summary_tbl <- renderTable({
		s <- sim()
		req(s)
		
		terminal <- s$paths[nrow(s$paths), ]
		S0 <- input$S0
		ret <- terminal / S0 - 1
		
		data.frame(
			Metric = c("Mean terminal price", "Median terminal price", "5% terminal price", "95% terminal price",
				   "Mean return", "P(terminal < S0)"),
			Value = c(mean(terminal), median(terminal), quantile(terminal, 0.05), quantile(terminal, 0.95),
				  mean(ret), mean(terminal < S0))
		)
	}, digits = 4)
}
