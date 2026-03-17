# AI Literacy Companions

An interactive Shiny app that teaches fundamental skills for working with AI through a cast of animal characters. Each character focuses on one discipline — from deciding whether to use AI at all, to crafting effective prompts, to evaluating the results.

## Live Demo

Visit the deployed app: [https://n8-layman.shinyapps.io/promptulus/](https://n8-layman.shinyapps.io/promptulus/)

## Characters

The companions are organized into three workflow phases:

### Before AI: Planning
| Character | Animal | Skill |
|-----------|--------|-------|
| **Sequita** | Squirrel | When to Use AI — assesses whether your task needs transparency and auditability, or whether a good answer is all that matters |
| **Modulus** | Crab | Task Decomposition — breaks complex tasks into smaller, modular pieces that AI can handle well |

### During AI: The Four I's
| Character | Animal | Skill |
|-----------|--------|-------|
| **Telosa** | Turtle | Intent Engineering — helps you define clear goals, accountability, and escape hatches |
| **Promptulus** | Owl | Prompt Engineering — reviews and improves your prompts using proven principles |
| **Mnemos** | Elephant | Context Engineering — teaches what context to provide (and what to leave out) |
| **Dialogos** | Parrot | Conversation Management — guides multi-turn interactions *(coming soon)* |

### After AI: Quality & Reporting
| Character | Animal | Skill |
|-----------|--------|-------|
| **Veridex** | Raccoon | Evaluation — teaches how to assess AI outputs *(coming soon)* |
| **Lucerna** | Firefly | Reporting — helps communicate AI-assisted work *(coming soon)* |

**Octavius** the Octopus serves as the landing page mascot, introducing the full workflow.

## Features

- **Interactive Learning**: Submit task descriptions or prompts and get character-specific feedback
- **Transparency Spectrum**: Sequita assesses tasks on a high-to-low transparency scale with visual indicator
- **Principle-Based Teaching**: Each character draws from a curated set of principles, varying recommendations to expose different dimensions
- **Cross-Character References**: Characters suggest when to visit other companions for complementary skills
- **Giscus Discussions**: Per-character discussion threads for community feedback

## Local Development

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/nate-layman/promptulus.git
   cd promptulus
   ```

2. **Get a free Gemini API key**
   - Visit [Google AI Studio](https://aistudio.google.com/apikey)
   - Click "Create API Key"
   - Copy your API key

3. **Set up your environment**

   Create `app/.Renviron`:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

   Or enter your key directly in the app's landing page.

4. **Install R dependencies**
   ```r
   # Using renv (recommended)
   renv::restore()

   # Or manually
   install.packages(c("shiny", "shinyjs", "bslib", "ellmer", "here", "rsconnect"))
   ```

5. **Run the app**
   ```r
   shiny::runApp("app")
   ```

## Deployment to shinyapps.io

```r
rsconnect::deployApp(appDir = "app", appName = "promptulus")
```

See [shinyapps.io](https://www.shinyapps.io/) for account setup. The free tier includes 25 active hours/month.

## Project Structure

```
promptulus/
├── app/
│   ├── app.R                              # Main Shiny application
│   ├── sequita_system_prompt.md           # Sequita (transparency assessment)
│   ├── task_categorization_principles.md  # Transparency principles
│   ├── task_classification_rubric.md      # Transparency rubric
│   ├── telosa_system_prompt.md            # Telosa (intent engineering)
│   ├── intent_engineering_principles.md   # Intent principles
│   ├── promptulus_system_prompt.md        # Promptulus (prompt engineering)
│   ├── prompting_principles.md            # Prompting principles
│   ├── modulus_system_prompt.md           # Modulus (task decomposition)
│   ├── modularization_principles.md       # Modularization principles
│   └── www/                               # Character artwork
│       ├── octopus.png                    # Landing page mascot
│       ├── squirrel.png, squirrel_gear.png
│       ├── crab.png, crab_gear.png
│       ├── turtle.png, turtle_gear.png
│       └── owl.png, owl_gear.png
├── notes/                                 # Design documentation
│   ├── AI_literacy_companions.md          # Character roster and design notes
│   └── ...
├── renv.lock                              # R dependency lockfile
└── README.md
```

## Technologies

- **Shiny** + **bslib**: R framework for web applications
- **ellmer**: R package for LLM interactions (Google Gemini)
- **Google Gemini**: Free-tier LLM API (Gemini 2.5 Flash)
- **shinyapps.io**: Hosting with secure environment variables

## Cost

Uses Google Gemini's free tier: 15 requests/minute, 1,500 requests/day.

## Contributing

Contributions welcome! See [Issues](../../issues) for current plans.

## License

[Add your license here]
