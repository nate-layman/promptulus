# Instructions for AI Assistants

## General Guidelines

**DO NOT make radical changes without explicit approval first.**

When the user asks for a change (like "switch to Gemini"), follow this process:

1. **Research first** - Look up documentation, check existing libraries, understand what's already available
2. **Propose the approach** - Explain what you plan to do and why
3. **Wait for approval** - Get confirmation before making major changes
4. **Then implement** - Make the changes once approved

## What Counts as "Radical Changes"

- Replacing entire libraries or dependencies
- Rewriting core functionality from scratch
- Changing fundamental architecture
- Removing existing working code to replace with something completely different

## Better Approach

Instead of immediately replacing `ellmer` with `httr` + `jsonlite`:

❌ **Wrong:**
```
"ellmer doesn't support Gemini, so I'll replace it with direct HTTP calls"
```

✅ **Right:**
```
"Let me check the ellmer documentation to see if it supports Gemini...
[search results show chat_google_gemini() exists]
Great! ellmer already has Gemini support. I'll use chat_google_gemini() instead of chat_openai(). Here's what I'll change: [explain changes]. Does that look good?"
```

## Key Principle

**Assume existing libraries have more functionality than you initially think.**

Before replacing or removing code:
- Check documentation
- Search for examples
- Look at the package's GitHub/CRAN page
- Ask the user if you're unsure

## When in Doubt

If you're not sure whether a change is "radical":
- Describe what you're planning to do
- Explain the trade-offs
- Ask for confirmation
- Then proceed

Thank you for being thoughtful and careful with changes!
