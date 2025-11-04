#' Prompt Coach: Constructive Feedback and Guidance
#'
#' The Coach analyzes user prompts, identifies gaps, explains relevant techniques,
#' and suggests improvements without rewriting the prompt.
#'
#' @keywords internal

#' Get the Coach system prompt
#'
#' @param techniques_list A formatted string of all available techniques
#'
#' @return A system prompt string for the Coach
#' @keywords internal
get_coach_system_prompt <- function(techniques_list) {
  glue::glue(
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

Remember: Your goal is to teach and guide, not to do the work for them!
"
  )
}

#' Call the Coach model
#'
#' @param user_prompt The user's prompt to analyze
#' @param genie_response The Genie's playful misinterpretation (for context)
#' @param client An OpenAI API client configuration
#'
#' @return The Coach's constructive feedback
#' @keywords internal
call_coach <- function(user_prompt, genie_response, client) {
  techniques_list <- get_techniques()
  tech_descriptions <- sapply(techniques_list, function(t) {
    glue::glue("- {t$name}")
  })
  tech_string <- paste(tech_descriptions, collapse = "\n")

  system_prompt <- get_coach_system_prompt(tech_string)

  coach_message <- glue::glue(
    "Here's the user's prompt that the Genie just misinterpreted:

\"{user_prompt}\"

And here's what the Genie did with it (the playful misinterpretation):

\"{genie_response}\"

Now provide your coaching feedback using the format specified in your system prompt.
Help the user understand what techniques could improve their prompt."
  )

  call_openai_api(system_prompt, coach_message, client$model)
}

#' Process and format Coach feedback
#'
#' @param feedback Raw feedback from the Coach
#'
#' @return Formatted feedback string
#' @keywords internal
format_coach_feedback <- function(feedback) {
  # The feedback is already formatted by the Coach, but we can add styling
  feedback
}
