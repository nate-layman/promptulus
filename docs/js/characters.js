// Character configuration - mirrors the R character_config list
export const characters = {
  sequita: {
    name: "Sequita",
    displayName: "Sequita (When to Use AI)",
    image: "squirrel.png",
    gear: "squirrel_gear.png",
    gearClass: "sequita-gear",
    inputPlaceholder: "Describe a task you're considering using AI for...",
    greeting: "Hello! I am Sequita. Tell me what you're working on and I'll teach you about auditability. Does your task need a clear paper trail, or is a good answer all that matters? Click the arrow to my right for more information.",
    principlesFile: "task_categorization_principles.md",
    systemPromptFile: "sequita_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Sequita",
    sidebarDescription: `<p>Sequita helps you determine whether <strong>auditability</strong> matters for your task.</p>
      <p>The key question: <em>Do you need to understand the cause, or just the effect?</em></p>
      <p>Think of it like forecasting: sometimes you need to know <em>why</em> a prediction was right: what assumptions were made, whether the reasoning holds for new situations. Other times you just need an accurate forecast and the inner workings don't matter.</p>
      <p>Type your task description, click Send, and the squirrel will:</p>
      <ul>
        <li>Assess whether your task needs high or low auditability</li>
        <li>Explain what that means for choosing tools and methods</li>
      </ul>
      <p>Describe different tasks to explore how auditability needs change across your work.</p>`,
    active: true,
    phase: "before",
    skillLabel: "Should I use AI?",
    skillDescription: "Auditability: Some tasks need a clear paper trail; others just need a good answer. Knowing the difference keeps you out of trouble.",
    nameOrigin: "From Latin 'sequi' (to follow/trace), tracing the reasoning behind a result"
  },
  modulus: {
    name: "Modulus",
    displayName: "Modulus (Task Decomposition)",
    image: "crab.png",
    gear: "crab_gear.png",
    gearClass: "modulus-gear",
    inputPlaceholder: "Paste a complex prompt or describe a multi-step task...",
    greeting: "Hello! I am Modulus. Show me your complex prompt and I'll help you break it into manageable, modular pieces! You can also click the arrow to my right for more information.",
    principlesFile: "modularization_principles.md",
    systemPromptFile: "modulus_system_prompt.md",
    ratingIcon: "shrimp",
    sidebarTitle: "About Modulus",
    sidebarDescription: `<p>Modulus helps you break down complex prompts into modular workflows.</p>
      <p>Type your prompt in the text box, click Send, and the crab will:</p>
      <ul>
        <li>Rate your prompt with 1-5 shrimp (5 = perfect discrete chunk, 1 = too complex)</li>
        <li>Identify where complexity emerges</li>
        <li>Suggest how to modularize your task into manageable steps</li>
      </ul>
      <p>Your prompt stays in the text box so you can iterate and refine it based on the suggestions.</p>`,
    active: true,
    phase: "before",
    skillLabel: "How do I break this down?",
    skillDescription: "Decomposition: Complex tasks overwhelm AI. Breaking them into steps gets better results and lets you catch errors early.",
    nameOrigin: "From Latin 'modulus' (small measure), breaking big problems into measured pieces"
  },
  telosa: {
    name: "Telosa",
    displayName: "Telosa (Intent Engineering)",
    image: "turtle.png",
    gear: "turtle_gear.png",
    gearClass: "telosa-gear",
    inputPlaceholder: "What are you trying to accomplish with AI? Describe your goal...",
    greeting: "Hello. I am Telosa. Tell me what you're working on and I'll help you think through your intent: what you actually need, who's accountable, and what happens if things don't go as planned. Click the arrow to my right for more information.",
    principlesFile: "intent_engineering_principles.md",
    systemPromptFile: "telosa_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Telosa",
    sidebarDescription: `<p>Telosa helps you define your <strong>intent</strong> before you start working with AI.</p>
      <p>The most important prompt engineering happens before anyone writes a prompt.</p>
      <p>Type your task description, click Send, and the turtle will help you clarify:</p>
      <ul>
        <li>What are you actually trying to accomplish?</li>
        <li>Who is accountable for the result?</li>
        <li>What are the escape hatches if AI fails?</li>
        <li>What boundaries should AI respect?</li>
      </ul>
      <p>Describe different tasks to explore how intent needs change across your work.</p>`,
    active: true,
    phase: "during",
    skillLabel: "What's my intent?",
    skillDescription: "Intent: Without clear intent, AI may take shortcuts you never intended, including unsafe ones. Define the goal and the guardrails.",
    nameOrigin: "From Greek 'telos' (\u03c4\u03ad\u03bb\u03bf\u03c2), meaning purpose, end, goal"
  },
  mnemos: {
    name: "Mnemos",
    displayName: "Mnemos (Context Engineering)",
    image: "elephant.png",
    gear: null,
    gearClass: null,
    inputPlaceholder: "Describe your task and what documents or data you plan to give the AI...",
    greeting: "Hello! I am Mnemos. Tell me what you're working on and I'll help you think about what information the AI needs, and just as importantly, what to leave out. For example, each character on this site gets the information in their sidebar as context! Click the arrow to my right to see mine.",
    principlesFile: "context_engineering_principles.md",
    systemPromptFile: "mnemos_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Mnemos",
    sidebarDescription: `<p>Mnemos helps you manage <strong>what information</strong> the AI can see.</p>
      <p>The key insight: AI's context window is like a desk with limited space. Everything you include competes for attention.</p>
      <p>Type your task description, click Send, and the elephant will help you think about:</p>
      <ul>
        <li>What information the AI needs that it doesn't already know</li>
        <li>How to organize and prioritize your context</li>
        <li>What to leave out to keep the AI focused</li>
      </ul>
      <p>Describe different tasks to explore how context needs change across your work.</p>`,
    active: true,
    phase: "during",
    skillLabel: "What does the AI need to know?",
    skillDescription: "Information: Don't rely on the model's general knowledge. Give it the specific context it needs. But don't overwhelm it with everything either. Curate what matters.",
    nameOrigin: "From Greek 'mneme' (\u03bc\u03bd\u03ae\u03bc\u03b7), meaning memory. The elephant never forgets."
  },
  promptulus: {
    name: "Promptulus",
    displayName: "Promptulus (Prompt Engineering)",
    image: "owl.png",
    gear: "owl_gear.png",
    gearClass: null,
    inputPlaceholder: "Paste a prompt you'd like reviewed...",
    greeting: "Hello! I am Promptulus. Give me your prompt and I'll review it! You can also click the arrow to my right for more information.",
    principlesFile: "prompting_principles.md",
    systemPromptFile: "promptulus_system_prompt.md",
    ratingIcon: "mice",
    sidebarTitle: "About Promptulus",
    sidebarDescription: `<p>Promptulus reviews your LLM prompts and helps you improve them.</p>
      <p>Type your prompt in the text box, click Send, and the owl will:</p>
      <ul>
        <li>Rate your prompt (1-5 mice, where 5 is excellent)</li>
        <li>Provide constructive feedback</li>
        <li>Suggest improvements based on proven prompt engineering principles</li>
      </ul>
      <p>Your prompt stays in the text box so you can iterate and refine it based on the suggestions.</p>`,
    active: true,
    phase: "during",
    skillLabel: "How do I ask?",
    skillDescription: "Instructions: How you phrase a request dramatically changes what you get back. Small wording changes yield big differences.",
    nameOrigin: "From Latin 'promptus' (ready, prepared), preparing effective requests"
  },
  dialogos: {
    name: "Dialogos",
    displayName: "Dialogos (Conversation Management)",
    image: "parrot.png",
    gear: null,
    gearClass: null,
    inputPlaceholder: "Describe your task and how you plan to interact with the AI (single prompt? back-and-forth?)...",
    greeting: "Hello! I am Dialogos. Tell me what you're working on and I'll help you think about managing the back-and-forth: when to continue, when to start fresh, and how to keep the conversation productive. Click the arrow to my right for more information.",
    principlesFile: "conversation_management_principles.md",
    systemPromptFile: "dialogos_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Dialogos",
    sidebarDescription: `<p>Dialogos teaches you to manage <strong>multi-turn conversations</strong> with AI.</p>
      <p>The key insight: every message stays in the AI's memory, and old instructions compete with new ones.</p>
      <p>Type your task description, click Send, and the parrot will help you think about:</p>
      <ul>
        <li>Whether to continue a conversation or start fresh</li>
        <li>How to manage instruction drift and contradictions</li>
        <li>When single-turn vs multi-turn works best</li>
      </ul>
      <p>Describe different tasks to explore how conversation needs change across your work.</p>`,
    active: true,
    phase: "during",
    skillLabel: "How do I manage the conversation?",
    skillDescription: "Interaction: Every exchange shapes what the model remembers. Knowing when to continue, reset, or restructure keeps your AI sharp instead of confused.",
    nameOrigin: "From Greek 'dialogos' (\u03b4\u03b9\u03ac\u03bb\u03bf\u03b3\u03bf\u03c2), meaning conversation, dialogue"
  },
  vitrea: {
    name: "Vitrea",
    displayName: "Vitrea (AI Transparency)",
    image: "frog.png",
    gear: null,
    gearClass: null,
    inputPlaceholder: "Ask me about how AI models work, environmental impact, data privacy, or anything else you're curious about...",
    greeting: "Hello! I am Vitrea. Ask me about how AI models actually work - tokenization, prediction, environmental impact, where your data goes, or anything else you're curious about. I'll explain it in plain language. Click the arrow to my right for more information about the topics I can help you with.",
    principlesFile: "ai_transparency_principles.md",
    systemPromptFile: "vitrea_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Vitrea",
    sidebarDescription: `<p>Vitrea helps you understand <strong>how AI actually works</strong> under the hood.</p>
      <p>The key insight: you don't need to be an engineer, but you should know enough to make informed decisions about when and how to use AI.</p>
      <p>Ask Vitrea about any topic and the glass frog will explain it clearly:</p>
      <ul>
        <li>How models turn text into tokens and predict responses</li>
        <li>Why AI can sound confident while being completely wrong</li>
        <li>Where your data goes when you use AI tools</li>
        <li>The environmental impact of AI use</li>
        <li>Open vs closed models, bias, and reasoning</li>
      </ul>
      <p>Ask whatever you're curious about - Vitrea will point you to resources for deeper exploration.</p>`,
    active: true,
    phase: "after",
    skillLabel: "How does AI actually work?",
    skillDescription: "Transparency: You don't need to be an engineer, but you should understand enough about how AI works to make good decisions about when and how to use it.",
    nameOrigin: "From Latin 'vitreus' (glass, transparent), seeing clearly through to the inner workings"
  },
  veridex: {
    name: "Veridex",
    displayName: "Veridex (Evaluation)",
    image: "raccoon.png",
    gear: null,
    gearClass: null,
    inputPlaceholder: "Tell me what you're working on or what AI produced for you...",
    greeting: "Hello! I am Veridex. Tell me what you're working on and I'll teach you what can go wrong with AI output, and how to catch it. Trust but verify! Click the arrow to my right for more information.",
    principlesFile: "evaluation_principles.md",
    systemPromptFile: "veridex_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Veridex",
    sidebarDescription: `<p>Veridex helps you <strong>evaluate</strong> AI output for accuracy and quality.</p>
      <p>The key insight: AI can sound confident and still be completely wrong.</p>
      <p>Type your task description, click Send, and the raccoon will help you think about:</p>
      <ul>
        <li>How to verify facts vs just checking fluency</li>
        <li>Where to watch for hallucinations</li>
        <li>How to match evaluation rigor to stakes</li>
      </ul>
      <p>Describe different tasks to explore how evaluation needs change across your work.</p>`,
    active: true,
    phase: "after",
    skillLabel: "Is the output good?",
    skillDescription: "Evaluation: AI can sound confident and still be wrong. Systematic evaluation catches errors before they become someone else's problem.",
    nameOrigin: "From Latin 'verus' (true) + 'index' (pointer), pointing to the truth"
  },
  clarion: {
    name: "Clarion",
    displayName: "Clarion (Reporting)",
    image: "whale.png",
    gear: null,
    gearClass: null,
    inputPlaceholder: "Tell me what you're working on or how you used AI...",
    greeting: "Hello! I am Clarion. Tell me what you're working on and I'll help you think about documenting your AI-assisted work. If you can't explain how you got here well enough for someone to reproduce your work, you're not done yet. Particularly since that someone will probably just end up being you in the future! Click the arrow to my right for more information.",
    principlesFile: "reporting_principles.md",
    systemPromptFile: "clarion_system_prompt.md",
    ratingIcon: "none",
    sidebarTitle: "About Clarion",
    sidebarDescription: `<p>Clarion helps you <strong>document, report, and build accountability</strong> for your AI-assisted work.</p>
      <p>The key insight: documentation isn't just good practice - it's your protection. If something goes wrong but you followed your institution's guidelines and recorded your process, you have evidence of due diligence. Undocumented work can't be defended, improved, or replicated.</p>
      <p>Type your task description, click Send, and the whale will help you think about:</p>
      <ul>
        <li>What to disclose about AI use and when</li>
        <li>How to document prompts, context, and changes</li>
        <li>Matching documentation depth to stakes</li>
        <li>Building a paper trail that demonstrates responsible use</li>
      </ul>
      <p>Describe different tasks to explore how documentation needs change across your work.</p>`,
    active: true,
    phase: "after",
    skillLabel: "Can I explain what I did?",
    skillDescription: "Accountability: Clarion teaches the white whale of AI skills: documenting what you've done well enough that your work can be reproduced. Documenting what you did also protects you. If something goes wrong but you followed guidelines and recorded your process you have a paper trail showing due diligence.",
    nameOrigin: "From Latin 'clarus' (clear) + clarion (a trumpet), broadcasting findings so they can't be missed"
  }
};

// Characters that get a fresh chat each send (direct feedback pattern)
export const directFeedbackCharacters = ['promptulus', 'modulus'];

// Get active characters
export function getActiveCharacters() {
  return Object.entries(characters)
    .filter(([, cfg]) => cfg.active)
    .map(([id]) => id);
}

// Get characters by phase
export function getCharactersByPhase(phase) {
  return Object.entries(characters)
    .filter(([, cfg]) => cfg.phase === phase)
    .map(([id, cfg]) => ({ id, ...cfg }));
}
