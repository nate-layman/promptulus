#' Launch the Promptulus Shiny Application
#'
#' Starts the interactive Promptulus learning game. Requires OPENAI_API_KEY
#' environment variable to be set.
#'
#' @param host The host address to listen on. Default: "127.0.0.1"
#' @param port The port to listen on. Default: 3838
#'
#' @return Invisibly returns the Shiny app object
#' @export
#'
#' @examples
#' \dontrun{
#' # Set your OpenAI API key first:
#' Sys.setenv(OPENAI_API_KEY = "sk-...")
#'
#' # Then launch the app
#' run_promptulus()
#' }
run_promptulus <- function(host = "127.0.0.1", port = 3838) {
  # Check for API key
  if (Sys.getenv("OPENAI_API_KEY") == "") {
    stop(
      "OPENAI_API_KEY environment variable not set.\n",
      "Please set it using: Sys.setenv(OPENAI_API_KEY = 'your-key-here')\n",
      "Or create a .env file with: OPENAI_API_KEY=your-key-here"
    )
  }

  # Get the app directory
  app_dir <- system.file("shiny-app", package = "promptulus")

  if (app_dir == "") {
    stop("Could not find Shiny app files. Make sure the package is installed correctly.")
  }

  # Run the app
  shiny::runApp(
    appDir = app_dir,
    host = host,
    port = port,
    launch.browser = TRUE
  )
}

#' Promptulus Package
#'
#' An interactive learning game that teaches users how to write better AI prompts.
#' Users interact with Promptulus the Genie (who playfully misinterprets prompts)
#' and the Prompt Coach (who provides constructive feedback).
#'
#' @section Quick Start:
#'
#' ```r
#' # Set your OpenAI API key
#' Sys.setenv(OPENAI_API_KEY = "sk-...")
#'
#' # Launch the app
#' library(promptulus)
#' run_promptulus()
#' ```
#'
#' @section Main Functions:
#'
#' - [run_promptulus()] - Launch the interactive learning app
#' - [get_techniques()] - Get all 10 prompting techniques
#' - [call_genie()] - Call the Genie model directly (advanced)
#' - [call_coach()] - Call the Coach model directly (advanced)
#'
#' @keywords internal
"_PACKAGE"
