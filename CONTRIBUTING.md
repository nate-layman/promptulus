# Contributing to Promptulus

Thank you for your interest in contributing to Promptulus! We welcome contributions of all kinds, from bug reports to new features.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/promptulus.git
   cd promptulus
   ```

3. **Install the development version**:
   ```r
   devtools::load_all()
   ```

4. **Set up your environment**:
   ```bash
   cp .env.example .env
   # Edit .env and add your OpenAI API key
   ```

## Development Workflow

### Running the app locally

```r
library(promptulus)
run_promptulus()
```

### Running tests

```r
devtools::test()
```

### Checking code quality

```r
devtools::check()
```

## Areas for Contribution

### 1. New Prompting Techniques
Help us expand the list of prompting techniques by:
- Researching effective prompting strategies
- Writing clear explanations of new techniques
- Creating examples showing how the Genie misapplies them

### 2. Genie Responses
Make the Genie more entertaining and educational:
- Improve the system prompt to generate more creative misinterpretations
- Add more variety to the types of mistakes it makes
- Keep responses playful and educational

### 3. Coach Feedback
Improve the Coach's ability to teach:
- Enhance the coaching system prompt
- Better detection of missing techniques
- More personalized feedback examples

### 4. User Interface
Help improve the Shiny app:
- Better layout and design
- Improved accessibility
- Session history and saving sessions
- Progress tracking

### 5. Documentation
- Improve README and guides
- Add tutorials
- Create example prompts and scenarios
- Write API documentation

### 6. Bug Fixes
Report and fix issues:
- Find bugs and edge cases
- Test error handling
- Improve error messages

## Code Style

- Follow the [tidyverse style guide](https://style.tidyverse.org/)
- Use meaningful variable names
- Add roxygen2 documentation for exported functions
- Write clear commit messages

## Making a Pull Request

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** and commit with clear messages:
   ```bash
   git commit -m "Add feature: description of your change"
   ```

3. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request** on GitHub with:
   - Clear title describing the change
   - Description of what changed and why
   - Any related issues
   - Screenshots if UI changes

## Code Review

All contributions go through code review. We'll provide feedback and suggestions. Please be patient and open to discussion!

## Questions?

- Create an issue for bugs or feature requests
- Start a discussion for questions or ideas
- Check existing issues before creating new ones

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for making Promptulus better! 🧞✨
