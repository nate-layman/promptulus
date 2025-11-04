#!/usr/bin/env Rscript

# Promptulus Quick Start Script
# This script sets up and runs the Promptulus learning app

message("🧞 Welcome to Promptulus!")
message("Loading required packages...")

# Check if required packages are installed
required_packages <- c(
  "shiny", "bslib", "shinyjs", "ellmer", "jsonlite", "glue"
)

missing_packages <- required_packages[!sapply(required_packages, require, character.only = TRUE)]

if (length(missing_packages) > 0) {
  message("Installing missing packages...")
  install.packages(missing_packages, quiet = TRUE)
  message("Packages installed successfully!")
}

# Load the package
library(promptulus)

# Check for API key
if (Sys.getenv("OPENAI_API_KEY") == "") {
  message("\n⚠️  OPENAI_API_KEY not set!")
  message("Please set your OpenAI API key:")
  message("  Sys.setenv(OPENAI_API_KEY = 'sk-your-key-here')")
  message("\nOr create a .env file with:")
  message("  OPENAI_API_KEY=sk-your-key-here")
  message("\nYou can get your API key from: https://platform.openai.com/account/api-keys")
  message("\nWould you like to set it now? (y/n)")

  response <- readline()
  if (tolower(response) == "y") {
    message("Enter your OpenAI API key:")
    api_key <- readline()
    Sys.setenv(OPENAI_API_KEY = api_key)
    message("✓ API key set!")
  } else {
    message("Cannot proceed without API key.")
    quit(status = 1)
  }
}

message("\n🚀 Starting Promptulus...")
message("The app will open in your default browser at http://localhost:3838")

# Run the app
run_promptulus()
