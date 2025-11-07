# -----------------------------
# Function to get all dependencies of a package, including itself last
# -----------------------------
get_dependencies_with_self <- function(pkg) {
  deps <- tools::package_dependencies(
    packages = pkg,
    db = available.packages(),
    which = c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances"),
    recursive = TRUE
  )[[1]]
  
  unique(c(deps, pkg))  # dependencies + package itself
}

# -----------------------------
# Generic function to uninstall and reinstall a package and its dependencies
# -----------------------------
renv_reinstall <- function(pkg) {
  # Disable renv cache for this project (only affects current project)
  renv::settings$use.cache(FALSE)
  
  # Get all recursive dependencies, plus the package itself
  deps <- get_dependencies_with_self(pkg)
  
  # Remove all dependencies from the project library
  message("Removing existing installations...")
  renv::remove(deps)
  
  # Initialize a list to store failed installs
  failed <- list()
  
  # Reinstall each dependency from source with error handling
  for (x in deps) {
    message("Installing from source: ", x)
    result <- tryCatch(
      {
        renv::install(x, type = "source", rebuild = TRUE, prompt = FALSE)
        TRUE  # success
      },
      error = function(e) {
        message("❌ Failed to install: ", x)
        message("   Error: ", e$message)
        e  # return the error object
      }
    )
    
    if (!is.logical(result)) {
      # Store the failed package and its error
      failed[[x]] <- result$message
    }
  }
  
  # Report failures
  if (length(failed) > 0) {
    message("\nThe following packages failed to install:")
    print(failed)
  } else {
    message("\nAll packages installed successfully!")
  }
  
  # Return named list: package_name = error_message
  return(failed)
}

# -----------------------------
# Example usage:
# -----------------------------
# Reinstall a package and its dependencies
failed_pkgs <- renv_reinstall("shiny")

# Retry failed packages only (after fixing system dependencies)
if (length(failed_pkgs) > 0) {
  failed_pkgs_retry <- renv_reinstall(names(failed_pkgs))
}
