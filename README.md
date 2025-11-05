# Promptulus

Promptulus is an interactive Shiny app that reviews LLM prompts and helps you improve them using proven prompt engineering principles. The wise owl Promptulus rates your prompts (1-5 mice) and provides constructive feedback to make them more effective.

## Features

- **Prompt Review**: Submit your prompts and get immediate feedback
- **Rating System**: See how well your prompt scores (1-5 mice)
- **Actionable Suggestions**: Get specific improvements based on prompt engineering best practices
- **Iterative Learning**: Refine your prompts based on suggestions and resubmit

## Live Demo

Visit the deployed app: [Your GitHub Pages URL will appear here after deployment]

## Local Development

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/promptulus.git
   cd promptulus
   ```

2. **Get a free Gemini API key**
   - Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Click "Create API Key"
   - Copy your API key

3. **Set up your environment**
   ```bash
   cp .env.example .env
   ```

   Edit `.env` and replace `your_api_key_here` with your actual Gemini API key:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

4. **Install R dependencies**
   ```r
   install.packages(c("shiny", "shinyjs", "bslib", "ellmer", "here"))
   ```

5. **Run the app**
   ```r
   # From R console in the project root
   shiny::runApp("app")
   ```

   Or in RStudio: Open `app/app.R` and click "Run App"

## Deployment to GitHub Pages with Shinylive

Shinylive converts your Shiny app to run entirely in the browser using WebAssembly - no R server required!

### Option 1: Manual Deployment (Recommended for Learning)

1. **Install shinylive**
   ```r
   install.packages("shinylive")
   ```

2. **Use the helper script** (easiest way)
   ```bash
   Rscript export_shinylive.R
   ```

   This script will:
   - Read your API key from `.env`
   - Create a temporary copy of your app with the key embedded
   - Export to `docs/` folder using shinylive
   - Clean up the temporary files

   **Or do it manually:**
   ```r
   # Read the app file
   app_code <- readLines("app/app.R")

   # Replace the Sys.getenv call with your actual key
   app_code <- gsub('Sys.getenv\\("GEMINI_API_KEY"\\)', '"your_actual_api_key"', app_code)

   # Write it back
   writeLines(app_code, "app/app.R")

   # Export
   shinylive::export("app", "docs")

   # Restore original (important!)
   system("git checkout app/app.R")
   ```

3. **Enable GitHub Pages**
   - Go to your repository Settings → Pages
   - Under "Source", select "Deploy from a branch"
   - Branch: `main`, Folder: `/docs`
   - Click "Save"

4. **Commit and push**
   ```bash
   git add docs/
   git commit -m "Add shinylive deployment"
   git push origin main
   ```

5. **Your app is live!**
   - Visit `https://yourusername.github.io/promptulus/`
   - Wait a minute or two for GitHub Pages to build

### Option 2: Automated Deployment with GitHub Actions

The repository includes a GitHub Actions workflow that automatically exports and deploys on push.

1. **Add your Gemini API key as a GitHub Secret**
   - Go to your repository on GitHub
   - Navigate to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GEMINI_API_KEY`
   - Value: Your Gemini API key
   - Click "Add secret"

2. **Enable GitHub Pages**
   - Go to Settings → Pages
   - Under "Source", select "Deploy from a branch"
   - Branch: `main`, Folder: `/docs`

3. **Push to main branch**
   ```bash
   git push origin main
   ```

4. **Check deployment**
   - Go to the "Actions" tab in your repository
   - Watch the deployment workflow run
   - Once complete, your app will be live at `https://yourusername.github.io/promptulus/`

### How Shinylive Works

1. **Conversion**: `shinylive::export()` converts your R/Shiny code to run in WebAssembly
2. **Static Files**: Creates HTML/JS/CSS that can be served from any static host
3. **No Server**: The entire R runtime runs in the user's browser
4. **Free Hosting**: Perfect for GitHub Pages, Netlify, etc.

### Testing Locally

You can test the exported app locally before deploying:

```bash
# Serve the docs folder
python -m http.server 8000 -d docs

# Or with Node.js
npx serve docs
```

Then visit `http://localhost:8000` in your browser.

## Project Structure

```
promptulus/
├── app/
│   ├── app.R                          # Main Shiny application
│   ├── promptulus_system_prompt.md    # System prompt template for Promptulus
│   ├── prompting_guidelines.md        # Prompt engineering principles
│   ├── siren_system_prompt.md         # System prompt for AI safety game
│   └── www/
│       └── owl.png                     # Owl mascot image
├── .env.example                        # Environment variables template
├── .github/
│   └── workflows/
│       └── deploy-shinylive.yml        # GitHub Actions deployment workflow
├── GAME_CONCEPT.md                     # Task Decomposer game design
├── AI_SAFETY_GAME_CONCEPT.md          # Siren's Call game design
└── SIREN_COMPLETE_CONCEPT.md          # Complete AI safety game concept

```

## How It Works

1. **User Input**: You type your LLM prompt into the text box
2. **Analysis**: The app sends your prompt to Google Gemini along with a system prompt containing prompt engineering principles
3. **Feedback**: Gemini analyzes your prompt and provides:
   - A rating (1-5 mice)
   - What works well
   - One specific principle to improve
   - How to apply it
4. **Iteration**: Your prompt stays in the text box so you can refine it based on the feedback

## Technologies

- **Shiny**: R framework for building web applications
- **ellmer**: R package for interacting with LLMs (supports OpenAI, Anthropic, Google Gemini, and more)
- **Shinylive**: Converts Shiny apps to run entirely in the browser (no server needed)
- **Google Gemini**: Free-tier LLM API for prompt analysis
- **GitHub Pages**: Free static site hosting
- **GitHub Actions**: Automated deployment pipeline

## Cost

This app uses Google Gemini's free tier, which includes:
- 15 requests per minute
- 1 million tokens per minute
- 1,500 requests per day

Perfect for learning and experimentation!

## Future Game Concepts

This repository also includes designs for educational games:

- **Task Decomposer**: Teaches research administrators how to break complex jobs into automatable tasks
- **The Siren's Call**: An AI safety education tool with two modes:
  - **Oracle Mode**: Get warnings about AI misuse dangers before you start
  - **Quest Mode**: Interactive scenarios testing your ability to spot AI risks

See the concept documents in the repository root for details.

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new prompt engineering principles
- Improve the UI/UX
- Add new features

## License

[Add your license here]

## Acknowledgments

- Prompt engineering principles based on industry best practices
- Owl mascot design: [Credit if applicable]
