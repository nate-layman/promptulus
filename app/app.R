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
  sequita = list(
    name = "Sequita",
    display_name = "Sequita (When to Use AI)",
    image = "squirrel.png",
    gear = "squirrel_gear.png",
    gear_class = "sequita-gear",
    input_placeholder = "Describe a task you're considering using AI for...",
    greeting = "Hello! I am Sequita. Tell me what you're working on and I'll teach you about transparency. Does your task need a clear paper trail, or is a good answer all that matters? Click the arrow to my right for more information.",
    principles_file = "task_categorization_principles.md",
    system_prompt_file = "sequita_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Sequita",
    sidebar_description = HTML(
      "<p>Sequita helps you determine whether <strong>transparency</strong> matters for your task.</p>
      <p>The key question: <em>Do you need to understand the cause, or just the effect?</em></p>
      <p>Think of it like forecasting: sometimes you need to know <em>why</em> a prediction was right: what assumptions were made, whether the reasoning holds for new situations. Other times you just need an accurate forecast and the inner workings don't matter.</p>
      <p>Type your task description, click Send, and the squirrel will:</p>
      <ul>
        <li>Assess whether your task needs high or low transparency</li>
        <li>Explain what that means for choosing tools and methods</li>
      </ul>
      <p>Describe different tasks to explore how transparency needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "before",
    skill_label = "Should I use AI?",
    skill_description = "Transparency: Some tasks need a clear paper trail; others just need a good answer. Knowing the difference keeps you out of trouble.",
    name_origin = "From Latin 'sequi' (to follow/trace), tracing the reasoning behind a result"
  ),
  modulus = list(
    name = "Modulus",
    display_name = "Modulus (Task Decomposition)",
    image = "crab.png",
    gear = "crab_gear.png",
    gear_class = "modulus-gear",
    input_placeholder = "Paste a complex prompt or describe a multi-step task...",
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
    skill_description = "Decomposition: Complex tasks overwhelm AI. Breaking them into steps gets better results and lets you catch errors early.",
    name_origin = "From Latin 'modulus' (small measure), breaking big problems into measured pieces"
  ),
  # --- DURING AI (Context Window Disciplines) ---
  telosa = list(
    name = "Telosa",
    display_name = "Telosa (Intent Engineering)",
    image = "turtle.png",
    gear = "turtle_gear.png",
    gear_class = "telosa-gear",
    input_placeholder = "What are you trying to accomplish with AI? Describe your goal...",
    greeting = "Hello. I am Telosa. Tell me what you're working on and I'll help you think through your intent: what you actually need, who's accountable, and what happens if things don't go as planned. Click the arrow to my right for more information.",
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
      <p>Describe different tasks to explore how intent needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "during",
    skill_label = "What's my intent?",
    skill_description = "Intent: Without clear intent, AI may take shortcuts you never intended, including unsafe ones. Define the goal and the guardrails.",
    name_origin = "From Greek 'telos' (\u03c4\u03ad\u03bb\u03bf\u03c2), meaning purpose, end, goal"
  ),
  promptulus = list(
    name = "Promptulus",
    display_name = "Promptulus (Prompt Engineering)",
    image = "owl.png",
    gear = "owl_gear.png",
    gear_class = NULL,
    input_placeholder = "Paste a prompt you'd like reviewed...",
    greeting = "Hello! I am Promptulus. Give me your prompt and I'll review it! You can also click the arrow to my right for more information.",
    principles_file = "prompting_principles.md",
    system_prompt_file = "promptulus_system_prompt.md",
    rating_icon = "mice",
    sidebar_title = "About Promptulus",
    sidebar_description = HTML(
      "<p>Promptulus reviews your LLM prompts and helps you improve them.</p>
      <p>Type your prompt in the text box, click Send, and the owl will:</p>
      <ul>
        <li>Rate your prompt (1-5 mice, where 5 is excellent)</li>
        <li>Provide constructive feedback</li>
        <li>Suggest improvements based on proven prompt engineering principles</li>
      </ul>
      <p>Your prompt stays in the text box so you can iterate and refine it based on the suggestions.</p>"
    ),
    active = TRUE,
    phase = "during",
    skill_label = "How do I ask?",
    skill_description = "Instructions: How you phrase a request dramatically changes what you get back. Small wording changes yield big differences.",
    name_origin = "From Latin 'promptus' (ready, prepared), preparing effective requests"
  ),
  mnemos = list(
    name = "Mnemos",
    display_name = "Mnemos (Context Engineering)",
    image = "elephant.png",
    gear = NULL,
    gear_class = NULL,
    input_placeholder = "Describe your task and what documents or data you plan to give the AI...",
    greeting = "Hello! I am Mnemos. Tell me what you're working on and I'll help you think about what information the AI needs, and just as importantly, what to leave out. Click the arrow to my right for more information.",
    principles_file = "context_engineering_principles.md",
    system_prompt_file = "mnemos_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Mnemos",
    sidebar_description = HTML(
      "<p>Mnemos helps you manage <strong>what information</strong> the AI can see.</p>
      <p>The key insight: AI's context window is like a desk with limited space. Everything you include competes for attention.</p>
      <p>Type your task description, click Send, and the elephant will help you think about:</p>
      <ul>
        <li>What information the AI needs that it doesn't already know</li>
        <li>How to organize and prioritize your context</li>
        <li>What to leave out to keep the AI focused</li>
      </ul>
      <p>Describe different tasks to explore how context needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "during",
    skill_label = "What does the AI need to know?",
    skill_description = "Information: Don't rely on the model's general knowledge. Give it the specific context it needs. But don't overwhelm it with everything either. Curate what matters.",
    name_origin = "From Greek 'mneme' (\u03bc\u03bd\u03ae\u03bc\u03b7), meaning memory. The elephant never forgets."
  ),
  dialogos = list(
    name = "Dialogos",
    display_name = "Dialogos (Conversation Management)",
    image = "parrot.png",
    gear = NULL,
    gear_class = NULL,
    input_placeholder = "Describe your task and how you plan to interact with the AI (single prompt? back-and-forth?)...",
    greeting = "Hello! I am Dialogos. Tell me what you're working on and I'll help you think about managing the back-and-forth: when to continue, when to start fresh, and how to keep the conversation productive. Click the arrow to my right for more information.",
    principles_file = "conversation_management_principles.md",
    system_prompt_file = "dialogos_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Dialogos",
    sidebar_description = HTML(
      "<p>Dialogos teaches you to manage <strong>multi-turn conversations</strong> with AI.</p>
      <p>The key insight: every message stays in the AI's memory, and old instructions compete with new ones.</p>
      <p>Type your task description, click Send, and the parrot will help you think about:</p>
      <ul>
        <li>Whether to continue a conversation or start fresh</li>
        <li>How to manage instruction drift and contradictions</li>
        <li>When single-turn vs multi-turn works best</li>
      </ul>
      <p>Describe different tasks to explore how conversation needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "during",
    skill_label = "How do I manage the conversation?",
    skill_description = "Interaction: Every exchange shapes what the model remembers. Knowing when to continue, reset, or restructure keeps your AI sharp instead of confused.",
    name_origin = "From Greek 'dialogos' (\u03b4\u03b9\u03ac\u03bb\u03bf\u03b3\u03bf\u03c2), meaning conversation, dialogue"
  ),
  # --- AFTER AI (Quality) ---
  veridex = list(
    name = "Veridex",
    display_name = "Veridex (Evaluation)",
    image = "raccoon.png",
    gear = NULL,
    gear_class = NULL,
    input_placeholder = "Tell me what you're working on or what AI produced for you...",
    greeting = "Hello! I am Veridex. Tell me what you're working on and I'll teach you what can go wrong with AI output, and how to catch it. Trust but verify! Click the arrow to my right for more information.",
    principles_file = "evaluation_principles.md",
    system_prompt_file = "veridex_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Veridex",
    sidebar_description = HTML(
      "<p>Veridex helps you <strong>evaluate</strong> AI output for accuracy and quality.</p>
      <p>The key insight: AI can sound confident and still be completely wrong.</p>
      <p>Type your task description, click Send, and the raccoon will help you think about:</p>
      <ul>
        <li>How to verify facts vs just checking fluency</li>
        <li>Where to watch for hallucinations</li>
        <li>How to match evaluation rigor to stakes</li>
      </ul>
      <p>Describe different tasks to explore how evaluation needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "after",
    skill_label = "Is the output good?",
    skill_description = "Evaluation: AI can sound confident and still be wrong. Systematic evaluation catches errors before they become someone else's problem.",
    name_origin = "From Latin 'verus' (true) + 'index' (pointer), pointing to the truth"
  ),
  clarion = list(
    name = "Clarion",
    display_name = "Clarion (Reporting)",
    image = "whale.png",
    gear = NULL,
    gear_class = NULL,
    input_placeholder = "Tell me what you're working on or how you used AI...",
    greeting = "Hello! I am Clarion. Tell me what you're working on and I'll help you think about documenting your AI-assisted work. If you can't explain how you got here well enough for someone to reproduce your work, you're not done yet. Particularly since that someone will probably just end up being you in the future! Click the arrow to my right for more information.",
    principles_file = "reporting_principles.md",
    system_prompt_file = "clarion_system_prompt.md",
    rating_icon = "none",
    sidebar_title = "About Clarion",
    sidebar_description = HTML(
      "<p>Clarion helps you <strong>document and report</strong> your AI methodology.</p>
      <p>The key insight: undocumented work is invisible work. It can't be trusted, improved, or replicated.</p>
      <p>Type your task description, click Send, and the whale will help you think about:</p>
      <ul>
        <li>What to disclose about AI use and when</li>
        <li>How to document prompts, context, and changes</li>
        <li>Matching documentation depth to stakes</li>
      </ul>
      <p>Describe different tasks to explore how documentation needs change across your work.</p>"
    ),
    active = TRUE,
    phase = "after",
    skill_label = "Can I explain what I did?",
    skill_description = "Clarion teaches the white whale of AI skills: documenting what you've done well enough that your work can be reproduced.",
    name_origin = "From Latin 'clarus' (clear) + clarion (a trumpet), broadcasting findings so they can't be missed"
  )
)

active_characters <- names(character_config)[sapply(character_config, function(x) x$active)]

# ===== SPECTRUM VISUALIZATION =====
spectrum_html <- function(zone) {
  positions <- list(
    high = "20%",
    low = "80%"
  )
  pos <- positions[[zone]]
  if (is.null(pos)) return("")

  paste0(
    '<div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">',
    '<div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 5px; font-weight: bold;">',
    '<span>&larr; High Transparency</span><span>Low Transparency &rarr;</span></div>',
    '<div style="position: relative; height: 30px; background: linear-gradient(to right, #e74c3c, #27ae60); border-radius: 15px;">',
    '<div style="position: absolute; left: ', pos, '; top: -5px; transform: translateX(-50%); ',
    'width: 20px; height: 40px; background: white; border: 3px solid #333; border-radius: 50%;"></div>',
    '</div>',
    '<div style="display: flex; justify-content: space-between; font-size: 11px; margin-top: 5px; color: #666;">',
    '<span>Show your work</span><span>Results matter, method doesn\'t</span></div>',
    '</div>'
  )
}

# ===== UI =====
ui <- page_sidebar(
  useShinyjs(),

  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"),
    tags$script(HTML("document.addEventListener('DOMContentLoaded', function() { document.body.classList.add('on-landing'); });")),
    tags$style(HTML("
      body {
        background-color: #f5f5f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }

      .bslib-sidebar-layout {
        --bslib-sidebar-width: 50% !important;
      }
      /* Sidebar toggle - override left positioning only when collapsed */
      .bslib-sidebar-layout > .collapse-toggle {
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10;
        border-radius: 50%;
        background-color: #e8e8e8;
        border: 1px solid #ccc;
      }
      .bslib-sidebar-layout.sidebar-collapsed.sidebar-right > .collapse-toggle {
        left: unset !important;
        right: 15px !important;
      }
      .bslib-sidebar-layout > .collapse-toggle:hover {
        background-color: #ddd;
      }
      .bslib-sidebar-layout > .collapse-toggle .collapse-icon {
        font-size: 24px;
      }
      /* Hide sidebar toggle on landing page */
      body.on-landing .bslib-sidebar-layout > .collapse-toggle {
        display: none;
      }

      .sidebar-header {
        position: relative;
        margin-bottom: 15px;
        margin-top: 40px;
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

      .loading-gear.sequita-gear {
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
      #character_view {
        margin-right: 35px;
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

      .character-column {
        display: flex;
        flex-direction: column;
        align-items: center;
        flex: 0 0 225px;
      }

      .owl-container {
        position: relative;
        width: 225px;
        height: 280px;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .owl-image {
        max-width: 225px;
        max-height: 280px;
        height: auto;
      }

      .character-name-label {
        text-align: center;
        font-weight: bold;
        font-size: 14px;
        color: #04354a;
        margin-top: 4px;
      }

      .speech-bubble-container {
        flex: 1;
        margin-left: 30px;
        min-height: 300px;
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

      .nav-group-label {
        font-size: 9px;
        color: #999;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        text-align: center;
        margin-top: 2px;
        margin-bottom: -4px;
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

      /* ===== CONVERSATION NAVIGATOR (Dialogos only) ===== */
      .conversation-nav {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        padding: 8px 15px;
        margin-top: 10px;
        background: #f0f4f8;
        border-radius: 8px;
        font-size: 13px;
        color: #555;
      }

      .conversation-nav .nav-arrow {
        background: none;
        border: 1px solid #ccc;
        border-radius: 50%;
        width: 28px;
        height: 28px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 14px;
        color: #555;
        transition: all 0.2s ease;
        padding: 0;
        line-height: 1;
      }

      .conversation-nav .nav-arrow:hover:not(:disabled) {
        background: #e3f2fd;
        border-color: #2196F3;
        color: #2196F3;
      }

      .conversation-nav .nav-arrow:disabled {
        opacity: 0.3;
        cursor: default;
      }

      .conversation-nav .nav-label {
        font-weight: 500;
        min-width: 100px;
        text-align: center;
      }

      .conversation-nav .nav-context {
        font-size: 11px;
        color: #888;
        max-width: 300px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .history-viewing-banner {
        font-size: 11px;
        color: #888;
        font-style: italic;
        text-align: center;
        padding: 4px 0;
      }

      .history-user-input {
        background: #f9f9f9;
        border-left: 3px solid #ccc;
        padding: 8px 12px;
        margin-bottom: 10px;
        font-size: 13px;
        color: #666;
        border-radius: 0 6px 6px 0;
        max-height: 60px;
        overflow-y: auto;
      }

      .history-user-input .history-label {
        font-weight: 600;
        font-size: 11px;
        color: #999;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 2px;
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
          "Hello! I'm Octavius. Think of AI like an eager junior employee: brilliant, fast, and desperate to please.",
          " They'll do anything you ask without pushing back, even if your instructions are vague or your request doesn't quite make sense.",
          " They won't tell you when they're guessing, and they'll never say \"I don't know.\"",
          " Using AI well means learning to manage that employee: giving clear direction, providing the right reference materials,",
          " and always checking their work. My 8 companions each teach one of these skills."
        )
      ),

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

      # Deciding to Use AI
      div(class = "phase-section",
        div(class = "phase-title", "Deciding to Use AI"),
        p(class = "phase-description", "Before you get started, make sure you can clearly describe the task you want to do, know how to break it down into manageable subtasks, and whether AI is appropriate for the task at hand."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "before")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image, title = cfg$name_origin) else div(class = "placeholder-img", "?"),
              h4(cfg$name),
              p(class = "card-skill", cfg$skill_label),
              p(class = "card-description", cfg$skill_description),
              if (!cfg$active) div(class = "coming-soon-badge", "Coming soon")
            )
          })
        )
      ),

      # Using AI
      div(class = "phase-section",
        div(class = "phase-title", "Using AI: Intent, Instructions, Information, Interaction"),
        p(class = "phase-description", "Intent, instructions, information, and interaction all compete for the model's attention. Getting the balance right between these four is what separates useful AI output from noise."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "during")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image, title = cfg$name_origin) else div(class = "placeholder-img", "?"),
              h4(cfg$name),
              p(class = "card-skill", cfg$skill_label),
              p(class = "card-description", cfg$skill_description),
              if (!cfg$active) div(class = "coming-soon-badge", "Coming soon")
            )
          })
        )
      ),

      # Understanding AI Outputs
      div(class = "phase-section",
        div(class = "phase-title", "Understanding AI Outputs"),
        p(class = "phase-description", "AI can sound confident and still be wrong. These skills help you verify what it produced and document how you got there."),
        div(class = "character-cards",
          lapply(names(character_config)[sapply(character_config, function(x) x$phase == "after")], function(char_id) {
            cfg <- character_config[[char_id]]
            card_class <- if (cfg$active) "character-card" else "character-card coming-soon"
            card_click <- if (cfg$active) {
              paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})")
            } else { "" }

            div(class = card_class, onclick = card_click,
              if (!is.null(cfg$image)) tags$img(src = cfg$image, title = cfg$name_origin) else div(class = "placeholder-img", "?"),
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
      # Character navigation icons (grouped by phase)
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
        # Deciding to Use AI (2 characters)
        span(class = "nav-group-label", "Deciding"),
        lapply(names(character_config)[sapply(character_config, function(x) x$phase == "before")], function(char_id) {
          cfg <- character_config[[char_id]]
          if (is.null(cfg$image)) return(NULL)
          tags$img(
            src = cfg$image,
            class = "character-icon",
            id = paste0("icon_", char_id),
            onclick = paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})"),
            title = paste0(cfg$name, ": ", cfg$name_origin)
          )
        }),
        div(class = "nav-separator"),
        # Using AI (4 characters)
        span(class = "nav-group-label", "Using"),
        lapply(names(character_config)[sapply(character_config, function(x) x$phase == "during")], function(char_id) {
          cfg <- character_config[[char_id]]
          if (is.null(cfg$image)) return(NULL)
          tags$img(
            src = cfg$image,
            class = "character-icon",
            id = paste0("icon_", char_id),
            onclick = paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})"),
            title = paste0(cfg$name, ": ", cfg$name_origin)
          )
        }),
        div(class = "nav-separator"),
        # Understanding AI Outputs (2 characters)
        span(class = "nav-group-label", "Checking"),
        lapply(names(character_config)[sapply(character_config, function(x) x$phase == "after")], function(char_id) {
          cfg <- character_config[[char_id]]
          if (!is.null(cfg$image)) {
            tags$img(
              src = cfg$image,
              class = "character-icon",
              id = paste0("icon_", char_id),
              onclick = paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})"),
              title = paste0(cfg$name, ": ", cfg$name_origin)
            )
          } else {
            div(
              class = "character-icon",
              id = paste0("icon_", char_id),
              onclick = paste0("Shiny.setInputValue('char_select', '", char_id, "', {priority: 'event'})"),
              title = paste0(cfg$name, ": ", cfg$name_origin),
              style = "display: flex; align-items: center; justify-content: center; background: #e0e0e0; font-size: 14px; color: #999;",
              "\U0001F4A1"
            )
          }
        })
      ),
      div(class = "character-column",
        div(class = "owl-container",
          uiOutput("character_image"),
          div(class = "loading-gear", id = "loading_gear",
            uiOutput("character_gear")
          )
        ),
        uiOutput("character_name_label")
      ),
      div(class = "speech-bubble-container",
        div(class = "speech-bubble",
          div(class = "bubble-text",
            uiOutput("owl_response")
          )
        )
      )
    ),

    uiOutput("conversation_nav"),

    div(class = "input-section",
      textAreaInput("user_input",
                    label = NULL,
                    placeholder = "Type your message here...",
                    width = "100%",
                    rows = 3),
      div(style = "display: flex; justify-content: space-between; align-items: center;",
        actionButton("send_btn", "Send", class = "send-button"),
        uiOutput("reset_chat_btn")
      )
    ),

    # TEMPORARILY DISABLED: Giscus discussion
    # div(class = "giscus-section",
    #   h3("Discussion"),
    #   div(id = "giscus-container")
    # )
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
    p("The advice from any individual character is educational. It should not be used to make",
      "definitive judgments about specific tasks. Always consult your institution's policies and",
      "use professional judgment."),
    p(tags$strong("Do not submit sensitive, confidential, or personally identifiable information."),
      "Your inputs are sent to a third-party AI service (Google Gemini) for processing.",
      "Use generic or anonymized examples when describing your tasks."),
    footer = actionButton("dismiss_disclaimer", "I understand", class = "btn-primary"),
    easyClose = FALSE
  ))

  observeEvent(input$dismiss_disclaimer, {
    removeModal()
  })

  # Pre-fill API key from URL parameter (?key=...)
  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query$key) && nchar(query$key) > 0) {
      updateTextInput(session, "api_key_input", value = query$key)
    }
  }) |> bindEvent(session$clientData$url_search, once = TRUE)

  # Reactive values
  owl_text <- reactiveVal("")
  previous_principle <- reactiveVal("None")  # Used by direct feedback characters (Promptulus, Modulus)
  chat_object <- reactiveVal(NULL)           # Persistent chat for guided learning characters
  selected_character <- reactiveVal(NULL)
  app_view <- reactiveVal("landing")

  # Dialogos conversation history
  dialogos_history <- reactiveVal(list())    # list of list(user_input, response)
  dialogos_view_index <- reactiveVal(0L)     # 0 = current/live, 1..N = viewing historical turn

  # Direct feedback characters create a new chat each send (iterative prompt refinement)
  # Guided learning characters persist the chat across turns (multi-turn teaching)
  direct_feedback_characters <- c("promptulus", "modulus")


  # ===== NAVIGATION =====

  # Home button handler
  observeEvent(input$go_home, {
    app_view("landing")
    selected_character(NULL)
    owl_text("")
    previous_principle("None")
    chat_object(NULL)
    dialogos_history(list())
    dialogos_view_index(0L)
    shinyjs::show("landing_view")
    shinyjs::hide("character_view")
    shinyjs::runjs("document.body.classList.add('on-landing')")
    # Close sidebar if it was open (toggle is hidden on landing page)
    shinyjs::runjs("
      var layout = document.querySelector('.bslib-sidebar-layout');
      if (layout && !layout.classList.contains('sidebar-collapsed')) {
        var toggle = layout.querySelector('.collapse-toggle');
        if (toggle) toggle.click();
      }
    ")
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
    shinyjs::runjs("document.body.classList.remove('on-landing')")

    # Update greeting text and input placeholder
    owl_text(config$greeting)
    updateTextAreaInput(session, "user_input", placeholder = config$input_placeholder)

    # Reset state
    previous_principle("None")
    chat_object(NULL)
    dialogos_history(list())
    dialogos_view_index(0L)

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

    # TEMPORARILY DISABLED: Giscus discussion script injection
    # shinyjs::runjs(paste0("
    #   var container = document.getElementById('giscus-container');
    #   container.innerHTML = '';
    #   var script = document.createElement('script');
    #   script.src = 'https://giscus.app/client.js';
    #   script.setAttribute('data-repo', 'nate-layman/promptulus');
    #   script.setAttribute('data-repo-id', 'R_kgDOQPUupA');
    #   script.setAttribute('data-category', 'Character Discussions');
    #   script.setAttribute('data-category-id', 'DIC_kwDOQPUupM4CxtCy');
    #   script.setAttribute('data-mapping', 'specific');
    #   script.setAttribute('data-term', '", char, "-discussion');
    #   script.setAttribute('data-strict', '0');
    #   script.setAttribute('data-reactions-enabled', '1');
    #   script.setAttribute('data-emit-metadata', '0');
    #   script.setAttribute('data-input-position', 'bottom');
    #   script.setAttribute('data-theme', 'preferred_color_scheme');
    #   script.setAttribute('data-lang', 'en');
    #   script.setAttribute('crossorigin', 'anonymous');
    #   script.async = true;
    #   container.appendChild(script);
    # "))
  })

  # ===== RENDER UI ELEMENTS =====

  output$character_image <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    if (!is.null(config$image)) {
      tags$img(src = config$image, class = "owl-image", alt = config$name, title = config$name_origin)
    } else {
      div(class = "placeholder-img", style = "width: 150px; height: 150px; font-size: 48px;", "?")
    }
  })

  output$character_gear <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    if (!is.null(config$gear)) {
      tags$img(src = config$gear)
    }
  })

  output$character_name_label <- renderUI({
    req(selected_character())
    config <- character_config[[selected_character()]]
    div(class = "character-name-label", config$name)
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

    # Show user's input when viewing Dialogos history
    history_header <- NULL
    if (!is.null(selected_character()) && selected_character() == "dialogos") {
      view_idx <- dialogos_view_index()
      history <- dialogos_history()
      if (length(history) > 0) {
        display_turn <- if (view_idx == 0L) length(history) else view_idx
        entry <- history[[display_turn]]
        history_header <- div(class = "history-user-input",
          div(class = "history-label", "You said:"),
          entry$user_input
        )
      }
    }

    tagList(history_header, HTML(response_text))
  })

  output$api_key_status <- renderUI({
    key <- input$api_key_input
    env_key <- Sys.getenv("GEMINI_API_KEY")
    if (!is.null(key) && nchar(trimws(key)) > 0) {
      span(class = "api-key-status", style = "color: #4CAF50;", icon("check-circle"), " Key entered")
    } else {
      NULL
    }
  })

  # Reset chat button - shown only for guided learning characters
  output$reset_chat_btn <- renderUI({
    req(selected_character())
    if (!(selected_character() %in% direct_feedback_characters)) {
      actionButton("reset_chat", "Start fresh",
                    style = "background: none; border: 1px solid #ccc; color: #666; font-size: 13px; padding: 6px 15px; border-radius: 6px; cursor: pointer;")
    }
  })

  observeEvent(input$reset_chat, {
    chat_object(NULL)
    dialogos_history(list())
    dialogos_view_index(0L)
    config <- character_config[[selected_character()]]
    owl_text(config$greeting)
  })

  # Conversation navigator - shown only for Dialogos when there's history
  output$conversation_nav <- renderUI({
    req(selected_character() == "dialogos")
    history <- dialogos_history()
    if (length(history) == 0) return(NULL)

    view_idx <- dialogos_view_index()
    total <- length(history)
    is_live <- (view_idx == 0L)
    display_turn <- if (is_live) total else view_idx

    # Truncated user input for context
    current_entry <- history[[display_turn]]
    input_preview <- substr(current_entry$user_input, 1, 50)
    if (nchar(current_entry$user_input) > 50) {
      input_preview <- paste0(input_preview, "...")
    }

    prev_attrs <- if (display_turn <= 1) {
      list(class = "nav-arrow", disabled = "disabled")
    } else {
      list(class = "nav-arrow",
           onclick = "Shiny.setInputValue('nav_prev', Math.random(), {priority: 'event'})")
    }
    next_attrs <- if (is_live) {
      list(class = "nav-arrow", disabled = "disabled")
    } else {
      list(class = "nav-arrow",
           onclick = "Shiny.setInputValue('nav_next', Math.random(), {priority: 'event'})")
    }

    div(class = "conversation-nav",
      do.call(tags$button, c(prev_attrs, list(HTML('<i class="fa fa-chevron-left"></i>')))),
      span(class = "nav-label",
        if (is_live) {
          paste0("Turn ", total, " of ", total)
        } else {
          paste0("Turn ", view_idx, " of ", total)
        }
      ),
      do.call(tags$button, c(next_attrs, list(HTML('<i class="fa fa-chevron-right"></i>')))),
      if (!is_live) {
        span(class = "nav-context", "Viewing history")
      }
    )
  })

  # Navigate to previous turn
  observeEvent(input$nav_prev, {
    history <- dialogos_history()
    if (length(history) == 0) return()
    view_idx <- dialogos_view_index()
    total <- length(history)
    current_turn <- if (view_idx == 0L) total else view_idx
    if (current_turn > 1) {
      new_idx <- current_turn - 1L
      dialogos_view_index(new_idx)
      entry <- history[[new_idx]]
      owl_text(entry$response)
    }
  })

  # Navigate to next turn
  observeEvent(input$nav_next, {
    history <- dialogos_history()
    if (length(history) == 0) return()
    view_idx <- dialogos_view_index()
    if (view_idx == 0L) return()  # Already at live
    total <- length(history)
    if (view_idx < total) {
      new_idx <- view_idx + 1L
      dialogos_view_index(new_idx)
      entry <- history[[new_idx]]
      owl_text(entry$response)
    } else {
      # Back to live view
      dialogos_view_index(0L)
      entry <- history[[total]]
      owl_text(entry$response)
    }
  })

  # ===== SEND BUTTON HANDLER =====
  observeEvent(input$send_btn, {
    req(selected_character())
    if (nchar(trimws(input$user_input)) > 0) {
      user_prompt <- input$user_input
      is_direct_feedback <- selected_character() %in% direct_feedback_characters

      # Snap Dialogos back to live view when sending
      if (selected_character() == "dialogos") {
        dialogos_view_index(0L)
      }

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

        # Get or create chat object
        # Direct feedback characters (Promptulus, Modulus): new chat each send
        # Guided learning characters: persistent multi-turn chat
        if (is_direct_feedback || is.null(chat_object())) {
          # Build system prompt
          guidelines <- readLines(here::here(config$principles_file), warn = FALSE)
          guidelines_text <- paste(guidelines, collapse = "\n")
          system_prompt_template <- readLines(here::here(config$system_prompt_file), warn = FALSE)
          system_prompt_text <- paste(system_prompt_template, collapse = "\n")

          system_prompt <- gsub("\\{\\{GUIDELINES\\}\\}", guidelines_text, system_prompt_text)
          prev_principle <- previous_principle()
          system_prompt <- gsub("\\{\\{PREVIOUS_PRINCIPLE\\}\\}", prev_principle, system_prompt)

          cat(paste0("[LOG] Creating new chat, system prompt length: ", nchar(system_prompt), " characters\n"))

          chat_obj <- chat(
            name = "google_gemini/gemini-2.5-flash",
            system_prompt = system_prompt,
            api_key = api_key,
            echo = "none"
          )

          # Persist chat object for guided learning characters
          if (!is_direct_feedback) {
            chat_object(chat_obj)
          }
        } else {
          # Reuse existing chat for guided learning (multi-turn)
          chat_obj <- chat_object()
          cat("[LOG] Reusing existing chat (multi-turn)\n")
        }

        # Suppress httr2/cli retry messages and show our own longer notification
        response <- withCallingHandlers(
          chat_obj$chat(paste0("Please review this prompt:\n\n", user_prompt)),
          message = function(m) {
            msg <- conditionMessage(m)
            if (grepl("retry|throttl|wait|429|rate", msg, ignore.case = TRUE)) {
              showNotification(
                "The API is busy. Retrying...",
                type = "warning",
                duration = 5
              )
              invokeRestart("muffleMessage")
            }
          }
        )

        cat("[LOG] API response received\n")
        cat(paste0("[LOG] Response length: ", nchar(response), " characters\n"))

        # Store conversation turn for Dialogos history
        if (selected_character() == "dialogos") {
          history <- dialogos_history()
          history[[length(history) + 1]] <- list(
            user_input = user_prompt,
            response = response
          )
          dialogos_history(history)
          dialogos_view_index(0L)  # Snap to live view
        }

        # For Sequita: parse zone and append spectrum visualization
        if (selected_character() == "sequita") {
          zone_match <- regmatches(response, regexpr("\\[TRANSPARENCY: (high|low)\\]", response))
          zone <- NULL
          if (length(zone_match) > 0) {
            zone <- gsub("\\[TRANSPARENCY: |\\]", "", zone_match[1])
            response <- gsub("\\s*\\[TRANSPARENCY: [^]]+\\]\\s*", "", response)
          }
          owl_text(paste0(response, if (!is.null(zone)) spectrum_html(zone) else ""))
        } else {
          owl_text(response)
        }

        # Track previous principle for direct feedback characters only
        if (is_direct_feedback) {
          principle_match <- regmatches(response, regexpr("consider using the \\*\\*([^*]+)\\*\\*", response))
          if (length(principle_match) > 0) {
            principle_name <- gsub(".*\\*\\*([^*]+)\\*\\*.*", "\\1", principle_match[1])
            previous_principle(principle_name)
            cat(paste0("[LOG] Extracted principle: ", principle_name, "\n"))
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
