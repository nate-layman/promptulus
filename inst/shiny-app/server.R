library(shiny)
library(shinyjs)

# Load app utilities
source("app-utils.R")

server <- function(input, output, session) {

  # Session state
  session_state <- reactiveValues(
    current_prompt = "",
    genie_response = NULL,
    coach_response = NULL,
    api_key_valid = FALSE,
    history = list()
  )

  # Check API key on startup
  observe({
    cat("\n🚀 ════════════════════════════════════════════════════════════\n")
    cat("📱 Promptulus App Initialized\n")
    cat("════════════════════════════════════════════════════════════\n\n")

    api_key <- Sys.getenv("OPENAI_API_KEY")
    cat("🔑 Checking API key...\n")

    is_valid_key <- api_key != "" && !grepl("^sk-test", api_key) && !grepl("^sk-your", api_key)

    if (is_valid_key) {
      session_state$api_key_valid <- TRUE
      cat("✅ Valid OpenAI API key found\n")
      cat("🤖 Using LIVE MODE - Real GPT-4 responses\n\n")
      showNotification("✓ API key configured and ready!", type = "message", duration = 3)
    } else {
      session_state$api_key_valid <- TRUE  # Allow demo mode
      cat("ℹ️  No valid API key detected\n")
      cat("🎮 Using DEMO MODE - Example responses\n")
      cat("📌 To use live API: Set OPENAI_API_KEY in .env file\n\n")
      showNotification(
        "🎮 Running in DEMO MODE - Click 'Ask the Genie' to see example responses!",
        type = "warning",
        duration = NULL
      )
    }
  })

  # Handle prompt submission
  observeEvent(input$submit_prompt, {
    cat("\n✨ ════════════════════════════════════════════════════════════\n")
    cat("🧞 BUTTON CLICKED - Starting Promptulus workflow\n")
    cat("════════════════════════════════════════════════════════════\n\n")

    prompt <- trimws(input$user_prompt)
    cat("📝 User prompt received:\n")
    cat("   ", prompt, "\n\n")

    if (nchar(prompt) == 0) {
      cat("⚠️  ERROR: Prompt is empty!\n\n")
      showNotification("Please enter a prompt first!", type = "warning")
      return()
    }

    session_state$current_prompt <- prompt

    # Show loading states
    cat("⏳ Showing loading indicators...\n\n")
    shinyjs::show("genie_loading")
    shinyjs::hide("genie_content")
    shinyjs::show("coach_loading")
    shinyjs::hide("coach_content")

    # Call Genie
    cat("🧞 Calling Genie model...\n")
    tryCatch({
      session_state$genie_response <- call_genie(prompt)

      cat("✅ Genie response received:\n")
      cat("   ", substring(session_state$genie_response, 1, 100), "...\n\n")

      output$genie_response <- renderUI({
        div(
          class = "card border-primary",
          div(
            class = "card-header bg-primary text-white",
            h5("🧞 Promptulus the Genie Says:")
          ),
          div(
            class = "card-body",
            p(session_state$genie_response, class = "card-text")
          )
        )
      })

      cat("✅ Genie response rendered in UI\n\n")
      shinyjs::hide("genie_loading")
      shinyjs::show("genie_content")
    }, error = function(e) {
      cat("❌ ERROR from Genie:\n")
      cat("   ", e$message, "\n\n")
      output$genie_response <- renderUI({
        div(
          class = "alert alert-danger",
          h5("Error from Genie"),
          p(e$message)
        )
      })
      shinyjs::hide("genie_loading")
      shinyjs::show("genie_content")
    })

    # Call Coach
    cat("📚 Calling Coach model...\n")
    tryCatch({
      session_state$coach_response <- call_coach(prompt, session_state$genie_response)

      cat("✅ Coach response received:\n")
      cat("   ", substring(session_state$coach_response, 1, 100), "...\n\n")

      output$coach_response <- renderUI({
        div(
          class = "card border-success",
          div(
            class = "card-header bg-success text-white",
            h5("📚 Prompt Coach Feedback:")
          ),
          div(
            class = "card-body",
            HTML(markdown_to_html(session_state$coach_response))
          )
        )
      })

      cat("✅ Coach response rendered in UI\n\n")
      shinyjs::hide("coach_loading")
      shinyjs::show("coach_content")
    }, error = function(e) {
      cat("❌ ERROR from Coach:\n")
      cat("   ", e$message, "\n\n")
      output$coach_response <- renderUI({
        div(
          class = "alert alert-danger",
          h5("Error from Coach"),
          p(e$message)
        )
      })
      shinyjs::hide("coach_loading")
      shinyjs::show("coach_content")
    })

    # Add to history
    session_state$history[[length(session_state$history) + 1]] <- list(
      prompt = prompt,
      genie_response = session_state$genie_response,
      coach_response = session_state$coach_response,
      timestamp = Sys.time()
    )
  })

  # Render techniques panel
  output$techniques_panel <- renderUI({
    techniques <- get_techniques()

    technique_cards <- lapply(names(techniques), function(id) {
      tech <- techniques[[id]]
      div(
        class = "card mb-3 border-primary",
        div(
          class = "card-header bg-primary text-white",
          h5(tech$name)
        ),
        div(
          class = "card-body",
          p(
            strong("What it is:"), " ", tech$description,
            class = "mb-2"
          ),
          p(
            strong("Why it matters:"), " ", tech$why_matters,
            class = "mb-2"
          ),
          p(
            strong("Example:"), " ", em(tech$example),
            class = "mb-2"
          ),
          p(
            strong("Genie's trick:"), " ", tech$genie_misapplication,
            class = "text-muted small"
          )
        )
      )
    })

    div(
      h2("10 Core Prompting Techniques"),
      p("Here are all the techniques Promptulus teaches. Learn what they do and why they matter!"),
      div(
        class = "row",
        lapply(technique_cards, function(card) {
          div(class = "col-md-6", card)
        })
      )
    )
  })
}
