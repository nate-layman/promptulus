Task: Fully integrate Modulus the Crab into the R Shiny app and implement file separation.

UI Update: Add a character selectInput. Include hidden assets (crab.png, crab_gear.png) alongside the existing owl assets.

Server Logic: Define character configurations and create an observeEvent on the selection input to:

Switch the displayed character image/gear and initial greeting/text content.

Dynamically select the correct loading gear ID to activate (fa-spin) when a prompt is sent.

Crucially: Update API logic (observeEvent(input$send_btn)) to load modularzing_principles.md when Modulus is selected, and prompting_principles.md when Promptulus is selected.

File Separation:

Create a new file, modularzing_principles.md that contains an entirely new set of principles for when and how to break apart complex tasks into modularized steps.

Update promptulus_system_prompt.md so Promptulus refers users to Modulus when promptulus recommends the modularize complex tasks principle.
