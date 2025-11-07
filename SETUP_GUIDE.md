# Setup Guide

## Getting Your Gemini API Key

### 1. Visit Google AI Studio
Go to [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)

### 2. Sign in with Google
Use your Google account to sign in.

### 3. Create API Key
- Click "Create API Key"
- Select "Create API key in new project" (or choose an existing project)
- Copy the generated API key

### 4. Keep it secure!
- Never commit your API key to git
- `.env` and `.Renviron` files are already in `.gitignore` to prevent this
- Don't share your API key publicly

## Local Development Setup

### Quick Start
```bash
# 1. Copy the example env file
cp .env.example .env

# 2. Edit .env and add your API key
# Replace 'your_api_key_here' with your actual key from Google AI Studio

# 3. Install R packages
# Open R or RStudio and run:
install.packages(c("shiny", "shinyjs", "bslib", "ellmer", "here", "rsconnect"))

# 4. Run the app
# In R console from project root:
shiny::runApp("app")
```

## shinyapps.io Deployment

Deploy your app to shinyapps.io to keep your API key secure on the server.

### Prepare for Deployment

Before deploying, set up your `.Renviron` file in the app folder:

```bash
# Copy the example file
cp app/.Renviron.example app/.Renviron

# Edit app/.Renviron and add your API key
# GEMINI_API_KEY=your_actual_api_key_here
```

**Important**: The `app/.Renviron` file will be deployed with your app to shinyapps.io and is how your app accesses the API key on the server.

### Create Account

1. Go to [shinyapps.io](https://www.shinyapps.io/)
2. Sign up for a free account
3. Free tier includes:
   - 5 applications max
   - 25 active hours/month
   - 1 GB RAM per app

### Configure rsconnect

1. Log in to [shinyapps.io](https://www.shinyapps.io/)
2. Click your name (top right) → **Tokens**
3. Click **Show** then **Show Secret**
4. Copy the entire command and run it in R:

   ```r
   rsconnect::setAccountInfo(name='your-name',
                             token='YOUR_TOKEN',
                             secret='YOUR_SECRET')
   ```

### Deploy

```r
# From the project root directory
rsconnect::deployApp(appDir = "app", appName = "promptulus")
```

First deployment takes a few minutes. Your app will be live at:
```
https://your-name.shinyapps.io/promptulus/
```

### Update Your App

After making changes:

```r
rsconnect::deployApp(appDir = "app", appName = "promptulus")
```

### Manage Apps

- **Dashboard**: [shinyapps.io/admin](https://www.shinyapps.io/admin/)
- **Logs**: Click your app → Logs tab
- **Usage**: Monitor active hours remaining
- **Archive**: Free up slots for new apps

## Troubleshooting

### "GEMINI_API_KEY not set" error locally
- Make sure you created the `.env` file (copy from `.env.example`)
- Make sure you added your actual API key (not the placeholder text)
- Restart your R session after editing `.env`

### Deployment fails in GitHub Actions
- Check that you added the `GEMINI_API_KEY` secret in GitHub Settings
- Check the Actions tab for error logs
- Make sure GitHub Pages is enabled with "GitHub Actions" as the source

### App loads but doesn't respond
- Check browser console for errors (F12 in most browsers)
- API key might be invalid or expired
- You might have hit the free tier rate limit (15 requests/minute)

### Rate limits
Gemini free tier limits:
- 15 requests per minute
- 1 million tokens per minute
- 1,500 requests per day

If you hit these limits, wait a few minutes and try again.

## Security Note

⚠️ **Important**: In the deployed shinylive version, the API key is embedded in the browser JavaScript. While obscured, it's technically visible to anyone who inspects the code.

For the free tier of Gemini, this is generally acceptable for educational/demo purposes. However, DO NOT:
- Use this approach for production apps
- Share sensitive data through the app
- Use a paid API key in a public deployment

For production, consider:
- Building a backend API that makes the Gemini calls
- Using environment variables on a proper server
- Implementing rate limiting and authentication

## Next Steps

Once your app is running:
1. Try submitting different prompts to see how Promptulus reviews them
2. Iterate on your prompts based on the feedback
3. Check out the game concepts in the repository for future features
4. Customize the prompt engineering principles in `app/prompting_guidelines.md`
5. Modify the system prompt in `app/promptulus_system_prompt.md` to change how Promptulus behaves

## Getting Help

If you run into issues:
1. Check this troubleshooting section
2. Review the GitHub Actions logs if deployment fails
3. Check the browser console if the app loads but doesn't work
4. Open an issue in the repository with:
   - What you were trying to do
   - What happened instead
   - Any error messages
   - Screenshots if helpful
