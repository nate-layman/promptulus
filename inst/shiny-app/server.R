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
    api_key <- Sys.getenv("OPENAI_API_KEY")
    is_valid_key <- api_key != "" && !grepl("^sk-test", api_key) && !grepl("^sk-your", api_key)

    if (is_valid_key) {
      session_state$api_key_valid <- TRUE
      showNotification("✓ API key configured and ready!", type = "message", duration = 3)
    } else {
      session_state$api_key_valid <- TRUE  # Allow demo mode
      showNotification(
        "🎮 Running in DEMO MODE - Click 'Ask the Genie' to see example responses!",
        type = "warning",
        duration = NULL
      )
    }
  })

  # Handle prompt submission
  observeEvent(input$submit_prompt, {
    prompt <- trimws(input$user_prompt)

    if (nchar(prompt) == 0) {
      showNotification("Please enter a prompt first!", type = "warning")
      return()
    }


    session_state$current_prompt <- prompt

    # Show loading states
    shinyjs::show("genie_loading")
    shinyjs::hide("genie_content")
    shinyjs::show("coach_loading")
    shinyjs::hide("coach_content")

    # Call Genie
    tryCatch({
      session_state$genie_response <- call_genie(prompt)

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

      shinyjs::hide("genie_loading")
      shinyjs::show("genie_content")
    }, error = function(e) {
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
    tryCatch({
      session_state$coach_response <- call_coach(prompt, session_state$genie_response)

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

      shinyjs::hide("coach_loading")
      shinyjs::show("coach_content")
    }, error = function(e) {
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
