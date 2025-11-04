#!/usr/bin/env Rscript

# Promptulus Shiny App Launcher
# Uses dotenv for clean environment variable management

# Set CRAN mirror
options(repos = c(CRAN = "https://cran.r-project.org"))

message("🧞 Promptulus App Launcher\n")

# Install dotenv if needed
if (!require("dotenv", quietly = TRUE)) {
  message("📦 Installing dotenv package...")
  install.packages("dotenv", repos = "https://cran.r-project.org", quiet = TRUE)
}

# Load environment from .env file
library(dotenv)
load_dot_env(".env")

message("✓ Environment loaded")

# Check API key
api_key <- Sys.getenv("OPENAI_API_KEY")
if (api_key == "") {
  message("\n⚠️  OPENAI_API_KEY not set!")
  message("\nPlease set your OpenAI API key in one of these ways:\n")
  message("  1. Create a .env file with:")
  message("     OPENAI_API_KEY=sk-your-api-key-here\n")
  message("  2. Or set it in R:")
  message("     Sys.setenv(OPENAI_API_KEY = 'sk-your-api-key-here')\n")
  message("Get your key from: https://platform.openai.com/account/api-keys\n")
  quit(status = 1)
}

message("✓ API key configured")

# Verify required packages
required_packages <- c("shiny", "bslib", "shinyjs", "openai", "jsonlite", "glue")
missing_packages <- required_packages[!sapply(required_packages, require, character.only = TRUE)]

if (length(missing_packages) > 0) {
  message("\n📦 Installing missing packages: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages, repos = "https://cran.r-project.org", quiet = TRUE)
  message("✓ Packages installed")
}

# Source and run the app
message("\n🚀 Starting Promptulus at http://localhost:3838...")
message("   (App will open in your default browser)\n")

shiny::runApp(
  appDir = "inst/shiny-app",
  host = "127.0.0.1",
  port = 3838,
  launch.browser = TRUE
)
