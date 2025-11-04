#!/usr/bin/env Rscript
# Simple Promptulus launcher

# Load environment variables
library(dotenv)
load_dot_env(".env")

# Run the app
shiny::runApp(
  appDir = "inst/shiny-app",
  host = "127.0.0.1",
  port = 3838,
  launch.browser = TRUE
)
