library(shiny)
library(bslib)
library(shinyjs)

ui <- page_navbar(
  title = div(
    img(src = "genie-icon.png", height = "40px", style = "margin-right: 10px;"),
    "Promptulus: AI Prompting Learning Game",
    style = "display: flex; align-items: center;"
  ),
  theme = bs_theme(
    preset = "darkly",
    primary = "#7c3aed",
    secondary = "#06b6d4",
    success = "#10b981",
    info = "#3b82f6",
    warning = "#f59e0b",
    danger = "#ef4444",
    base_font = font_google("Inter"),
    heading_font = font_google("Poppins")
  ),

  # Include custom CSS and JavaScript
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$script(src = "promptulus.js")
  ),

  # Initialize shinyjs
  shinyjs::useShinyjs(),

  nav_panel(
    title = "🎮 Learn to Prompt",
    layout_sidebar(
      sidebar = sidebar(
        h3("✍️ Your Prompt"),
        textAreaInput(
          "user_prompt",
          label = NULL,
          placeholder = "Write a prompt you'd like to improve. Example: 'Write a story about a robot'",
          rows = 6,
          width = "100%"
        ),
        br(),
        actionButton(
          "submit_prompt",
          label = "🧞 Ask the Genie",
          class = "btn-primary btn-lg",
          width = "100%"
        ),
        br(), br(),
        hr(),
        p(
          "💡 Tip: Start with a simple prompt and watch how the Genie playfully ",
          "misinterprets it. Then use the Coach's feedback to improve it!",
          class = "text-muted small"
        ),
      ),
      main = navset_card_tab(
        title = "Feedback",
        nav_panel(
          title = "🧞 Genie's Misinterpretation",
          div(
            id = "genie_container",
            div(
              id = "genie_loading",
              class = "text-center py-5",
              style = "display: none;",
              p("🧞 The Genie is conjuring a response...", class = "text-muted")
            ),
            div(
              id = "genie_content",
              uiOutput("genie_response")
            )
          )
        ),
        nav_panel(
          title = "📚 Coach Feedback",
          div(
            id = "coach_container",
            div(
              id = "coach_loading",
              class = "text-center py-5",
              style = "display: none;",
              p("📚 The Coach is preparing feedback...", class = "text-muted")
            ),
            div(
              id = "coach_content",
              uiOutput("coach_response")
            )
          )
        ),
        nav_panel(
          title = "📖 Learn Techniques",
          uiOutput("techniques_panel")
        )
      )
    )
  ),

  nav_panel(
    title = "🧠 About",
    layout_sidebar(
      sidebar = sidebar(
        h4("Quick Links"),
        p(
          a("View on GitHub", href = "https://github.com/your-repo", target = "_blank", class = "btn btn-outline-secondary btn-sm w-100"),
          style = "margin-bottom: 0.5rem;"
        ),
        p(
          a("Report an Issue", href = "https://github.com/your-repo/issues", target = "_blank", class = "btn btn-outline-secondary btn-sm w-100"),
          style = "margin-bottom: 1rem;"
        ),
        hr(),
        h5("About Promptulus"),
        p("Promptulus teaches you to write better AI prompts through playful interaction and constructive coaching.")
      ),
      main = page_fill(
        card(
          h2("What is Promptulus?"),
          p(
            "Promptulus is an interactive learning game that helps you master the art of AI prompting. ",
            "Instead of just reading about techniques, you learn by doing."
          ),
          h3("How It Works"),
          tags$ol(
            tags$li("You write a prompt for an AI task"),
            tags$li("The Genie intentionally misinterprets it (showing what happens when you skip techniques)"),
            tags$li("The Coach gives you constructive feedback and explains what technique could help"),
            tags$li("You refine your prompt and try again"),
            tags$li("Learn through iteration!")
          ),
          h3("Why Prompting Matters"),
          p(
            "Good prompting is the difference between getting generic answers and getting exactly what you need. ",
            "The 10 techniques taught here are used by expert prompt engineers worldwide."
          )
        )
      )
    )
  ),

  footer = tags$footer(
    class = "text-center text-muted py-4",
    p("🧞 Promptulus v0.1.0 | Learn. Iterate. Improve. 📚", class = "small")
  )
)
