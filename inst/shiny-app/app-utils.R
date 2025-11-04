# Promptulus App Utilities
# Consolidated functions for the Shiny app

library(openai)
library(jsonlite)
library(glue)

# ============================================================================
# Prompting Techniques
# ============================================================================

get_techniques <- function() {
  list(
    role_persona = list(
      id = "role_persona",
      name = "Specify Role/Persona",
      short_desc = "Tell AI what perspective to adopt",
      description = "Define a specific role or persona for the AI to assume when responding. This shapes how the AI interprets the context and frames its response.",
      example = "Act as a senior software architect and explain this code...",
      why_matters = "Gives the AI a frame of reference for the appropriate level of detail, formality, and expertise in the response.",
      genie_misapplication = "Ignores the persona and responds from a completely different perspective (e.g., as a beginner instead of an expert)."
    ),
    output_format = list(
      id = "output_format",
      name = "Clarify Output Format",
      short_desc = "Specify bullet list, table, paragraph, etc.",
      description = "Explicitly specify how you want the output structured (bullet points, table, JSON, narrative, etc.). This prevents ambiguity about the expected format.",
      example = "Provide your response as a numbered list with 5-7 items, each 2-3 sentences long.",
      why_matters = "Without format clarity, the AI might provide information in an unusable format for your needs.",
      genie_misapplication = "Provides the content in a completely different format (e.g., a dense paragraph instead of bullets)."
    ),
    constraints = list(
      id = "constraints",
      name = "Add Constraints",
      short_desc = "Set length, style, or audience constraints",
      description = "Specify constraints like length (word count, character limit), style (formal, casual, technical), or audience level (beginner, expert).",
      example = "Explain this in under 100 words, using simple language for a 10-year-old.",
      why_matters = "Constraints help the AI focus on your specific needs and prevent verbose or overly complex responses.",
      genie_misapplication = "Ignores constraints and provides excessively long, overly technical, or wildly inappropriate responses."
    ),
    context = list(
      id = "context",
      name = "Provide Context",
      short_desc = "Give background or situation information",
      description = "Share relevant background information, the situation, problem constraints, or what you're trying to achieve. This helps the AI understand your specific needs.",
      example = "I'm building a mobile app for teenagers interested in environmental sustainability. I need a feature that...",
      why_matters = "Context allows the AI to tailor responses to your actual situation rather than providing generic advice.",
      genie_misapplication = "Assumes a completely different context and responds to a different problem than what you intended."
    ),
    step_by_step = list(
      id = "step_by_step",
      name = "Ask for Step-by-Step Reasoning",
      short_desc = "Request structured reasoning",
      description = "Ask the AI to break down its reasoning, show its work, or explain step-by-step how it arrived at its answer. This promotes logical thinking and transparency.",
      example = "Walk me through your reasoning step-by-step. First explain the problem, then outline your approach, then show the solution.",
      why_matters = "Structured reasoning helps you follow the logic, verify correctness, and learn from the AI's thought process.",
      genie_misapplication = "Provides only the final answer without any reasoning or breakdown of steps."
    ),
    examples = list(
      id = "examples",
      name = "Use Examples",
      short_desc = "Show what kind of output you want",
      description = "Provide one or more examples of the desired output or similar examples to guide the AI toward your expectations.",
      example = "Here's an example of the tone I want: 'The UI is buttery smooth and feels like magic.' Now describe this app the same way...",
      why_matters = "Examples are more effective than descriptions at communicating your intent, especially for subjective qualities.",
      genie_misapplication = "Ignores the examples and produces output with completely different style, tone, or structure."
    ),
    tone_style = list(
      id = "tone_style",
      name = "Specify Tone or Style",
      short_desc = "Define formal, humorous, poetic, etc.",
      description = "Explicitly state the desired tone (formal, casual, humorous, sarcastic, poetic, etc.) or writing style for the response.",
      example = "Write this as a witty LinkedIn post, not an academic paper.",
      why_matters = "Tone and style significantly affect how the message is received and whether it's appropriate for your audience.",
      genie_misapplication = "Uses an inappropriate or opposite tone (serious instead of humorous, or vice versa)."
    ),
    audience = list(
      id = "audience",
      name = "Define Audience",
      short_desc = "Specify who the response is for",
      description = "Clearly identify who will be reading or using the response (CEO, 5th graders, data scientists, general public, etc.) so the AI can adjust complexity and terminology.",
      example = "Write this for a non-technical executive who needs to understand the business impact.",
      why_matters = "Audience clarity ensures the level of detail, jargon, and complexity matches who will actually use the information.",
      genie_misapplication = "Targets the wrong audience level (too technical for beginners, or too simple for experts)."
    ),
    comparison_analysis = list(
      id = "comparison_analysis",
      name = "Ask for Comparison/Analysis",
      short_desc = "Request comparative or analytical thinking",
      description = "Ask the AI to compare options, analyze pros and cons, evaluate trade-offs, or think critically about alternatives.",
      example = "Compare these three approaches. For each, explain the pros, cons, and when you'd use it.",
      why_matters = "Comparison and analysis prompt deeper thinking and help you make better informed decisions.",
      genie_misapplication = "Provides only one-sided information or fails to compare the alternatives you asked about."
    ),
    break_down = list(
      id = "break_down",
      name = "Break Down Complex Tasks",
      short_desc = "Divide problems into parts or steps",
      description = "For complex problems, ask the AI to break them into smaller, more manageable parts or steps. This makes solutions clearer and more actionable.",
      example = "Break down the process for building a web app into distinct phases. For each phase, list the key tasks.",
      why_matters = "Breaking down complex tasks makes them less overwhelming and easier to understand and execute.",
      genie_misapplication = "Provides the information as one giant, interconnected mass without any breakdown or organization."
    )
  )
}

