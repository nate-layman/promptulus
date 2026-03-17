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

# ===== CHARACTER CONFIGURATION =====
# Defined at top level so both UI and server can access it.
# Characters are ordered: Before AI → During AI → After AI
character_config <- list(
  # --- BEFORE AI (Planning) ---
  dichotra = list(
    name = "Dichotra",
    display_name = "Dichotra (When to Use AI)",
    image = "squirrel.png",
    gear = "squirrel_gear.png",
    gear_class = "dichotra-gear",
    greeting = "Hello! I am Dichotra. Describe your task and I'll help you figure out whether it needs a transparent, auditable approach — or whether AI can take the lead. Click the arrow to my right for more information.",
    principles_file = "task_categorization_principles.md",
    system_prompt_file = "dichotra_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Dichotra",
    sidebar_description = HTML(
      "<p>Dichotra helps you determine whether <strong>transparency and auditability</strong> matter for your task.</p>
      <p>The key question: <em>Does anyone need to see how the work got done?</em></p>
      <p>Think of it like the difference between a simple formula in a spreadsheet (transparent, auditable) and a black box that just gives you an answer (powerful, but opaque).</p>
      <p>Type your task description, click Send, and the squirrel will:</p>
      <ul>
        <li>Place your task on the transparency spectrum</li>
        <li>Classify it as Process Critical, Human-in-the-Loop, or Output-Driven</li>
        <li>Explain what that means for AI use</li>
      </ul>
      <p>Your task stays in the text box so you can refine and resubmit.</p>"
    ),
    active = TRUE,
    phase = "before",
    skill_label = "Should I use AI?",
    skill_description = "Some tasks need a clear paper trail — others just need a good answer. Knowing the difference keeps you out of trouble."
  ),
  modulus = list(
    name = "Modulus",
    display_name = "Modulus (Task Decomposition)",
    image = "crab.png",
    gear = "crab_gear.png",
    gear_class = "modulus-gear",
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
    ),
    active = TRUE,
    phase = "before",
    skill_label = "How do I break this down?",
    skill_description = "Complex tasks overwhelm AI. Breaking them into steps gets better results and lets you catch errors early."
  ),
  # --- DURING AI (Context Window Disciplines) ---
  telosa = list(
    name = "Telosa",
    display_name = "Telosa (Intent Engineering)",
    image = "turtle.png",
    gear = "turtle_gear.png",
    gear_class = "telosa-gear",
    greeting = "Hello. I am Telosa. Your intent takes up space in the AI's context window — make it count. Tell me about your task and I'll help you clarify your goals, boundaries, and what happens if things don't go as planned. Click the arrow to my right for more information.",
    principles_file = "intent_engineering_principles.md",
    system_prompt_file = "telosa_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Telosa",
    sidebar_description = HTML(
      "<p>Telosa helps you define your <strong>intent</strong> before you start working with AI.</p>
      <p>The most important prompt engineering happens before anyone writes a prompt.</p>
      <p>Type your task description, click Send, and the turtle will help you clarify:</p>
      <ul>
        <li>What are you actually trying to accomplish?</li>
        <li>Who is accountable for the result?</li>
        <li>What are the escape hatches if AI fails?</li>
        <li>What boundaries should AI respect?</li>
      </ul>
      <p>Refine your intent and resubmit — the clearer your purpose, the better your results.</p>"
    ),
    active = TRUE,
    phase = "during",
    skill_label = "What's my intent?",
    skill_description = "Intent: Without clear intent, AI may take shortcuts you never intended — including unsafe ones. Define the goal and the guardrails."
  ),
  promptulus = list(
    name = "Promptulus",
    display_name = "Promptulus (Prompt Engineering)",
    image = "owl.png",
    gear = "owl_gear.png",
    gear_class = NULL,
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
    ),
    active = TRUE,
    phase = "during",
    skill_label = "How do I ask?",
    skill_description = "Instructions: How you phrase a request dramatically changes what you get back. Small wording changes yield big differences."
  ),
  mnemos = list(
    name = "Mnemos",
    display_name = "Mnemos (Context Engineering)",
    image = "elephant.png",
    gear = NULL,
    gear_class = NULL,
    greeting = "Hello! I am Mnemos. I help you decide what information to provide to the AI — and just as importantly, what to leave out. Click the arrow to my right for more information.",
    principles_file = NULL,
    system_prompt_file = NULL,
    rating_icon = "none",
    sidebar_title = "About Mnemos",
    sidebar_description = HTML(
      "<p>Mnemos helps you manage <strong>what information</strong> the AI can see.</p>
      <p><em>Coming soon!</em></p>"
    ),
    active = FALSE,
    phase = "during",
    skill_label = "What does the AI need to know?",
    skill_description = "Information: Don't rely on the model's general knowledge — give it the specific context it needs. But don't overwhelm it with everything either. Curate what matters."
  ),
  dialogos = list(
    name = "Dialogos",
    display_name = "Dialogos (Conversation Management)",
    image = "parrot.png",
    gear = NULL,
    gear_class = NULL,
    greeting = "Hello! I am Dialogos. I help you manage the back-and-forth with AI — when to continue, when to start fresh, and how to keep the conversation productive. Click the arrow to my right for more information.",
    principles_file = NULL,
    system_prompt_file = NULL,
    rating_icon = "none",
    sidebar_title = "About Dialogos",
    sidebar_description = HTML(
      "<p>Dialogos teaches you to manage <strong>multi-turn conversations</strong> with AI.</p>
      <p><em>Coming soon!</em></p>"
    ),
    active = FALSE,
    phase = "during",
    skill_label = "How do I manage the conversation?",
    skill_description = "Interaction: Every exchange shapes what the model remembers. Knowing when to continue, reset, or restructure keeps your AI sharp instead of confused."
  ),
  # --- AFTER AI (Quality) ---
  veridex = list(
    name = "Veridex",
    display_name = "Veridex (Evaluation)",
    image = "raccoon.png",
    gear = NULL,
    gear_class = NULL,
    greeting = "Hello! I am Veridex. I help you evaluate whether AI output is accurate, reproducible, and trustworthy. Click the arrow to my right for more information.",
    principles_file = NULL,
    system_prompt_file = NULL,
    rating_icon = "none",
    sidebar_title = "About Veridex",
    sidebar_description = HTML(
      "<p>Veridex helps you <strong>evaluate</strong> AI output for accuracy and quality.</p>
      <p><em>Coming soon!</em></p>"
    ),
    active = FALSE,
    phase = "after",
    skill_label = "Is the output good?",
    skill_description = "AI can sound confident and still be wrong. Systematic evaluation catches errors before they become someone else's problem."
  ),
  lucerna = list(
    name = "Lucerna",
    display_name = "Lucerna (Reporting)",
    image = NULL,
    gear = NULL,
    gear_class = NULL,
    greeting = "Hello! I am Lucerna. I help you document and explain your AI-assisted work so others can understand and reproduce it. Click the arrow to my right for more information.",
    principles_file = NULL,
    system_prompt_file = NULL,
    rating_icon = "none",
    sidebar_title = "About Lucerna",
    sidebar_description = HTML(
      "<p>Lucerna helps you <strong>document and report</strong> your AI methodology.</p>
      <p><em>Coming soon!</em></p>"
    ),
    active = FALSE,
    phase = "after",
    skill_label = "Can I explain what I did?",
    skill_description = "If you can't explain how you got here, you're not done yet. Transparent reporting builds trust and lets others reproduce your work."
  )
)

