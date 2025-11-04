# Promptulus Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Get Your OpenAI API Key

1. Go to [OpenAI API Keys](https://platform.openai.com/account/api-keys)
2. Create a new API key
3. Copy it (you'll use it in the next step)

### Step 2: Set Up Environment

Create a `.env` file in the project root with your API key:

```bash
echo "OPENAI_API_KEY=sk-your-key-here" > .env
```

Replace `sk-your-key-here` with your actual API key.

Or set it directly in R:
```r
Sys.setenv(OPENAI_API_KEY = "sk-your-key-here")
```

### Step 3: Install Dependencies

```r
install.packages(c("shiny", "bslib", "shinyjs", "openai", "jsonlite", "glue", "devtools"))
```

### Step 4: Load and Run

```r
# Set working directory to the project
setwd("path/to/promptulus")

# Load the package
devtools::load_all()

# Run the app
library(promptulus)
run_promptulus()
```

The app will open in your browser at `http://localhost:3838`

## ✨ What You'll See

### Main Interface
- **Left Sidebar**: Write your prompt in the text area
- **Main Panel**: Two tabs for Genie and Coach feedback
- **Learning Tab**: Browse all 10 prompting techniques

### How It Works

1. **Write** a prompt (start simple, like "Write a story")
2. **Click** "Ask the Genie" button
3. **Watch** the Genie misinterpret your prompt playfully
4. **Read** the Coach's feedback on what technique could help
5. **Improve** your prompt based on the feedback
6. **Iterate** until you get great results!

## 📚 The 10 Techniques

1. **Specify Role/Persona** - Define the AI's perspective
2. **Clarify Output Format** - Say bullet points, tables, etc.
3. **Add Constraints** - Specify length, style, tone
4. **Provide Context** - Give background information
5. **Step-by-Step Reasoning** - Ask for structured thinking
6. **Use Examples** - Show what you want
7. **Specify Tone/Style** - Formal, funny, casual, etc.
8. **Define Audience** - Who is this for?
9. **Comparison/Analysis** - Ask for pros/cons
10. **Break Down Tasks** - Divide into smaller parts

## 🎮 Example Prompts to Try

### Start Simple
```
Write a story about a robot
```
*Watch the Genie misinterpret this!*

### Then Improve It
```
Write a short story (500 words) for teenagers about an AI robot
learning emotions. Use a hopeful, warm tone with humor. Include
dialogue. Format: three sections (Discovery, Confusion, Acceptance).
```
*See how much better this works!*

### More Examples
See `EXAMPLES.md` for 5 complete before/after examples.

## ⚠️ Troubleshooting

### "OPENAI_API_KEY not set"
- Make sure you created the `.env` file correctly
- Or set it in R: `Sys.setenv(OPENAI_API_KEY = "sk-...")`
- Restart R after changing

### "Could not find Shiny app files"
- Make sure you're in the project directory
- Check that `inst/shiny-app/` folder exists

### "Failed to initialize API client"
- Check your API key is valid
- Verify your OpenAI account has credit
- Check your internet connection

### App starts but Genie/Coach don't respond
- Check that your API key is correct
- Verify you have GPT-4 access
- Check OpenAI status: https://status.openai.com/

## 📖 Learn More

- **[Full Setup Guide](SETUP.md)** - Detailed installation
- **[Examples](EXAMPLES.md)** - Real-world prompting examples
- **[Contributing](CONTRIBUTING.md)** - Help improve Promptulus
- **[README](README.md)** - Project overview

## 💡 Tips for Success

1. **Start vague** - See how Genie misinterprets it
2. **Read Coach feedback** - Learn which techniques help most
3. **Iterate slowly** - Add one technique at a time
4. **Notice patterns** - Some techniques matter more than others
5. **Experiment** - Try different combinations

## 🧞 Meet Your Teachers

- **The Genie** - Playful, mischievous, intentionally misinterprets
- **The Coach** - Supportive, educational, guides your improvement

## 🎯 Your Learning Path

```
Simple Prompt
    ↓
Genie Misinterprets
    ↓
Coach Explains Missing Technique
    ↓
You Add That Technique
    ↓
Better Result!
    ↓
Repeat → Master Prompting
```

## ✅ Ready to Start?

1. Set your API key in `.env`
2. Run `devtools::load_all()` and `run_promptulus()`
3. Write your first prompt
4. Watch the Genie work
5. Learn from the Coach
6. Start prompting like a pro!

Happy prompting! 🧞✨
