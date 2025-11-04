library(shiny)
library(promptulus)

# Source UI and server
source("ui.R", local = TRUE)
source("server.R", local = TRUE)

# Create the Shiny app
shinyApp(ui = ui, server = server)