active_characters <- names(character_config)[sapply(character_config, function(x) x$active)]

# ===== SPECTRUM VISUALIZATION =====
spectrum_html <- function(zone) {
  positions <- list(
    process_critical = "15%",
    human_in_the_loop = "50%",
    output_driven = "85%"
  )
  pos <- positions[[zone]]
  if (is.null(pos)) return("")

  paste0(
    '<div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">',
    '<div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 5px; font-weight: bold;">',
    '<span>&larr; Transparency</span><span>Flexibility &rarr;</span></div>',
    '<div style="position: relative; height: 30px; background: linear-gradient(to right, #e74c3c, #f39c12, #27ae60); border-radius: 15px;">',
    '<div style="position: absolute; left: ', pos, '; top: -5px; transform: translateX(-50%); ',
    'width: 20px; height: 40px; background: white; border: 3px solid #333; border-radius: 50%;"></div>',
    '</div>',
    '<div style="display: flex; justify-content: space-between; font-size: 11px; margin-top: 5px; color: #666;">',
    '<span>Process Critical</span><span>Human-in-the-Loop</span><span>Output-Driven</span></div>',
    '</div>'
  )
}

# ===== UI =====
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

      /* ===== LOADING GEAR ===== */
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

      .loading-gear.telosa-gear {
        top: 39%;
        left: 39%;
        width: 58px;
        height: 58px;
        margin-left: -29px;
        margin-top: -29px;
      }

      .loading-gear.telosa-gear img {
        width: 58px;
        height: 58px;
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

      /* ===== CHARACTER VIEW ===== */
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

      .giscus-section {
        padding: 20px;
        margin-top: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }

      .giscus-section h3 {
        margin-top: 0;
        margin-bottom: 15px;
      }

      /* ===== CHARACTER NAV ===== */
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

      .home-icon, #home_btn {
        width: 35px;
        height: 35px;
        cursor: pointer;
        border-radius: 50%;
        transition: all 0.3s ease;
        opacity: 0.6;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        color: #666;
        border: 2px solid #ddd;
        background: white;
      }

      .home-icon:hover {
        opacity: 1;
        border-color: #2196F3;
        color: #2196F3;
      }

      .nav-separator {
        height: 1px;
        background: #ddd;
        margin: 2px 0;
      }

      .character-icon.inactive {
        opacity: 0.3;
        cursor: default;
        filter: grayscale(80%);
      }

      .character-icon.inactive:hover {
        opacity: 0.3;
        transform: none;
      }

      /* ===== Y/N BUTTONS (reserved for future use) ===== */
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

      /* ===== LANDING PAGE ===== */
      .landing-container {
        max-width: 900px;
        margin: 0 auto;
        padding: 20px;
      }

      .landing-header {
        text-align: center;
        margin-bottom: 30px;
      }

      .landing-mascot {
        max-width: 150px;
        margin-bottom: 15px;
      }

      .landing-header h1 {
        margin: 0 0 10px 0;
        color: #04354a;
        font-size: 28px;
      }

      .landing-subtitle {
        font-size: 18px;
        color: #555;
        margin-bottom: 15px;
        font-style: italic;
      }

      .landing-intro {
        font-size: 14px;
        color: #666;
        line-height: 1.6;
        max-width: 700px;
        margin: 0 auto;
      }

      .phase-section {
        margin-bottom: 25px;
      }

      .phase-title {
        font-size: 16px;
        font-weight: bold;
        color: #04354a;
        margin-bottom: 4px;
        padding-bottom: 5px;
        border-bottom: 2px solid #ddd;
      }

      .phase-description {
        font-size: 13px;
        color: #666;
        margin: 0 0 12px 0;
        line-height: 1.5;
      }

      .character-cards {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        justify-content: center;
      }

      .character-card {
        background: white;
        border-radius: 10px;
        padding: 15px;
        width: 140px;
        text-align: center;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        cursor: pointer;
        transition: all 0.3s ease;
        border: 2px solid transparent;
      }

      .character-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        border-color: #2196F3;
      }

      .character-card.coming-soon {
        opacity: 0.5;
        cursor: default;
      }

      .character-card.coming-soon:hover {
        transform: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border-color: transparent;
      }

      .character-card img {
        width: 70px;
        height: 70px;
        object-fit: contain;
        margin-bottom: 8px;
      }

      .character-card h4 {
        margin: 0 0 4px 0;
        font-size: 14px;
        color: #04354a;
      }

      .character-card p {
        margin: 0;
        font-size: 12px;
        color: #666;
      }

      .character-card .card-skill {
        font-weight: bold;
        color: #04354a;
        margin-bottom: 4px;
      }

      .character-card .card-description {
        font-size: 11px;
        line-height: 1.4;
        color: #888;
      }

      .api-key-section {
        background: white;
        border-radius: 10px;
        padding: 15px 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }

      .api-key-section h4 {
        margin: 0 0 8px 0;
        color: #04354a;
      }

      .api-key-section p {
        margin: 0 0 8px 0;
        font-size: 14px;
        color: #555;
      }

      .api-key-input-row {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .api-key-input-row .form-group {
        flex: 1;
        margin-bottom: 0;
      }

      .api-key-status {
        font-size: 13px;
        white-space: nowrap;
      }

      .api-key-help {
        font-size: 12px !important;
        color: #888 !important;
        margin-top: 4px !important;
      }

      .api-key-help a {
        color: #2196F3;
      }

      .landing-disclaimer {
        margin-top: 30px;
        padding: 15px 20px;
        background: #fff8e1;
        border-left: 4px solid #f9a825;
        border-radius: 4px;
        font-size: 13px;
        color: #5d4037;
        line-height: 1.5;
      }

      .character-card .coming-soon-badge {
        font-size: 10px;
        color: #999;
        font-style: italic;
        margin-top: 4px;
      }

      .placeholder-img {
        width: 70px;
        height: 70px;
        background: #e0e0e0;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 8px auto;
        font-size: 24px;
        color: #999;
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

  # ===== LANDING PAGE =====
  div(id = "landing_view",
    div(class = "landing-container",
      div(class = "landing-header",
        tags$img(src = "octopus.png", class = "landing-mascot"),
        h1("The AI Literacy Companions"),
        p(class = "landing-subtitle",
          "Hello! I'm Octavius. Using AI well isn't just about writing a good prompt — it's a whole workflow.",
          " Knowing when to use AI, what to tell it, and how to check its work are all different skills.",
          " My 8 companions each teach one — click any character below to get started!"
        )
      ),

      # API Key input
      div(class = "api-key-section",
        h4("Getting Started"),
        p("The interactive characters use Google's Gemini API. Enter your API key below to get started."),
        div(class = "api-key-input-row",
          passwordInput("api_key_input", label = NULL, placeholder = "Paste your Gemini API key here..."),
          uiOutput("api_key_status")
        ),
        p(class = "api-key-help",
          "Don't have a key? ",
          tags$a(href = "https://aistudio.google.com/apikey",
                 target = "_blank",
                 "Click here for instructions on getting a free Gemini API key"),
          "."
        )
      ),

      # Before AI
      div(class = "phase-section",
        div(class = "phase-title", "Before AI — Planning"),
        p(class = "phase-description", "Before you touch an AI tool, make sure you know whether you should be using one — and how to break the work into manageable pieces."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "before")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image) else div(class = "placeholder-img", "?"),
              h4(cfg$name),
              p(class = "card-skill", cfg$skill_label),
              p(class = "card-description", cfg$skill_description),
              if (!cfg$active) div(class = "coming-soon-badge", "Coming soon")
            )
          })
        )
      ),

      # During AI
      div(class = "phase-section",
        div(class = "phase-title", "During AI — Intent, Instructions, Information, Interaction"),
        p(class = "phase-description", "Intent, instructions, information, and interaction all compete for the model's attention. Getting the balance right between these four is what separates useful AI output from noise."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "during")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image) else div(class = "placeholder-img", "?"),
              h4(cfg$name),
              p(class = "card-skill", cfg$skill_label),
              p(class = "card-description", cfg$skill_description),
              if (!cfg$active) div(class = "coming-soon-badge", "Coming soon")
            )
          })
        )
      ),

      # After AI
      div(class = "phase-section",
        div(class = "phase-title", "After AI — Quality & Reporting"),
        p(class = "phase-description", "AI can sound confident and still be wrong. These skills help you verify what it produced and document how you got there."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "after")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image) else div(class = "placeholder-img", "?"),
              h4(cfg$name),
              p(class = "card-skill", cfg$skill_label),
              p(class = "card-description", cfg$skill_description),
              if (!cfg$active) div(class = "coming-soon-badge", "Coming soon")
            )
          })
        )
      ),

    )
  ),

  # ===== CHARACTER VIEW (hidden initially) =====
  div(id = "character_view", style = "display: none;",
    div(class = "top-section",
      # Character navigation icons
      div(class = "character-nav",
        # Home button (octopus)
        tags$img(
          src = "octopus.png",
          class = "character-icon",
          id = "home_btn",
          style = "opacity: 0.7;",
          onclick = "Shiny.setInputValue('go_home', Math.random(), {priority: 'event'})"
        ),
        div(class = "nav-separator"),
        # All character icons
        lapply(names(character_config), function(char_id) {
          cfg <- character_config[[char_id]]
          if (is.null(cfg$image)) return(NULL)
          icon_class <- if (cfg$active) "character-icon" else "character-icon inactive"
          onclick_js <- if (cfg$active) {
            paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
          } else {
            ""
          }
          tags$img(
            src = cfg$image,
            class = icon_class,
            id = paste0("icon_", char_id),
            onclick = onclick_js
          )
        })
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
    ),

    # Giscus discussion - dynamically loaded per character
    div(class = "giscus-section",
      h3("Discussion"),
      div(id = "giscus-container")
    )
  )
)

