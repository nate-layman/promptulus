library(shiny)
library(bslib)
library(shinyjs)

# Source UI and server
source("ui.R", local = TRUE)
source("server.R", local = TRUE)

# Create and run the Shiny app
shinyApp(ui = ui, server = server)
