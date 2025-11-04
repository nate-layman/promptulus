# Load environment variables from .env file
.env_file <- file.path(getwd(), ".env")
if (file.exists(.env_file)) {
  env_vars <- readLines(.env_file)
  for (line in env_vars) {
    # Skip comments and empty lines
    if (grepl("^#", line) || grepl("^\\s*$", line)) next

    # Parse KEY=VALUE format
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
