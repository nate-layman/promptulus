# Promptulus

Promptulus is an interactive Shiny app that reviews LLM prompts and helps you improve them using proven prompt engineering principles. The wise owl Promptulus rates your prompts (1-5 mice) and provides constructive feedback to make them more effective.

## Features

- **Prompt Review**: Submit your prompts and get immediate feedback
- **Rating System**: See how well your prompt scores (1-5 mice)
- **Actionable Suggestions**: Get specific improvements based on prompt engineering best practices
- **Iterative Learning**: Refine your prompts based on suggestions and resubmit

## Live Demo

Visit the deployed app: [Your shinyapps.io URL will appear here after deployment]

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

   For local development:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your API key:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

   For shinyapps.io deployment:
   ```bash
   cp app/.Renviron.example app/.Renviron
   ```
   Edit `app/.Renviron` and add your API key:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

4. **Install R dependencies**
   ```r
   install.packages(c("shiny", "shinyjs", "bslib", "ellmer", "here", "rsconnect"))
   ```

5. **Run the app**
   ```r
   # From R console in the project root
   shiny::runApp("app")
   ```

   Or in RStudio: Open `app/app.R` and click "Run App"

## Deployment to shinyapps.io

Deploy your app to shinyapps.io to keep your API key secure on the server (unlike browser-based solutions).

### Free Tier Limits

- **5 applications** max
- **25 active hours/month** (resets monthly)
- **1 GB RAM** per app
- Apps show "Powered by Posit" badge

### Setup & Deployment

1. **Create a shinyapps.io account**
   - Visit [shinyapps.io](https://www.shinyapps.io/)
   - Sign up for a free account

2. **Install rsconnect**
   ```r
   install.packages("rsconnect")
   ```

3. **Configure your account**
   - Log in to [shinyapps.io](https://www.shinyapps.io/)
   - Click your name (top right) → Tokens
   - Click "Show" then "Show Secret"
   - Copy the command that looks like:
     ```r
     rsconnect::setAccountInfo(name='your-name',
                               token='YOUR_TOKEN',
                               secret='YOUR_SECRET')
     ```
   - Run it in your R console

4. **Deploy your app**
   ```r
   # From the project root directory
   rsconnect::deployApp(appDir = "app", appName = "promptulus")
   ```

   The first deployment takes a few minutes. Subsequent updates are faster.

5. **Your app is live!**
   - Visit: `https://your-name.shinyapps.io/promptulus/`
   - Your API key stays secure on the server (in `.env`)

### Updating Your App

After making changes:

```r
# Redeploy with the same command
rsconnect::deployApp(appDir = "app", appName = "promptulus")
```

### Managing Your Apps

- **Dashboard**: [shinyapps.io/admin](https://www.shinyapps.io/admin/)
- **View logs**: Click your app → Logs tab
- **Monitor usage**: Check active hours remaining
- **Archive apps**: Free up slots for new apps

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
- **Google Gemini**: Free-tier LLM API for prompt analysis (Gemini 2.5 Flash)
- **shinyapps.io**: Free hosting for Shiny apps with secure environment variable handling
- **rsconnect**: R package for deploying to shinyapps.io

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
