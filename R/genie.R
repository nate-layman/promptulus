#' Promptulus the Genie: Playful Misinterpretation
#'
#' The Genie analyzes user prompts and intentionally misapplies a missing
#' prompting technique to produce a playfully incorrect response.
#'
#' @keywords internal

#' Get the Genie system prompt
#'
#' @param techniques_list A formatted string of all available techniques
#'
#' @return A system prompt string for the Genie
#' @keywords internal
get_genie_system_prompt <- function(techniques_list) {
  glue::glue(
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

Remember: You're teaching through humor and intentional misinterpretation!
"
  )
}

#' Call the Genie model
#'
#' @param user_prompt The user's prompt to misinterpret
#' @param client An OpenAI API client configuration
#'
#' @return The Genie's playful misinterpretation
#' @keywords internal
call_genie <- function(user_prompt, client) {
  techniques_list <- get_techniques()
  tech_descriptions <- sapply(techniques_list, function(t) {
    glue::glue("- **{t$name}**: {t$short_desc}")
  })
  tech_string <- paste(tech_descriptions, collapse = "\n")

  system_prompt <- get_genie_system_prompt(tech_string)
  user_message <- glue::glue("Please misinterpret this prompt: \"{user_prompt}\"")

  call_openai_api(system_prompt, user_message, client$model)
}

#' Analyze prompt for missing techniques (helper for Genie)
#'
#' @param user_prompt The user's prompt
#' @param client An ellmer chat client
#'
#' @return A list of missing technique IDs
#' @keywords internal
analyze_missing_techniques <- function(user_prompt, client) {
  techniques_list <- get_techniques()
  tech_descriptions <- sapply(techniques_list, function(t) {
    glue::glue("- **{t$name}** (id: {t$id}): {t$short_desc}")
  })
  tech_string <- paste(tech_descriptions, collapse = "\n")

  analysis_prompt <- glue::glue(
    "Analyze this prompt and identify which of these techniques are MISSING or POORLY APPLIED.

Available techniques:
{tech_string}

User prompt: \"{user_prompt}\"

Return ONLY a JSON array of technique IDs that are missing or poorly applied, like this:
[\"role_persona\", \"output_format\"]

If all techniques are well applied, return an empty array: []
"
  )

  response <- client$chat(
    messages = list(
      list(role = "user", content = analysis_prompt)
    )
  )

  response_text <- if (is.list(response)) response$content else as.character(response)

  tryCatch({
    # Extract JSON from response
    json_match <- regmatches(response_text, regexpr("\\[.*\\]", response_text))
    if (length(json_match) > 0) {
      return(jsonlite::fromJSON(json_match[1]))
    }
    return(list())
  }, error = function(e) {
    return(list())
  })
}
