// Gemini API bridge - uses @google/genai SDK loaded from CDN
let genAI = null;

export function initAPI(apiKey) {
  // Lazy import handled in callGemini
  genAI = { apiKey };
}

export function hasAPIKey() {
  return genAI !== null && genAI.apiKey;
}

/**
 * Call Gemini API with conversation history
 * @param {string} systemPrompt - The system prompt
 * @param {Array} conversationHistory - Array of {role: 'user'|'model', text: string}
 * @param {string} userMessage - The new user message
 * @returns {Promise<string>} The model's response text
 */
export async function callGemini(systemPrompt, conversationHistory, userMessage) {
  if (!genAI) {
    throw new Error('API key not set. Please enter your Gemini API key.');
  }

  const { GoogleGenAI } = await import('https://esm.run/@google/genai');
  const ai = new GoogleGenAI({ apiKey: genAI.apiKey });

  // Build contents array from conversation history
  const contents = [];
  for (const turn of conversationHistory) {
    contents.push({
      role: turn.role,
      parts: [{ text: turn.text }]
    });
  }

  // Add the new user message
  contents.push({
    role: 'user',
    parts: [{ text: userMessage }]
  });

  const response = await ai.models.generateContent({
    model: 'gemini-2.5-flash',
    contents: contents,
    config: {
      systemInstruction: systemPrompt
    }
  });

  return response.text;
}

/**
 * Load a markdown file from the content directory
 * @param {string} filename - The filename to load
 * @returns {Promise<string>} The file contents
 */
export async function loadContent(filename) {
  const response = await fetch(`content/${filename}`);
  if (!response.ok) {
    throw new Error(`Failed to load ${filename}: ${response.status}`);
  }
  return response.text();
}

/**
 * Build the full system prompt by loading template and injecting guidelines
 * @param {string} systemPromptFile - System prompt template filename
 * @param {string} principlesFile - Principles/guidelines filename
 * @param {string} previousPrinciple - Previous principle for direct feedback characters
 * @returns {Promise<string>} The assembled system prompt
 */
export async function buildSystemPrompt(systemPromptFile, principlesFile, previousPrinciple = 'None') {
  const [template, guidelines] = await Promise.all([
    loadContent(systemPromptFile),
    loadContent(principlesFile)
  ]);

  let prompt = template.replace('{{GUIDELINES}}', guidelines);
  prompt = prompt.replace('{{PREVIOUS_PRINCIPLE}}', previousPrinciple);

  return prompt;
}
