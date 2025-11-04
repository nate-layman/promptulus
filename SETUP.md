# Promptulus Setup Guide

## Prerequisites

- **R 4.0 or higher** - [Download R](https://www.r-project.org/)
- **RStudio** (optional but recommended) - [Download RStudio](https://posit.co/download/rstudio-desktop/)
- **OpenAI API Key** - [Get your key](https://platform.openai.com/account/api-keys)

## Installation

### Option 1: Quick Start (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/promptulus.git
   cd promptulus
   ```

2. **Run the setup script**:
   ```bash
   # In terminal/bash
   Rscript run_app.R
   ```

   Or in R:
   ```r
   source("run_app.R")
   ```

3. **Follow the prompts** to enter your OpenAI API key

### Option 2: Manual Installation

1. **Clone the repository** as above

2. **Install dependencies** in R:
   ```r
   install.packages(c("shiny", "bslib", "shinyjs", "ellmer", "jsonlite", "glue"))
   ```

3. **Create a `.env` file**:
   ```bash
   cp .env.example .env
   ```

4. **Edit `.env`** and add your API key:
   ```
   OPENAI_API_KEY=sk-your-api-key-here
   ```

5. **Load and run the app** in R:
   ```r
   devtools::load_all()
   library(promptulus)
   run_promptulus()
   ```

### Option 3: From GitHub with devtools

```r
# Install devtools if needed
install.packages("devtools")

# Install promptulus
devtools::install_github("your-username/promptulus")

# Load the package
library(promptulus)

# Set your API key
Sys.setenv(OPENAI_API_KEY = "sk-your-api-key-here")

# Run the app
run_promptulus()
```

## Configuration

### Setting Your API Key

**Method 1: Environment Variable (One-time)**
```r
Sys.setenv(OPENAI_API_KEY = "sk-your-api-key-here")
```

**Method 2: .env File (Persistent)**
```bash
echo "OPENAI_API_KEY=sk-your-api-key-here" > .env
```

**Method 3: .Renviron File (Global)**
```bash
echo "OPENAI_API_KEY=sk-your-api-key-here" >> ~/.Renviron
```
Then restart R.

### Optional Configuration

You can customize the API model used by editing the `init_api_client()` function in `R/utils.R`:

```r
client <- ellmer::chat_openai(
  api_key = api_key,
  model = "gpt-4-turbo"  # or "gpt-4", "gpt-3.5-turbo", etc.
)
```

## Running the App

Once set up, start the app with:

```r
library(promptulus)
run_promptulus()
```

The app will:
1. Launch in your default web browser
2. Run locally at `http://localhost:3838`
3. Stay running until you stop it in the R console

To stop: Press `Ctrl+C` in the R console

## Troubleshooting

### "OPENAI_API_KEY not set"
- **Solution**: Follow the "Setting Your API Key" section above
- Make sure you've set the environment variable correctly
- Restart R after setting the key in `.Renviron`

### "Could not find Shiny app files"
- **Solution**: Make sure you're in the project directory when running the app
- Verify that `inst/shiny-app/` exists and contains `app.R`, `ui.R`, and `server.R`

### "Failed to initialize API client"
- **Solution**: Check your API key is valid
- Verify your OpenAI account has available credits
- Check your internet connection

### App loads but Genie/Coach don't respond
- **Solution**: Check that `ellmer` package is properly installed
- Verify your API key has access to GPT-4
- Check OpenAI status page for service issues

### Port 3838 already in use
- **Solution**: Specify a different port:
  ```r
  run_promptulus(port = 3839)
  ```

## Development Setup

For contributing to Promptulus:

```r
# Load the package in development mode
devtools::load_all()

# Run tests
devtools::test()

# Check the package
devtools::check()

# Build documentation
devtools::document()
```

## Next Steps

1. **[Learn how to use Promptulus](README.md#how-it-works)**
2. **[Understand the prompting techniques](inst/shiny-app/ui.R#L81-L83)**
3. **[Contribute to the project](CONTRIBUTING.md)**

## Getting Help

- **Issues**: [Report bugs or request features](https://github.com/your-username/promptulus/issues)
- **Discussions**: [Ask questions and share ideas](https://github.com/your-username/promptulus/discussions)
- **Email**: Contact the maintainers

## API Keys and Security

- **Never commit** your `.env` file to git (it's in `.gitignore`)
- **Rotate keys** if they're ever exposed
- **Use environment variables** in production
- **Delete unused keys** from your OpenAI account

Happy prompting! 🧞✨
