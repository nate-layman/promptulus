#!/usr/bin/env Rscript

# Test script for Promptulus with fixed code

library(dotenv)
load_dot_env(".env")

message("✓ Environment variables loaded\n")

# Run app on port 3839
shiny::runApp(
  appDir = "inst/shiny-app",
  host = "127.0.0.1",
  port = 3839,
  launch.browser = FALSE
)
