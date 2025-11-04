#' Utility Functions for Promptulus
#'
#' @keywords internal

#' Initialize OpenAI API Client
#'
#' Creates and configures an OpenAI API client using the openai package
#'
#' @return A list containing API configuration
#' @keywords internal
#' @export
init_api_client <- function() {
  api_key <- Sys.getenv("OPENAI_API_KEY")

  if (api_key == "") {
    stop(
      "OPENAI_API_KEY environment variable not set.\n",
      "Set it with: Sys.setenv(OPENAI_API_KEY = 'your-key')\n",
      "Or add it to your .env file."
    )
  }

  # Set the API key for the openai package
  Sys.setenv(OPENAI_API_KEY = api_key)

  tryCatch({
    # Test connection with a simple call
    response <- openai::create_chat_completion(
      model = "gpt-4-turbo-preview",
      messages = list(list(role = "user", content = "test")),
      max_tokens = 5
    )

    if (is.null(response)) {
      stop("Failed to connect to OpenAI API")
    }

    # Return a client object
    list(
      api_key = api_key,
      model = "gpt-4-turbo-preview",
      type = "openai"
    )
  }, error = function(e) {
    stop("Failed to initialize API client: ", e$message)
  })
}

#' Make an API call to OpenAI
#'
#' @param system_prompt The system prompt for the AI
#' @param user_message The user's message
#' @param model The model to use (default: gpt-4-turbo-preview)
#'
#' @return The response text from OpenAI
#' @keywords internal
call_openai_api <- function(system_prompt, user_message, model = "gpt-4-turbo-preview") {
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
      return("Error: No response from API")
    }

    # Extract the message content
    response$choices[[1]]$message$content
  }, error = function(e) {
    glue::glue("API Error: {e$message}")
  })
}

#' Make a simple API call to test connection
#'
#' @param client An OpenAI API client configuration
#'
#' @return TRUE if successful, FALSE otherwise
#' @keywords internal
test_api_connection <- function(client) {
  tryCatch({
    response <- openai::create_chat_completion(
      model = client$model,
      messages = list(
        list(role = "user", content = "Say OK")
      ),
      max_tokens = 10
    )
    return(!is.null(response))
  }, error = function(e) {
    return(FALSE)
  })
}

#' Extract text from API response
#'
#' Handles different response formats from ellmer
#'
#' @param response The response from an API call
#'
#' @return Character string of the response content
#' @keywords internal
extract_response_text <- function(response) {
  if (is.null(response)) {
    return("")
  }

  if (is.list(response)) {
    if (!is.null(response$content)) {
      return(as.character(response$content))
    }
  }

  return(as.character(response))
}

#' Convert markdown to HTML for Shiny display
#'
#' @param markdown_text Text with markdown formatting
#'
#' @return HTML string
#' @keywords internal
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

  # Convert italic
  text <- gsub("\\*(.+?)\\*", "<em>\\1</em>", text)

  # Convert numbered lists
  text <- gsub("^([0-9]+)\\.\\s+(.+?)$", "<li>\\2</li>", text, perl = TRUE)

  # Convert bullet points
  text <- gsub("^-\\s+(.+?)$", "<li>\\1</li>", text, perl = TRUE)

  # Wrap list items in <ul>
  text <- gsub("(<li>.+?</li>)", "<ul>\\1</ul>", text, perl = TRUE)

  # Convert line breaks
  text <- gsub("\n\n", "</p><p>", text)
  text <- gsub("\n", "<br>", text)
  text <- paste0("<p>", text, "</p>")

  text
}

#' Format a prompt history entry for display
#'
#' @param entry A history entry list
#' @param index The index of this entry
#'
#' @return HTML string for display
#' @keywords internal
format_history_entry <- function(entry, index) {
  time_str <- format(entry$timestamp, "%Y-%m-%d %H:%M:%S")

  glue::glue(
    "<div class='card mb-3'>
      <div class='card-header'>
        <strong>Attempt #{index}</strong> - {time_str}
      </div>
      <div class='card-body'>
        <p><strong>Your Prompt:</strong></p>
        <p>{entry$prompt}</p>
      </div>
    </div>"
  )
}

#' Create a feedback summary
#'
#' @param prompt The user's prompt
#' @param genie_response The Genie's response
#' @param coach_response The Coach's feedback
#'
#' @return A summary object
#' @keywords internal
create_feedback_summary <- function(prompt, genie_response, coach_response) {
  list(
    prompt = prompt,
    genie_response = genie_response,
    coach_response = coach_response,
    timestamp = Sys.time()
  )
}

#' Null coalescing operator
#'
#' @param x Value to check
#' @param y Default value
#'
#' @return x if not NULL, otherwise y
#' @keywords internal
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
