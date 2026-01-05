library(shiny)

fluidPage(
    titlePanel("Simple Monte Carlo Simulation + Visualization"),
    sidebarLayout(
	sidebarPanel(
    		numericInput("S0", "Initial Price", value = 100, min = 0.01, step = 1),
    		numericInput("mu", "Annual Drift", value = 0.08, step = 0.01),
    		numericInput("sigma", "Annual Volatility", value = 0.20, min = 0, step = 0.01),
    		numericInput("T", "Time Horizon (years)", value = 1, min = 1/365, step = 0.25),
    		numericInput("steps", "Time steps", value = 252, min = 1, step = 1),
    		numericInput("n_sims", "# Simulations", value = 5000, min = 1, step = 100),
    		
    		sliderInput("show_paths", "Sample Paths Shown", 
    			    min = 10, max = 300, value = 80, step = 10),
    		actionButton("run", "Run Simulation", class = "btn-primary")
    	),
        mainPanel(
        	plotOutput("mc_plot", height = 420),
        	tableOutput("summary_tbl")
        )
    )
)
