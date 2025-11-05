#!/usr/bin/env Rscript

# Helper script to export Shiny app to shinylive format for GitHub Pages deployment
# This script embeds your API key and exports to the docs/ folder

cat("=== Shinylive Export Script ===\n\n")

# Check if shinylive is installed
if (!requireNamespace("shinylive", quietly = TRUE)) {
  cat("Error: shinylive package not found.\n")
  cat("Install it with: install.packages('shinylive')\n")
  quit(status = 1)
}

# Get API key from .env file
if (!file.exists(".env")) {
  cat("Error: .env file not found.\n")
  cat("Copy .env.example to .env and add your API key first.\n")
  quit(status = 1)
}

env_vars <- readLines(".env")
api_key_line <- grep("^GEMINI_API_KEY=", env_vars, value = TRUE)

if (length(api_key_line) == 0) {
  cat("Error: GEMINI_API_KEY not found in .env file.\n")
  quit(status = 1)
}

api_key <- sub("^GEMINI_API_KEY=", "", api_key_line)
api_key <- trimws(api_key)

if (api_key == "your_api_key_here" || api_key == "") {
  cat("Error: Please set a valid GEMINI_API_KEY in your .env file.\n")
  quit(status = 1)
}

cat("✓ Found API key in .env\n")

# Create a temporary copy of app.R with embedded API key
cat("✓ Creating temporary app with embedded API key...\n")

app_code <- readLines("app/app.R")
app_code_modified <- gsub(
  'Sys\\.getenv\\("GEMINI_API_KEY"\\)',
  sprintf('"%s"', api_key),
  app_code
)

# Create temp app folder
temp_app_dir <- "app_temp"
if (dir.exists(temp_app_dir)) {
  unlink(temp_app_dir, recursive = TRUE)
}
dir.create(temp_app_dir)

# Copy app files to temp
file.copy("app", temp_app_dir, recursive = TRUE)

# Write modified app.R to temp
writeLines(app_code_modified, file.path(temp_app_dir, "app", "app.R"))

cat("✓ Temporary app created\n")

# Export to docs/ folder
cat("✓ Exporting to docs/ folder using shinylive...\n")
cat("  This may take a minute...\n\n")

shinylive::export(file.path(temp_app_dir, "app"), "docs")

# Clean up temp
unlink(temp_app_dir, recursive = TRUE)

cat("\n=== Export Complete! ===\n\n")
cat("Your app has been exported to the docs/ folder.\n\n")
cat("Next steps:\n")
cat("1. Test locally:\n")
cat("   python -m http.server 8000 -d docs\n")
cat("   # Then visit http://localhost:8000\n\n")
cat("2. Deploy to GitHub:\n")
cat("   git add docs/\n")
cat("   git commit -m 'Update shinylive deployment'\n")
cat("   git push\n\n")
cat("3. Enable GitHub Pages:\n")
cat("   Settings → Pages → Source: main branch, /docs folder\n\n")
cat("⚠️  SECURITY NOTE: Your API key is embedded in the docs/ folder.\n")
cat("   Only use this with Gemini's free tier for public demos.\n\n")
