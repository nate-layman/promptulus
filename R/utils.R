#' Utility Functions for Promptulus
#'
#' @keywords internal

#' Initialize OpenAI API Client
#'
#' Creates and configures an ellmer chat client for OpenAI
#'
#' @return An ellmer chat client object
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

  tryCatch({
    # Create an OpenAI chat client
    client <- ellmer::chat_openai(
      api_key = api_key,
      model = "gpt-4-turbo"
    )
    return(client)
  }, error = function(e) {
    stop("Failed to initialize API client: ", e$message)
  })
}

#' Make a simple API call to test connection
#'
#' @param client An ellmer chat client
#'
#' @return TRUE if successful, FALSE otherwise
#' @keywords internal
test_api_connection <- function(client) {
  tryCatch({
    response <- client$chat(
      messages = list(
        list(role = "user", content = "Say 'OK'")
      )
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
