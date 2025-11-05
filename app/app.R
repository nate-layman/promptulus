library(shiny)
library(shinyjs)
library(bslib)
library(ellmer)
library(here)

ui <- page_sidebar(
  useShinyjs(),

  tags$head(
    tags$style(HTML("
      body {
        background-color: #f5f5f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
    h3("About Promptulus"),
    p("Promptulus reviews your LLM prompts and helps you improve them."),
    p("Type your prompt in the text box, click Send, and the owl will:"),
    tags$ul(
      tags$li("Rate your prompt with 1-5 stars"),
      tags$li("Provide constructive feedback"),
      tags$li("Suggest improvements based on proven prompt engineering principles")
    ),
    p("Your prompt stays in the text box so you can iterate and refine it based on the suggestions."),
    position = "right",
    width = "40%",
    open = "closed"
  ),

  div(class = "top-section",
    div(class = "owl-container",
      imageOutput("owl_image", height = "300px")
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

  # Initialize reactive value for owl's response
  owl_text <- reactiveVal("Hello! I'm Promptulus. Give me your prompt and I'll review it!")

  # Render the owl image from www folder
  output$owl_image <- renderImage({
    list(src = "app/www/owl.png",
         width = "225px",
         alt = "Owl")
  }, deleteFile = FALSE)
  
  # Update owl's response when send button is clicked
  observeEvent(input$send_btn, {
    if (nchar(trimws(input$user_input)) > 0) {
      user_prompt <- input$user_input

      # Show loading message
      owl_text("Analyzing your prompt...")

      # Call OpenAI API using ellmer
      tryCatch({
        cat("[LOG] Send button clicked\n")

        api_key <- Sys.getenv("OPENAI_API_KEY")

        if (api_key == "") {
          cat("[LOG] ERROR: OPENAI_API_KEY not set\n")
          owl_text("Error: OPENAI_API_KEY not set in .env file")
          return()
        }

        cat("[LOG] API key found\n")

        # Read the prompting guidelines
        cat("[LOG] Reading prompting guidelines from app/prompting_guidelines.md\n")
        guidelines <- readLines(here::here("app/prompting_guidelines.md"), warn = FALSE)
        guidelines_text <- paste(guidelines, collapse = "\n")
        cat(paste0("[LOG] Guidelines loaded, length: ", nchar(guidelines_text), " characters\n"))

        # Create system prompt for grading
        system_prompt <- paste0("You are Promptulus, an owl prompt engineering coach! You're a wise, encouraging expert who helps users improve their prompts by teaching them to think like a prompt engineer. You speak with personality and warmth, like a real mentor owl.

IMPORTANT RULES:
- DO NOT rewrite or suggest exact rewrites of the user's prompt
- DO provide constructive feedback and suggestions for HOW they could improve it
- ALWAYS reference specific principles from the guidelines when making suggestions
- Explain WHY each principle matters

Here are the prompt engineering principles to reference:

", guidelines_text, "

For each prompt submitted, provide:
1. A rating from 1-5 stars using star emojis (*)
2. What works well in the prompt
3. Specific suggestions for improvement - reference which principles apply and explain why

RESPONSE FORMAT - START EXACTLY LIKE THIS:
I give this prompt [X] stars

Then provide:
- What works: [brief explanation]
- Suggestions: [numbered list of improvements with principle references]")

        cat(paste0("[LOG] System prompt created, length: ", nchar(system_prompt), " characters\n"))
        cat(paste0("[LOG] User prompt length: ", nchar(user_prompt), " characters\n"))

        # Call OpenAI
        cat("[LOG] Calling chat_openai with model gpt-4-turbo\n")
        response <- chat_openai(
          model = "gpt-4-turbo",
          system = system_prompt,
          messages = list(
            list(role = "user", content = paste0("Please review this prompt:\n\n", user_prompt))
          ),
          api_key = api_key
        )

        cat("[LOG] API response received\n")
        cat(paste0("[LOG] Response class: ", class(response), "\n"))

        # Update the owl's response with the grading
        cat("[LOG] Extracting message from response\n")
        owl_text(response$message)
        cat("[LOG] Response displayed successfully\n")

      }, error = function(e) {
        cat(paste0("[LOG] ERROR: ", conditionMessage(e), "\n"))
        cat(paste0("[LOG] Error traceback:\n"))
        cat(paste0(traceback(), "\n"))
        owl_text(paste0("Error analyzing prompt: ", conditionMessage(e)))
      })
    }
  })
  
  # Render owl's response
  output$owl_response <- renderUI({
    HTML(owl_text())
  })
}

shinyApp(ui = ui, server = server)
