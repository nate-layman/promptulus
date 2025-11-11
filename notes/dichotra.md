Task: Add Dichotra the Squirrel into the R Shiny app, implementing a three-expert system (Promptulus, Modulus, and Dichotra) each with dedicated principles files.

UI Update:

Update the character selectInput to include Dichotra (Classification/Method).

Include hidden assets for Dichotra (squirrel.png, squirrel_gear.png).

A yes/no button shows up for each question she asks.

Have gear spin 2 seconds before rendering final answer.

I think your task is a hybrid task. Or I think your task is an AI task or I think your task is a traditional data science task! But we want the gear to spin so the user doesn't know which uses. Or maybe we can do both. The socratic method or the dichotomous key method. I can help you two ways! Would you like me to use an AI method or a data science method? If AI parse the taks description ussing ellmer. If not use dichotomous key.

Server Logic:

Expand character configurations (Promptulus, Modulus, Dichotra) defining initial text and gear IDs.

Update the observeEvent on the selection input to:

Handle image/gear switching for all three characters.

Set character-specific initial greeting text.

Dichotra won't use ellmer. It will follow a rubric, a dichotomous key to determine the answer. First the user will write down their task then it will ask them a series of Y/N questions (outlined in the task_classification_rubric.md) with the final one always being 'I hope that was helpful! Now what kind of method do you think I use?"

Crucially: Update API logic (observeEvent(input$send_btn)) to dynamically load the appropriate principles file based on the selected character:

Promptulus: Loads prompting_principles.md (Clarity/Structure).

Modulus: Loads modularzing_principles.md (Workflow/Complexity).

Dichotra: Loads whatever is necessary to store the rubric / dichotomous key.

If Dichotra suggests an AI approach have her recommend the user visit Promptulus.
