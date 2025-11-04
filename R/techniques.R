#' Prompting Techniques Database
#'
#' Defines the 10 core prompting techniques used in Promptulus
#'
#' @keywords internal

#' Get all prompting techniques
#'
#' @return A list of technique objects
#' @export
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

#' Get a specific technique by ID
#'
#' @param id The technique ID
#'
#' @return A technique object
#' @export
get_technique <- function(id) {
  techniques <- get_techniques()
  techniques[[id]] %||% NULL
}

#' Get all technique IDs
#'
#' @return A character vector of technique IDs
#' @export
get_technique_ids <- function() {
  names(get_techniques())
}

#' Get all technique names
#'
#' @return A character vector of technique names
#' @export
get_technique_names <- function() {
  techniques <- get_techniques()
  sapply(techniques, function(t) t$name)
}

#' Format techniques for use in coaching
#'
#' @param techniques A character vector of technique IDs
#'
#' @return A formatted string describing the techniques
#' @export
format_techniques <- function(techniques) {
  if (length(techniques) == 0) {
    return("None identified")
  }

  tech_list <- get_techniques()
  formatted <- sapply(techniques, function(id) {
    tech <- tech_list[[id]]
    if (is.null(tech)) return(NULL)
    glue::glue("**{tech$name}** – {tech$description}")
  })

  paste(formatted, collapse = "\n\n")
}
