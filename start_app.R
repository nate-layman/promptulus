#!/usr/bin/env Rscript

# Simple app starter without devtools dependency

# Set CRAN mirror
options(repos = c(CRAN = "https://cran.r-project.org"))

# Load environment from .env file
env_file <- file.path(getwd(), ".env")
if (file.exists(env_file)) {
  env_vars <- readLines(env_file)
  for (line in env_vars) {
    if (grepl("^#", line) || grepl("^\\s*$", line)) next
    if (grepl("=", line)) {
      parts <- strsplit(line, "=", fixed = TRUE)[[1]]
      if (length(parts) == 2) {
        key <- trimws(parts[1])
        value <- trimws(parts[2])
        Sys.setenv(key = value)
      }
    }
  }
  message("✓ Loaded environment variables from .env")
}

# Check API key
api_key <- Sys.getenv("OPENAI_API_KEY")
if (api_key == "") {
  message("\n⚠️  OPENAI_API_KEY not set!")
  message("Please create a .env file with: OPENAI_API_KEY=sk-your-key")
  message("Or set it in R: Sys.setenv(OPENAI_API_KEY = 'sk-your-key')")
  quit(status = 1)
}

message("✓ API key configured")

# Source and run the app
message("\n🚀 Starting Promptulus...")
shiny::runApp(
  appDir = "inst/shiny-app",
  host = "127.0.0.1",
  port = 3838,
  launch.browser = TRUE
)