# ===== SERVER =====
server <- function(input, output, session) {

  # Show disclaimer modal on page load
  showModal(modalDialog(
    title = "Welcome to the AI Literacy Companions",
    p("This project is designed to teach you how to",
      tags$em("think about"), "using AI. Each character highlights an important",
      "discipline in the AI workflow."),
    p("The advice from any individual character is educational — it should not be used to make",
      "definitive judgments about specific tasks. Always consult your institution's policies and",
      "use professional judgment."),
    footer = actionButton("dismiss_disclaimer", "I understand", class = "btn-primary"),
    easyClose = FALSE
  ))

  observeEvent(input$dismiss_disclaimer, {
    removeModal()
  })

  # Reactive values
  owl_text <- reactiveVal("")
  previous_principle <- reactiveVal("None")
  selected_character <- reactiveVal(NULL)
  app_view <- reactiveVal("landing")


  # ===== NAVIGATION =====

  # Home button handler
  observeEvent(input$go_home, {
    app_view("landing")
    selected_character(NULL)
    owl_text("")
    previous_principle("None")
    shinyjs::show("landing_view")
    shinyjs::hide("character_view")
  })

  # Character selection handler
  observeEvent(input$char_select, {
    char <- input$char_select
    if (!(char %in% active_characters)) return()

    config <- character_config[[char]]

    # Switch to character view
    app_view("character")
    selected_character(char)
    shinyjs::hide("landing_view")
    shinyjs::show("character_view")

    # Update greeting text
    owl_text(config$greeting)

    # Reset state
    previous_principle("None")

    # Update active icon styling
    for (cid in names(character_config)) {
      shinyjs::removeClass(id = paste0("icon_", cid), class = "active")
    }
    shinyjs::addClass(id = paste0("icon_", char), class = "active")

    # Adjust gear position based on character
    for (cid in active_characters) {
      gc <- character_config[[cid]]$gear_class
      if (!is.null(gc)) {
        shinyjs::removeClass(id = "loading_gear", class = gc)
      }
    }
    if (!is.null(config$gear_class)) {
      shinyjs::addClass(id = "loading_gear", class = config$gear_class)
    }

    # Inject giscus script dynamically for the selected character
    shinyjs::runjs(paste0("
      var container = document.getElementById('giscus-container');
      container.innerHTML = '';
      var script = document.createElement('script');
      script.src = 'https://giscus.app/client.js';
      script.setAttribute('data-repo', 'nate-layman/promptulus');
      script.setAttribute('data-repo-id', 'R_kgDOQPUupA');
      script.setAttribute('data-category', 'Character Discussions');
      script.setAttribute('data-category-id', 'DIC_kwDOQPUupM4CxtCy');
      script.setAttribute('data-mapping', 'specific');
      script.setAttribute('data-term', '", char, "-discussion');
      script.setAttribute('data-strict', '0');
      script.setAttribute('data-reactions-enabled', '1');
      script.setAttribute('data-emit-metadata', '0');
      script.setAttribute('data-input-position', 'bottom');
      script.setAttribute('data-theme', 'preferred_color_scheme');
      script.setAttribute('data-lang', 'en');
      script.setAttribute('crossorigin', 'anonymous');
      script.async = true;
      container.appendChild(script);
    "))
  })

  # ===== RENDER UI ELEMENTS =====

  output$character_image <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    tags$img(src = config$image, class = "owl-image", alt = config$name)
  })

  output$character_gear <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    if (!is.null(config$gear)) {
      tags$img(src = config$gear)
    }
  })

  output$sidebar_title <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    h3(config$sidebar_title)
  })

  output$sidebar_description <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    config$sidebar_description
  })

  output$owl_response <- renderUI({
    response_text <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", owl_text())
    response_text <- gsub("\n", "<br>", response_text)
    HTML(response_text)
  })

  # API key status indicator
  output$api_key_status <- renderUI({
    key <- input$api_key_input
    env_key <- Sys.getenv("GEMINI_API_KEY")
    if (!is.null(key) && nchar(trimws(key)) > 0) {
      span(class = "api-key-status", style = "color: #4CAF50;", icon("check-circle"), " Key entered")
    } else if (nchar(env_key) > 0) {
      span(class = "api-key-status", style = "color: #2196F3;", icon("info-circle"), " Using server key")
    } else {
      span(class = "api-key-status", style = "color: #f44336;", icon("times-circle"), " No key")
    }
  })

  # ===== SEND BUTTON HANDLER =====
  observeEvent(input$send_btn, {
    req(selected_character())
    if (nchar(trimws(input$user_input)) > 0) {
      user_prompt <- input$user_input

      # Show loading gear
      shinyjs::addClass(id = "loading_gear", class = "fa-spin")

      # Call Google Gemini API using ellmer
      tryCatch({
        cat("[LOG] Send button clicked\n")

        # Prefer user-provided key, fall back to environment variable
        user_key <- input$api_key_input
        api_key <- if (!is.null(user_key) && nchar(trimws(user_key)) > 0) {
          trimws(user_key)
        } else {
          Sys.getenv("GEMINI_API_KEY")
        }

        if (api_key == "") {
          cat("[LOG] ERROR: No API key available\n")
          owl_text("Please enter your Gemini API key on the landing page (click the octopus to go back).")
          shinyjs::removeClass(id = "loading_gear", class = "fa-spin")
          return()
        }

        config <- character_config[[selected_character()]]
        cat(paste0("[LOG] Using character: ", config$name, "\n"))

        # Read the principles file for the selected character
        guidelines <- readLines(here::here(config$principles_file), warn = FALSE)
        guidelines_text <- paste(guidelines, collapse = "\n")

        # Read the system prompt template
        system_prompt_template <- readLines(here::here(config$system_prompt_file), warn = FALSE)
        system_prompt_text <- paste(system_prompt_template, collapse = "\n")

        # Replace placeholders
        system_prompt <- gsub("\\{\\{GUIDELINES\\}\\}", guidelines_text, system_prompt_text)
        prev_principle <- previous_principle()
        system_prompt <- gsub("\\{\\{PREVIOUS_PRINCIPLE\\}\\}", prev_principle, system_prompt)

        cat(paste0("[LOG] System prompt created, length: ", nchar(system_prompt), " characters\n"))

        # Call LLM
        chat_obj <- chat(
          name = "google_gemini/gemini-2.5-flash",
          system_prompt = system_prompt,
          api_key = api_key,
          echo = "none"
        )

        response <- chat_obj$chat(paste0("Please review this prompt:\n\n", user_prompt))

        cat("[LOG] API response received\n")
        cat(paste0("[LOG] Response length: ", nchar(response), " characters\n"))

        # For Dichotra: parse zone and append spectrum visualization
        if (selected_character() == "dichotra") {
          zone_match <- regmatches(response, regexpr("\\[ZONE: (process_critical|human_in_the_loop|output_driven)\\]", response))
          zone <- NULL
          if (length(zone_match) > 0) {
            zone <- gsub("\\[ZONE: |\\]", "", zone_match[1])
            response <- gsub("\\s*\\[ZONE: [^]]+\\]\\s*", "", response)
          }
          owl_text(paste0(response, if (!is.null(zone)) spectrum_html(zone) else ""))
        } else {
          owl_text(response)
        }

        # Extract principle name to avoid repetition
        principle_match <- regmatches(response, regexpr("consider using the \\*\\*([^*]+)\\*\\*", response))
        if (length(principle_match) > 0) {
          principle_name <- gsub(".*\\*\\*([^*]+)\\*\\*.*", "\\1", principle_match[1])
          previous_principle(principle_name)
          cat(paste0("[LOG] Extracted principle: ", principle_name, "\n"))
        }

        # Also try extracting from Dichotra/Telosa format: "Based on the **Principle Name** principle"
        if (length(principle_match) == 0) {
          alt_match <- regmatches(response, regexpr("Based on the \\*\\*([^*]+)\\*\\*", response))
          if (length(alt_match) > 0) {
            principle_name <- gsub(".*\\*\\*([^*]+)\\*\\*.*", "\\1", alt_match[1])
            previous_principle(principle_name)
            cat(paste0("[LOG] Extracted principle (alt): ", principle_name, "\n"))
          }
        }

        shinyjs::removeClass(id = "loading_gear", class = "fa-spin")

      }, error = function(e) {
        cat(paste0("[LOG] ERROR: ", conditionMessage(e), "\n"))
        owl_text(paste0("Error analyzing prompt: ", conditionMessage(e)))
        shinyjs::removeClass(id = "loading_gear", class = "fa-spin")
      })
    }
  })

  # ===== GUIDELINES SIDEBAR =====
  output$guidelines_content <- renderUI({
    req(selected_character())
    tryCatch({
      config <- character_config[[selected_character()]]
      req(config$principles_file)
      guidelines_path <- here::here(config$principles_file)
      guidelines_lines <- readLines(guidelines_path, warn = FALSE)
      guidelines_text <- paste(guidelines_lines, collapse = "\n")

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
