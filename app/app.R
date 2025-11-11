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

      .bslib-sidebar-layout {
        --bslib-sidebar-width: 50% !important;
      }

      .sidebar-header {
        position: relative;
        margin-bottom: 15px;
      }

      .sidebar-header h3 {
        margin: 0;
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

      .loading-gear.modulus-gear {
        top: 54%;
        left: 50.5%;
      }

      .loading-gear.dichotra-gear {
        left: 35%;
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
        overflow-x: auto;
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

      .character-nav {
        display: flex;
        flex-direction: column;
        gap: 10px;
        justify-content: center;
        margin-right: 15px;
      }

      .character-icon {
        width: 35px;
        height: 35px;
        cursor: pointer;
        border-radius: 50%;
        transition: all 0.3s ease;
        opacity: 0.5;
        border: 2px solid transparent;
      }

      .character-icon:hover {
        opacity: 0.8;
        transform: scale(1.05);
      }

      .character-icon.active {
        opacity: 1;
        border: 2px solid #2196F3;
        box-shadow: 0 0 8px rgba(33, 150, 243, 0.4);
      }

      .yn-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 15px;
      }

      .yn-button {
        padding: 10px 30px;
        font-size: 16px;
        border: 2px solid #ddd;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        background-color: white;
      }

      .yn-button:hover {
        border-color: #2196F3;
        background-color: #e3f2fd;
      }

      .yn-button.yes-btn {
        color: #4CAF50;
        border-color: #4CAF50;
      }

      .yn-button.yes-btn:hover {
        background-color: #e8f5e9;
        border-color: #45a049;
      }

      .yn-button.no-btn {
        color: #f44336;
        border-color: #f44336;
      }

      .yn-button.no-btn:hover {
        background-color: #ffebee;
        border-color: #d32f2f;
      }
    "))
  ),

  sidebar = sidebar(
    div(style = "height: 100%; overflow-y: auto; overflow-x: auto;",
      div(class = "sidebar-header",
        uiOutput("sidebar_title")
      ),
      uiOutput("sidebar_description"),
      hr(),
      uiOutput("guidelines_content")
    ),
    position = "right",
    width = "50%",
    open = "closed"
  ),

  div(class = "top-section",
    # Character navigation icons
    div(class = "character-nav",
      tags$img(src = "owl.png",
               class = "character-icon active",
               id = "icon_promptulus",
               onclick = "Shiny.setInputValue('char_select', 'promptulus', {priority: 'event'})"),
      tags$img(src = "crab.png",
               class = "character-icon",
               id = "icon_modulus",
               onclick = "Shiny.setInputValue('char_select', 'modulus', {priority: 'event'})"),
      tags$img(src = "squirrel.png",
               class = "character-icon",
               id = "icon_dichotra",
               onclick = "Shiny.setInputValue('char_select', 'dichotra', {priority: 'event'})")
    ),
    div(class = "owl-container",
      uiOutput("character_image"),
      div(class = "loading-gear", id = "loading_gear",
        uiOutput("character_gear")
      )
    ),
    div(class = "speech-bubble-container",
      div(class = "speech-bubble",
        div(class = "bubble-text",
          uiOutput("owl_response")
        ),
        uiOutput("yn_buttons_ui")
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

  # Character configuration
  character_config <- list(
    promptulus = list(
      name = "Promptulus",
      display_name = "Promptulus (Clarity/Structure)",
      image = "owl.png",
      gear = "owl_gear.png",
      greeting = "Hello! I am Promptulus. Give me your prompt and I'll review it! You can also click the arrow to my right for more information.",
      principles_file = "prompting_principles.md",
      system_prompt_file = "promptulus_system_prompt.md",
      rating_icon = "mice",
      sidebar_title = "About Promptulus",
      sidebar_description = HTML(
        "<p>Promptulus reviews your LLM prompts and helps you improve them.</p>
        <p>Type your prompt in the text box, click Send, and the owl will:</p>
        <ul>
          <li>Rate your prompt with 1-5 mice</li>
          <li>Provide constructive feedback</li>
          <li>Suggest improvements based on proven prompt engineering principles</li>
        </ul>
        <p>Your prompt stays in the text box so you can iterate and refine it based on the suggestions.</p>"
      )
    ),
    modulus = list(
      name = "Modulus",
      display_name = "Modulus (Workflow/Complexity)",
      image = "crab.png",
      gear = "crab_gear.png",
      greeting = "Hello! I am Modulus. Show me your complex prompt and I'll help you break it into manageable, modular pieces! You can also click the arrow to my right for more information.",
      principles_file = "modularization_principles.md",
      system_prompt_file = "modulus_system_prompt.md",
      rating_icon = "shrimp",
      sidebar_title = "About Modulus",
      sidebar_description = HTML(
        "<p>Modulus helps you break down complex prompts into modular workflows.</p>
        <p>Type your prompt in the text box, click Send, and the crab will:</p>
        <ul>
          <li>Rate your prompt with 1-5 shrimp (5 = perfect discrete chunk, 1 = too complex)</li>
          <li>Identify where complexity emerges</li>
          <li>Suggest how to modularize your task into manageable steps</li>
        </ul>
        <p>Your prompt stays in the text box so you can iterate and refine it based on the suggestions.</p>"
      )
    ),
    dichotra = list(
      name = "Dichotra",
      display_name = "Dichotra (Task Classification)",
      image = "squirrel.png",
      gear = "squirrel_gear.png",
      greeting = "Hello! I am Dichotra. Describe your task and I'll help you determine if it's best solved with an LLM, traditional data science, or a hybrid approach! You can also click the arrow to my right for more information.",
      principles_file = "task_categorization_principles.md",
      system_prompt_file = "dichotra_system_prompt.md",
      rating_icon = "none",
      sidebar_title = "About Dichotra",
      sidebar_description = HTML(
        "<p>Dichotra helps you classify your task and choose the right approach.</p>
        <p>Type your task description in the text box, click Send, and the squirrel will:</p>
        <ul>
          <li>Classify your task as LLM, Data Science, or Hybrid</li>
          <li>Explain why a particular approach fits best</li>
          <li>Recommend Promptulus for LLM tasks</li>
        </ul>
        <p>Your task stays in the text box so you can refine and resubmit.</p>"
      )
    )
  )

  # Initialize reactive values
  owl_text <- reactiveVal("Hello! I am Promptulus. Give me your prompt and I'll review it! You can also click the arrow to my right for more information.")
  previous_principle <- reactiveVal("None")
  selected_character <- reactiveVal("promptulus")

  # Dichotra-specific state
  dichotra_mode <- reactiveVal(NULL)  # "ai" or "dichotomous_key"
  dichotra_question_id <- reactiveVal(NULL)
  dichotra_user_task <- reactiveVal(NULL)
  show_yn_buttons <- reactiveVal(FALSE)

  # Dichotomous key decision tree (simplified)
  decision_tree <- list(
    Q1 = list(
      question = "Is your primary output text, ideas, summaries, or creative content?",
      yes = "Q2",
      no = "Q3"
    ),
    Q2 = list(
      question = "Do you need to process or analyze structured/tabular data first?",
      yes = "HYBRID",
      no = "LLM"
    ),
    Q3 = list(
      question = "Does your task involve making predictions, classifications, or calculations from data?",
      yes = "Q4",
      no = "Q5"
    ),
    Q4 = list(
      question = "Will you need to explain or narrate the results in natural language?",
      yes = "HYBRID",
      no = "DATA_SCIENCE"
    ),
    Q5 = list(
      question = "Does your task require understanding context, ambiguity, or subjective interpretation?",
      yes = "LLM",
      no = "SIMPLE"
    ),
    LLM = list(
      outcome = "Your task is best suited for an **LLM approach**! It involves language understanding, content generation, or nuanced interpretation. Visit Promptulus the Owl for guidance on crafting effective prompts for your task."
    ),
    DATA_SCIENCE = list(
      outcome = "Your task is a classic **data science problem**! Focus on traditional ML, statistical analysis, or data processing approaches. LLMs aren't needed here."
    ),
    HYBRID = list(
      outcome = "Your task needs a **hybrid approach**! Combine data science for analytical rigor with an LLM for communication or interpretation. Consider visiting Promptulus for the narrative portion."
    ),
    SIMPLE = list(
      outcome = "Your task might not need AI or data science at all! Consider whether simple rules, heuristics, or deterministic logic would work. If you do need AI, describe your task more specifically for better guidance."
    )
  )

  # Character switching logic
  observeEvent(input$char_select, {
    char <- input$char_select
    selected_character(char)
    config <- character_config[[char]]

    # Update greeting text
    owl_text(config$greeting)

    # Reset previous principle when switching characters
    previous_principle("None")

    # Reset Dichotra state when switching characters
    show_yn_buttons(FALSE)
    dichotra_mode(NULL)
    dichotra_question_id(NULL)

    # Update active icon styling
    shinyjs::removeClass(id = "icon_promptulus", class = "active")
    shinyjs::removeClass(id = "icon_modulus", class = "active")
    shinyjs::removeClass(id = "icon_dichotra", class = "active")
    shinyjs::addClass(id = paste0("icon_", char), class = "active")

    # Adjust gear position based on character
    shinyjs::removeClass(id = "loading_gear", class = "modulus-gear")
    shinyjs::removeClass(id = "loading_gear", class = "dichotra-gear")

    if (char == "modulus") {
      shinyjs::addClass(id = "loading_gear", class = "modulus-gear")
    } else if (char == "dichotra") {
      shinyjs::addClass(id = "loading_gear", class = "dichotra-gear")
    }
  })

  # Render dynamic character image
  output$character_image <- renderUI({
    config <- character_config[[selected_character()]]
    tags$img(src = config$image, class = "owl-image", alt = config$name)
  })

  # Render dynamic character gear
  output$character_gear <- renderUI({
    config <- character_config[[selected_character()]]
    tags$img(src = config$gear)
  })

  # Render dynamic sidebar title
  output$sidebar_title <- renderUI({
    config <- character_config[[selected_character()]]
    h3(config$sidebar_title)
  })

  # Render dynamic sidebar description
  output$sidebar_description <- renderUI({
    config <- character_config[[selected_character()]]
    config$sidebar_description
  })

  # Render Y/N buttons for dichotomous key
  output$yn_buttons_ui <- renderUI({
    if (show_yn_buttons()) {
      div(class = "yn-buttons",
        actionButton("yes_btn", "Yes", class = "yn-button yes-btn"),
        actionButton("no_btn", "No", class = "yn-button no-btn")
      )
    }
  })

  # Update owl's response when send button is clicked
  observeEvent(input$send_btn, {
    if (nchar(trimws(input$user_input)) > 0) {
      user_prompt <- input$user_input

      # Show loading gear
      shinyjs::addClass(id = "loading_gear", class = "fa-spin")

      # Special handling for Dichotra: randomly choose method
      if (selected_character() == "dichotra") {
        # Randomly choose between AI method and dichotomous key
        chosen_method <- sample(c("ai", "dichotomous_key"), 1)
        dichotra_mode(chosen_method)
        dichotra_user_task(user_prompt)

        cat(paste0("[LOG] Dichotra chose method: ", chosen_method, "\n"))

        if (chosen_method == "dichotomous_key") {
          # Start dichotomous key flow
          dichotra_question_id("Q1")
          current_node <- decision_tree[[dichotra_question_id()]]

          # Display first question
          owl_text(current_node$question)
          show_yn_buttons(TRUE)
          shinyjs::removeClass(id = "loading_gear", class = "fa-spin")
          return()
        }
        # If AI method, continue with normal flow below
      }

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

        # Get the current character configuration
        config <- character_config[[selected_character()]]
        cat(paste0("[LOG] Using character: ", config$name, "\n"))

        # Read the principles file for the selected character
        cat(paste0("[LOG] Reading principles from ", config$principles_file, "\n"))
        guidelines <- readLines(here::here(config$principles_file), warn = FALSE)
        guidelines_text <- paste(guidelines, collapse = "\n")
        cat(paste0("[LOG] Guidelines loaded, length: ", nchar(guidelines_text), " characters\n"))

        # Read the system prompt template for the selected character
        cat(paste0("[LOG] Reading system prompt from ", config$system_prompt_file, "\n"))
        system_prompt_template <- readLines(here::here(config$system_prompt_file), warn = FALSE)
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

        # For Dichotra AI method, append meta-question
        if (selected_character() == "dichotra" && dichotra_mode() == "ai") {
          response_with_meta <- paste0(
            response,
            "<br><br>I hope that was helpful! By the way, <strong>I don't use the same method every time.</strong> Which method do you think I used to classify your task this time?"
          )
          owl_text(response_with_meta)
          dichotra_mode(NULL)  # Reset mode
        } else {
          owl_text(response)
        }

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

  # Handle Yes button for dichotomous key
  observeEvent(input$yes_btn, {
    if (!is.null(dichotra_question_id())) {
      current_node <- decision_tree[[dichotra_question_id()]]
      next_id <- current_node$yes

      # Navigate to next node
      dichotra_question_id(next_id)
      next_node <- decision_tree[[next_id]]

      if (!is.null(next_node$outcome)) {
        # Reached an outcome - display it with meta-question
        final_text <- paste0(
          next_node$outcome,
"<br><br>I hope that was helpful! By the way, <strong>I don't use the same method every time.</strong> Which method do you think I used to classify your task this time?"        )
        owl_text(final_text)
        show_yn_buttons(FALSE)

        # Reset Dichotra state
        dichotra_mode(NULL)
        dichotra_question_id(NULL)
      } else {
        # Continue with next question
        owl_text(next_node$question)
      }
    }
  })

  # Handle No button for dichotomous key
  observeEvent(input$no_btn, {
    if (!is.null(dichotra_question_id())) {
      current_node <- decision_tree[[dichotra_question_id()]]
      next_id <- current_node$no

      # Navigate to next node
      dichotra_question_id(next_id)
      next_node <- decision_tree[[next_id]]

      if (!is.null(next_node$outcome)) {
        # Reached an outcome - display it with meta-question
        final_text <- paste0(
          next_node$outcome,
          "<br><br>I hope that was helpful! By the way, <strong>I don't use the same method every time.</strong> Which method do you think I used to classify your task this time?"        )
        owl_text(final_text)
        show_yn_buttons(FALSE)

        # Reset Dichotra state
        dichotra_mode(NULL)
        dichotra_question_id(NULL)
      } else {
        # Continue with next question
        owl_text(next_node$question)
      }
    }
  })

  # Render guidelines content
  output$guidelines_content <- renderUI({
    tryCatch({
      # Read the guidelines markdown file for the selected character
      config <- character_config[[selected_character()]]
      guidelines_path <- here::here(config$principles_file)
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
