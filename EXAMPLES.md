# Promptulus: Learning Examples

This guide shows example prompts at different levels of sophistication, demonstrating how to apply the 10 prompting techniques.

## Example 1: Story Writing

### ❌ Initial Prompt (Missing Multiple Techniques)
```
Write a story about a robot
```

**Missing Techniques:**
- No role/persona
- No output format
- No constraints
- No tone specification
- No context

**Expected Genie Response:**
The Genie might write a 2,000-word epic poem in Old English about a sentient toaster, completely ignoring what you probably wanted!

---

### ✓ Improved Prompt (Adding Techniques)
```
Write a short story (500-750 words) for young adults about an AI robot
learning to feel emotions. Use a warm, hopeful tone with some humor.
The story should be divided into three sections: Discovery, Confusion,
and Acceptance. Set it in a near-future city and include dialogue.
```

**Techniques Applied:**
1. **Specify Role/Persona**: "for young adults" (defines audience perspective)
2. **Clarify Output Format**: "short story" with "three sections"
3. **Add Constraints**: "500-750 words", "warm, hopeful tone", "include dialogue"
4. **Provide Context**: "near-future city", "learning to feel emotions"
5. **Specify Tone/Style**: "warm, hopeful tone with some humor"

**Expected Result:**
Much better! The AI will write exactly what you want.

---

## Example 2: Code Review and Explanation

### ❌ Initial Prompt
```
Explain this JavaScript code to me
```

**Missing Techniques:**
- No role/persona
- No audience definition
- No constraints
- No context about what the code does

---

### ✓ Improved Prompt
```
Act as a senior JavaScript mentor explaining code to a junior developer
(someone with 1 year of experience). Here's my async function:

[CODE SAMPLE]

Please:
1. Explain what the function does in simple language
2. Break down each key part and why it's written that way
3. Identify any potential issues or improvements
4. Suggest one alternative approach

Keep your explanation to 3-4 paragraphs total. Use analogies where helpful.
```

**Techniques Applied:**
1. **Specify Role/Persona**: "senior JavaScript mentor"
2. **Define Audience**: "junior developer (1 year of experience)"
3. **Clarify Output Format**: Numbered steps with specific structure
4. **Add Constraints**: "3-4 paragraphs", use analogies
5. **Ask for Step-by-Step Reasoning**: Breaking down each part
6. **Ask for Comparison/Analysis**: Alternative approaches

---

## Example 3: Marketing Copy

### ❌ Initial Prompt
```
Write marketing copy for my app
```

**Missing Techniques:**
- No role/persona
- No context about the app
- No target audience
- No tone specification
- No output format

---

### ✓ Improved Prompt
```
Write a compelling product description for my fitness tracking app
that appeals to busy professionals (age 25-45) who want to get fit
but don't have much time.

The app includes: real-time workout tracking, AI-powered personalized
routines, social challenges, and integration with wearables.

Style: conversational and motivational, not corporate
Format: 2-3 short paragraphs (150-200 words total)
Tone: energetic but not pushy
Call-to-action: "Start your free 7-day trial"

Example of tone I like:
"Fit into your life, not the other way around."
```

**Techniques Applied:**
1. **Specify Role/Persona**: "product description writer"
2. **Define Audience**: "busy professionals age 25-45"
3. **Provide Context**: Features and benefits
4. **Clarify Output Format**: "2-3 paragraphs"
5. **Add Constraints**: "150-200 words", "energetic but not pushy"
6. **Specify Tone/Style**: "conversational and motivational"
7. **Use Examples**: Showing an example of desired tone

---

## Example 4: Data Analysis

### ❌ Initial Prompt
```
Analyze this data for me
```

---

### ✓ Improved Prompt
```
I have sales data for the last 12 months and need insights.

Data includes: Date, Product Category, Sales Amount, Region

Please analyze the data and:
1. Identify the top 3 performing categories
2. Highlight any seasonal patterns
3. Find the strongest and weakest performing regions
4. Suggest 2-3 actionable recommendations

Format your response as a brief report (300-400 words) with:
- Executive Summary (main findings in 2-3 sentences)
- Key Insights (bullet points)
- Recommendations (numbered list)

Tone: professional but accessible
Audience: non-technical business manager

Focus on actionable insights, not just numbers.
```

**Techniques Applied:**
1. **Provide Context**: What data you have and why
2. **Clarify Output Format**: "brief report" with specific sections
3. **Add Constraints**: "300-400 words", "professional but accessible"
4. **Ask for Step-by-Step Reasoning**: Numbered analysis steps
5. **Define Audience**: "non-technical business manager"
6. **Specify Tone/Style**: "professional but accessible"
7. **Use Examples**: Showing the structure you want

---

## Example 5: Learning Explanation

### ❌ Initial Prompt
```
Explain machine learning
```

---

### ✓ Improved Prompt
```
Explain machine learning to a beginner with no technical background.

Context: I'm a high school student interested in AI but have never coded.

Please explain:
1. What machine learning is (avoid jargon)
2. How it's different from regular programming
3. Real-world examples I might recognize

Format:
- Simple analogy comparing ML to learning (2-3 sentences)
- Key differences from programming (bullet points)
- 3 concrete real-world examples with brief explanations

Keep it under 300 words total. Use everyday language and relatable examples.

Example of level I want:
"Think of machine learning like teaching a friend to recognize dogs.
You don't give them a set of rules (the code), you just show them many
dog pictures until they learn to recognize them."
```

**Techniques Applied:**
1. **Define Audience**: "high school student with no technical background"
2. **Provide Context**: Why they're learning, their background
3. **Clarify Output Format**: Specific structure with sections
4. **Specify Tone/Style**: "everyday language", "relatable examples"
5. **Add Constraints**: "under 300 words", "avoid jargon"
6. **Use Examples**: Showing the level of explanation desired
7. **Ask for Step-by-Step Reasoning**: Specific things to cover

---

## Tips for Writing Better Prompts

1. **Start specific**: Don't be vague about what you want
2. **Add constraints**: Tell the AI the format, length, and tone
3. **Provide context**: What's the background? Who's the audience?
4. **Be explicit about format**: Don't make the AI guess
5. **Use examples**: Show, don't just tell
6. **Break down complex tasks**: Use step-by-step when things get complicated
7. **Define success**: What would a good response look like?

## Practice Exercise

Take this vague prompt and improve it by adding as many techniques as you can:

```
Tell me about climate change
```

**What to add:**
- Audience level?
- Output format?
- Specific focus areas?
- Tone/style?
- Length constraints?
- Perspective or role?

Try it in Promptulus and see how the Genie misinterprets the vague version,
then use the Coach's feedback to improve it step by step!

---

## Quick Reference

### Most Common Missing Techniques:
1. **No output format** - Vague about structure
2. **No audience definition** - Forget to specify who it's for
3. **No constraints** - Don't mention length, style, tone
4. **No context** - Assume the AI knows your situation
5. **No role/persona** - Don't specify perspective

### Most Impactful Techniques:
1. **Provide Context** - Game-changer for relevance
2. **Clarify Output Format** - Huge impact on usability
3. **Define Audience** - Guides tone and complexity
4. **Add Constraints** - Prevents rambling
5. **Use Examples** - Crystal clear communication

Happy prompting! 🧞✨
