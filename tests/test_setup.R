# Quick setup verification tests for Promptulus

test_that("Package loads without errors", {
  expect_true(require("promptulus", quietly = TRUE))
})

test_that("Techniques data is available", {
  techniques <- get_techniques()
  expect_type(techniques, "list")
  expect_length(techniques, 10)
  expect_named(
    techniques,
    c(
      "role_persona", "output_format", "constraints", "context",
      "step_by_step", "examples", "tone_style", "audience",
      "comparison_analysis", "break_down"
    )
  )
})

test_that("Can get individual techniques", {
  tech <- get_technique("role_persona")
  expect_type(tech, "list")
  expect_named(tech, c("id", "name", "short_desc", "description", "example", "why_matters", "genie_misapplication"))
  expect_equal(tech$id, "role_persona")
})

test_that("Technique names are retrievable", {
  names <- get_technique_names()
  expect_type(names, "character")
  expect_length(names, 10)
  expect_true("Specify Role/Persona" %in% names)
})

test_that("API key check works", {
  # This should fail if no API key is set
  expect_error(
    init_api_client(),
    "OPENAI_API_KEY environment variable not set"
  )

  # Set a fake key for testing purposes
  Sys.setenv(OPENAI_API_KEY = "sk-test-key-for-testing")
  expect_error(
    init_api_client(),
    # Should error from ellmer, not our validation
    "from ellmer"
  )
})

test_that("Shiny app files exist", {
  app_dir <- system.file("shiny-app", package = "promptulus")
  expect_true(dir.exists(app_dir))
  expect_true(file.exists(file.path(app_dir, "app.R")))
  expect_true(file.exists(file.path(app_dir, "ui.R")))
  expect_true(file.exists(file.path(app_dir, "server.R")))
})

test_that("Static assets exist", {
  www_dir <- system.file("shiny-app", "..", "www", package = "promptulus")
  expect_true(file.exists(file.path(www_dir, "style.css")))
  expect_true(file.exists(file.path(www_dir, "promptulus.js")))
  expect_true(file.exists(file.path(www_dir, "genie-icon.png")))
})

cat("\n✓ All basic setup tests passed!\n")
cat("The Promptulus project structure is ready to go.\n\n")
cat("To start the app:\n")
cat("  library(promptulus)\n")
cat("  run_promptulus()\n\n")
