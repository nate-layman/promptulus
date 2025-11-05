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
- The `.env` file is already in `.gitignore` to prevent this
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
install.packages(c("shiny", "shinyjs", "bslib", "ellmer", "here"))

# 4. Run the app
# In R console from project root:
shiny::runApp("app")
```

## GitHub Deployment Setup

### Quick Deploy Method (Recommended)

1. **Install shinylive**
   ```r
   install.packages("shinylive")
   ```

2. **Export your app**
   ```r
   # From R console
   shinylive::export("app", "docs")
   ```

3. **Embed API key for deployment**

   ⚠️ **Security Note**: For public deployment, your API key will be visible in the browser code. Only use free-tier keys!

   ```r
   # Backup your app first
   file.copy("app/app.R", "app/app.R.backup")

   # Read and modify
   app_code <- readLines("app/app.R")
   app_code <- gsub('Sys.getenv\\("GEMINI_API_KEY"\\)', '"your_actual_api_key_here"', app_code)
   writeLines(app_code, "app/app.R")

   # Export with embedded key
   shinylive::export("app", "docs")

   # Restore original
   file.copy("app/app.R.backup", "app/app.R", overwrite = TRUE)
   file.remove("app/app.R.backup")
   ```

4. **Enable GitHub Pages**
   - Go to repository **Settings** → **Pages**
   - Source: **Deploy from a branch**
   - Branch: **main**
   - Folder: **/docs**
   - Click **Save**

5. **Commit and push**
   ```bash
   git add docs/
   git commit -m "Add shinylive deployment"
   git push origin main
   ```

6. **Access your app**
   - Wait 1-2 minutes for GitHub Pages to deploy
   - Visit: `https://[your-username].github.io/[repo-name]/`

### Automated Deployment with GitHub Actions

Alternatively, use the included workflow:

1. **Add GitHub Secret**
   - Settings → Secrets and variables → Actions
   - New repository secret
   - Name: `GEMINI_API_KEY`
   - Value: Your API key

2. **Enable GitHub Pages**
   - Settings → Pages
   - Source: **Deploy from a branch**
   - Branch: **main**, Folder: **/docs**

3. **Push to trigger deployment**
   ```bash
   git push origin main
   ```

The workflow will automatically embed your key and export to docs/.

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
