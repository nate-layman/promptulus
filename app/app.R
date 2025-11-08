library(shiny)
library(shinyjs)
library(bslib)
library(ellmer)
library(here)

# Load environment variables from .Renviron file
# Check multiple possible locations
env_file_paths <- c(
  ".Renviron",           # Running from  directory (shinyapps.io)
  "../.env",             # Running from project root (local dev with .env)
  here::here(".env")     # Using here package to find .env
)

for (path in env_file_paths) {
  if (file.exists(path)) {
    readRenviron(path)
    break
  }
}

ui <- page_sidebar(
  useShinyjs(),

  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"),
    tags$style(HTML("
      body {
        background-color: #f5f5f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }

      .loading-gear {
        position: absolute;
        top: 12%;
        left: 50%;
        margin-left: -25px;
        margin-top: -25px;
        width: 50px;
        height: 50px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transform-origin: 50% 50%;
        color: #04354a;
        pointer-events: none;
      }

      @keyframes gear-spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
      }

      .loading-gear img {
        width: 50px;
        height: 50px;
      }

      .loading-gear.fa-spin img {
        animation: gear-spin 15s linear infinite;
      }

      .top-section {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 20px;
        margin-bottom: 30px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      
      .owl-container {
        position: relative;
        flex: 0 0 225px;
        height: 300px;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .owl-image {
        max-width: 225px;
        max-height: 300px;
        height: auto;
      }
      
      .speech-bubble-container {
        flex: 1;
        margin-left: 30px;
        height: 300px;
        display: flex;
      }

      .speech-bubble {
        position: relative;
        background: #e3f2fd;
        border-radius: 15px;
        padding: 20px;
        flex: 1;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      }
      
      .speech-bubble:before {
        content: '';
        position: absolute;
        left: -20px;
        top: 20px;
        width: 0;
        height: 0;
        border-style: solid;
        border-width: 10px 20px 10px 0;
        border-color: transparent #e3f2fd transparent transparent;
      }
      
      .bubble-text {
        font-size: 16px;
        color: #333;
        line-height: 1.6;
      }
      
      .input-section {
        padding: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      
      .user-input {
        width: 100%;
        padding: 15px;
        font-size: 16px;
        border: 2px solid #ddd;
        border-radius: 8px;
        box-sizing: border-box;
        resize: vertical;
      }
      
      .user-input:focus {
        outline: none;
        border-color: #2196F3;
      }
      
      .send-button {
        margin-top: 10px;
        padding: 12px 30px;
        font-size: 16px;
        background-color: #2196F3;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s;
      }
      
      .send-button:hover {
        background-color: #1976D2;
      }
      
      .placeholder-text {
        color: #999;
        font-style: italic;
      }
    "))
  ),
  
  sidebar = sidebar(
    div(style = "height: 100%; overflow-y: auto;",
      h3("About Promptulus"),
      p("Promptulus reviews your LLM prompts and helps you improve them."),
      p("Type your prompt in the text box, click Send, and the owl will:"),
      tags$ul(
        tags$li("Rate your prompt with 1-5 mice"),
        tags$li("Provide constructive feedback"),
        tags$li("Suggest improvements based on proven prompt engineering principles")
      ),
      p("Your prompt stays in the text box so you can iterate and refine it based on the suggestions."),
      hr(),
      uiOutput("guidelines_content")
    ),
    position = "right",
    width = "40%",
    open = "closed"
  ),

  div(class = "top-section",
    div(class = "owl-container",
      tags$img(src = "owl.png", class = "owl-image", alt = "Owl"),
      div(class = "loading-gear", id = "loading_gear",
        tags$img(src = "gear.png")
      )
    ),
    div(class = "speech-bubble-container",
      div(class = "speech-bubble",
        div(class = "bubble-text",
          uiOutput("owl_response")
        )
      )
    )
  ),

  div(class = "input-section",
    textAreaInput("user_input",
                  label = NULL,
                  placeholder = "Type your message here...",
                  width = "100%",
                  rows = 3),
    actionButton("send_btn", "Send", class = "send-button")
  )
)

server <- function(input, output, session) {

  # Initialize reactive values
  owl_text <- reactiveVal("Hello! I am Promptulus. Give me your prompt and I'll review it! You can also click the arrow to my right for more information.")
  previous_principle <- reactiveVal("None")

  # Update owl's response when send button is clicked
  observeEvent(input$send_btn, {
    if (nchar(trimws(input$user_input)) > 0) {
      user_prompt <- input$user_input

      # Show loading gear
      shinyjs::addClass(id = "loading_gear", class = "fa-spin")

      # Call Google Gemini API using ellmer
      tryCatch({
        cat("[LOG] Send button clicked\n")

        api_key <- Sys.getenv("GEMINI_API_KEY")

        if (api_key == "") {
          cat("[LOG] ERROR: GEMINI_API_KEY not set\n")
          owl_text("Error: GEMINI_API_KEY not set in .env file")
          shinyjs::removeClass(id = "loading_gear", class = "fa-spin")
          return()
        }

        cat("[LOG] API key found\n")

        # Read the prompting guidelines
        cat("[LOG] Reading prompting guidelines from prompting_principles.md\n")
        guidelines <- readLines(here::here("prompting_principles.md"), warn = FALSE)
        guidelines_text <- paste(guidelines, collapse = "\n")
        cat(paste0("[LOG] Guidelines loaded, length: ", nchar(guidelines_text), " characters\n"))

        # Read the system prompt template
        cat("[LOG] Reading system prompt from promptulus_system_prompt.md\n")
        system_prompt_template <- readLines(here::here("promptulus_system_prompt.md"), warn = FALSE)
        system_prompt_text <- paste(system_prompt_template, collapse = "\n")

        # Replace the {{GUIDELINES}} placeholder with actual guidelines
        system_prompt <- gsub("\\{\\{GUIDELINES\\}\\}", guidelines_text, system_prompt_text)

        # Replace the {{PREVIOUS_PRINCIPLE}} placeholder with the previous principle (or "None" on first call)
        prev_principle <- previous_principle()
        system_prompt <- gsub("\\{\\{PREVIOUS_PRINCIPLE\\}\\}", prev_principle, system_prompt)

        cat(paste0("[LOG] System prompt created, length: ", nchar(system_prompt), " characters\n"))
        cat(paste0("[LOG] Previous principle: ", prev_principle, "\n"))
        cat(paste0("[LOG] User prompt length: ", nchar(user_prompt), " characters\n"))

        # Call LLM using ellmer's chat() function
        cat("[LOG] Creating chat object with system prompt\n")
        chat_obj <- chat(
          name = "google_gemini/gemini-2.5-flash",
          system_prompt = system_prompt,
          api_key = api_key,
          echo = "none"
        )

        cat("[LOG] Calling chat with user prompt\n")
        response <- chat_obj$chat(paste0("Please review this prompt:\n\n", user_prompt))

        cat("[LOG] API response received\n")
        cat(paste0("[LOG] Response class: ", class(response), "\n"))
        cat(paste0("[LOG] Response length: ", nchar(response), " characters\n"))
        cat("[LOG] RAW RESPONSE FROM MODEL:\n")
        cat(response)
        cat("\n[LOG] END RAW RESPONSE\n")

        # Update the owl's response with the grading
        cat("[LOG] Displaying response\n")
        owl_text(response)

        # Extract the principle name from the response to avoid recommending it next time
        # Pattern: "consider using the **Principle Name** principle"
        principle_match <- regmatches(response, regexpr("consider using the \\*\\*([^*]+)\\*\\*", response))
        if (length(principle_match) > 0) {
          # Extract just the principle name between the asterisks
          principle_name <- gsub(".*\\*\\*([^*]+)\\*\\*.*", "\\1", principle_match[1])
          previous_principle(principle_name)
          cat(paste0("[LOG] Extracted principle: ", principle_name, "\n"))
        } else {
          cat("[LOG] Could not extract principle from response\n")
        }

        cat("[LOG] Response displayed successfully\n")
        shinyjs::removeClass(id = "loading_gear", class = "fa-spin")

      }, error = function(e) {
        cat(paste0("[LOG] ERROR: ", conditionMessage(e), "\n"))
        cat(paste0("[LOG] Error traceback:\n"))
        cat(paste0(traceback(), "\n"))
        owl_text(paste0("Error analyzing prompt: ", conditionMessage(e)))
        shinyjs::removeClass(id = "loading_gear", class = "fa-spin")
      })
    }
  })
  
  # Render owl's response
  output$owl_response <- renderUI({
    # Convert markdown bold (**text**) to HTML (<strong>text</strong>)
    response_text <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", owl_text())
    # Convert newline characters to <br> tags
    response_text <- gsub("\n", "<br>", response_text)
    HTML(response_text)
  })

  # Render guidelines content
  output$guidelines_content <- renderUI({
    tryCatch({
      # Read the guidelines markdown file
      guidelines_path <- here::here("prompting_principles.md")
      guidelines_lines <- readLines(guidelines_path, warn = FALSE)
      guidelines_text <- paste(guidelines_lines, collapse = "\n")

      # Convert markdown table to HTML with styling
      html_content <- paste0(
        "<style>
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-bottom: 20px;
          }
          th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            vertical-align: top;
          }
          th {
            background-color: #f5f5f5;
            font-weight: bold;
          }
          tr:nth-child(even) {
            background-color: #fafafa;
          }
          strong {
            color: #04354a;
          }
        </style>",
        markdown::markdownToHTML(text = guidelines_text, fragment.only = TRUE)
      )

      HTML(html_content)
    }, error = function(e) {
      HTML(paste0("<p style='color: red;'>Error loading guidelines: ", conditionMessage(e), "</p>"))
    })
  })
}

shinyApp(ui = ui, server = server)