get_technique <- function(id) {
  techniques <- get_techniques()
  techniques[[id]] %||% NULL
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# ============================================================================
# OpenAI API Integration
# ============================================================================

call_openai <- function(system_prompt, user_message, model = "gpt-4-turbo-preview") {
  tryCatch({
    response <- openai::create_chat_completion(
      model = model,
      messages = list(
        list(role = "system", content = system_prompt),
        list(role = "user", content = user_message)
      ),
      temperature = 0.7,
      max_tokens = 1500
    )

    if (is.null(response) || is.null(response$choices)) {
      return("Error: No response from OpenAI API")
    }

    response$choices[[1]]$message$content
  }, error = function(e) {
    glue("Error: {e$message}")
  })
}

# ============================================================================
# Genie (Playful Misinterpretation)
# ============================================================================

get_genie_prompt <- function(techniques_list) {
  glue(
    "You are Promptulus the Genie, a playful and mischievous AI character whose job is to teach users about prompting techniques.

YOUR PERSONALITY:
- You are witty, playful, and a bit magical. You love wordplay and puns.
- You intentionally misinterpret prompts in funny ways to highlight missing prompting techniques.
- You are never mean-spirited - your goal is to gently nudge users toward better prompting.
- You should make your responses entertaining while still illustrating the problem.

YOUR TASK:
1. Analyze the user's prompt against these core prompting techniques:
{techniques_list}

2. Identify which techniques are MISSING or POORLY APPLIED in the user's prompt.

3. Randomly select ONE missing technique and intentionally misapply it in a playful, magical way:
   - If they didn't specify a role/persona, respond from a wildly inappropriate perspective
   - If they didn't clarify output format, use a silly format
   - If they didn't add constraints, exaggerate or minimize everything
   - If they didn't provide context, assume a completely different scenario
   - And so on...

4. Provide your misinterpreted response in character as the Genie, making it clear that you're deliberately missing the point.

5. At the end, add a subtle hint like: 'Perhaps if you had been more specific about [technique]...' or '🧞 *waves wand mysteriously*'

IMPORTANT CONSTRAINTS:
- Your response should be playful but still educational
- Make it clear you're intentionally misinterpreting, not actually confused
- The response should be entertaining to read
- Keep responses concise (2-3 paragraphs max)
- Always maintain the playful genie character

Remember: You're teaching through humor and intentional misinterpretation!"
  )
}

call_genie <- function(user_prompt) {
  techniques_list <- get_techniques()
  tech_descriptions <- sapply(techniques_list, function(t) {
    glue("- **{t$name}**: {t$short_desc}")
  })
  tech_string <- paste(tech_descriptions, collapse = "\n")

  system_prompt <- get_genie_prompt(tech_string)
  user_message <- glue("Please misinterpret this prompt: \"{user_prompt}\"")

  call_openai(system_prompt, user_message)
}

# ============================================================================
# Coach (Constructive Feedback)
# ============================================================================

get_coach_prompt <- function(techniques_list) {
  glue(
    "You are the Prompt Coach, a supportive and knowledgeable AI teacher whose job is to help users write better prompts.

YOUR PERSONALITY:
- You are encouraging, clear, and focused on helping users learn.
- You explain concepts in accessible language without being condescending.
- You guide users toward improvement without doing the work for them.
- You celebrate progress and learning.

YOUR TASK:
Analyze the user's prompt and provide constructive feedback in this format:

## 🔍 What Could Be Improved
- List 2-4 specific areas where the prompt could be clearer or more effective

## 🛠️ Techniques to Consider
For EACH missing or weak technique:
1. **Technique Name** – State which of these you're addressing:
{techniques_list}

## 📘 How This Technique Works
Briefly explain (2-3 sentences) what this technique does and why it matters

## ✍️ How You Might Apply It
Provide a SPECIFIC example of how the user could apply THIS EXACT TECHNIQUE to THEIR PROMPT.
- Focus on their specific topic/goal
- Show the technique in action
- Make it clear and actionable
- DO NOT rewrite their entire prompt

## 💡 Next Steps
Suggest 1-2 things they could do to iterate and improve their prompt.

CRITICAL REQUIREMENTS:
- Do NOT rewrite or complete the user's prompt
- Do NOT lecture - keep explanations concise
- Focus on the TOP 2-3 techniques that would have the biggest impact
- Be encouraging and supportive in tone
- Make your examples specific to their actual prompt, not generic
- Use emoji and formatting to make it engaging and easy to scan

Remember: Your goal is to teach and guide, not to do the work for them!"
  )
}

call_coach <- function(user_prompt, genie_response) {
  techniques_list <- get_techniques()
  tech_descriptions <- sapply(techniques_list, function(t) {
    glue("- {t$name}")
  })
  tech_string <- paste(tech_descriptions, collapse = "\n")

  system_prompt <- get_coach_prompt(tech_string)

  coach_message <- glue(
    "Here's the user's prompt that the Genie just misinterpreted:

\"{user_prompt}\"

And here's what the Genie did with it (the playful misinterpretation):

\"{genie_response}\"

Now provide your coaching feedback using the format specified in your system prompt.
Help the user understand what techniques could improve their prompt."
  )

  call_openai(system_prompt, coach_message)
}

# ============================================================================
# Utilities
# ============================================================================

markdown_to_html <- function(markdown_text) {
  if (is.null(markdown_text) || markdown_text == "") {
    return("")
  }

  text <- markdown_text

  # Convert markdown headers
  text <- gsub("^## (.+?)$", "<h3>\\1</h3>", text, perl = TRUE)
  text <- gsub("^### (.+?)$", "<h4>\\1</h4>", text, perl = TRUE)

  # Convert bold
  text <- gsub("\\*\\*(.+?)\\*\\*", "<strong>\\1</strong>", text)

  # Convert numbered lists and bullet points
  text <- gsub("^([0-9]+)\\.\\s+(.+?)$", "<li>\\2</li>", text, perl = TRUE)
  text <- gsub("^-\\s+(.+?)$", "<li>\\1</li>", text, perl = TRUE)

  # Convert line breaks
  text <- gsub("\n\n", "</p><p>", text)
  text <- paste0("<p>", text, "</p>")

  text
}

message("✓ App utilities loaded")
