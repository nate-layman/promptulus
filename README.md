# Promptulus: AI Prompting Learning Game

An interactive chatbot that teaches users how to write better AI prompts through playful feedback and constructive coaching.

## Features

- **Promptulus the Genie** 🧞: A playful character that misinterprets your prompts based on missing prompting techniques
- **Prompt Coach** 📚: Analyzes your prompts, identifies gaps, and suggests improvements
- **Iterative Learning**: Refine your prompts based on feedback and learn by doing
- **10 Core Techniques**: Learn proven prompting techniques that improve AI responses

## 🚀 Quick Start

### Prerequisites

- R 4.0 or higher
- OpenAI API key (set as `OPENAI_API_KEY` environment variable)

### Installation

```r
# Install dependencies
install.packages(c("shiny", "ellmer", "jsonlite", "glue", "shinycssloaders", "bslib"))

# Clone or download this repository
# Load the package
devtools::load_all()

# Run the app
run_promptulus()
```

### Running the App

```r
library(promptulus)
run_promptulus()
```

The app will open in your default browser at `http://localhost:3838`

## 📚 Prompting Techniques

The app teaches 10 core prompting techniques:

1. **Specify Role/Persona** – Tell AI what perspective to adopt
2. **Clarify Output Format** – Specify bullet list, table, paragraph, etc.
3. **Add Constraints** – Set length, style, or audience constraints
4. **Provide Context** – Give background or situation information
5. **Ask for Step-by-Step Reasoning** – Request structured reasoning
6. **Use Examples** – Show what kind of output you want
7. **Specify Tone or Style** – Define formal, humorous, poetic, etc.
8. **Define Audience** – Specify who the response is for
9. **Ask for Comparison/Analysis** – Request comparative or analytical thinking
10. **Break Down Complex Tasks** – Divide problems into parts or steps

## 🏗 Architecture

- **R + Shiny**: Interactive web application framework
- **{ellmer}**: Simplified OpenAI API integration
- **OpenAI GPT-4 Chat Model**: Powers both Genie and Coach personalities
- **{bslib}**: Modern UI theming and styling

## 📖 How It Works

1. **User Input**: Write a prompt for an AI task
2. **Genie Response**: The Genie intentionally misinterprets your prompt based on a missing technique
3. **Coach Feedback**: The Coach identifies which technique(s) are missing and explains how to apply them
4. **Iterate**: Refine your prompt and try again to get better results

## ⚙️ Configuration

Set your OpenAI API key:

```bash
export OPENAI_API_KEY="your-api-key-here"
```

Or create a `.env` file in the project root:

```
OPENAI_API_KEY=your-api-key-here
```

## 📝 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
