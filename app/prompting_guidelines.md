## 🛠️ Actionable Prompt Engineering Principles for User Advice

| Advice Category | Principle (What to Do) | Why This Works (Benefit) | Recommended Prompt Phrase |
| :--- | :--- | :--- | :--- |
| **Level 1: Fundamentals (Clarity)** | **Be Specific & Constrained** | **Reduces ambiguity** and prevents irrelevant "hallucinated" answers. The model's focus is laser-sharp. | "Write a **5-point** summary of the key findings for a **marketing executive**." |
| | **Define the Role** | **Grounds the model's expertise** and ensures the tone/depth is appropriate for the task. | "Act as an **expert cybersecurity analyst**. Your goal is to..." |
| | **Specify the Target Audience** | Tailors the output's complexity, tone, and language to the intended reader. | "Explain this to a **non-technical executive**," or "Write for a **high school student**." |
| | **Use Delimiters** | **Prevents "prompt injection"** and clarifies which text is **instruction** versus **context/data**. | "Analyze the text within the triple backquotes: ```[text here]```" |
| **Level 2: Reasoning (Reliability)** | **Chain-of-Thought (CoT)** | **Increases accuracy** on complex logic, math, and reasoning tasks by forcing the model to slow down and verify steps. | "**Let's think step by step.** First, calculate X. Then, use that result to find Y." |
| | **Few-Shot Examples** | **Establishes a template** for the desired output format, tone, or style when a description is insufficient. | "Here is an example of the analysis I need: [Example 1]. Now, apply this pattern to the following data..." |
| | **Break Down Complex Tasks** | **Avoids context overload** and guides the model through a predictable, high-quality workflow (Prompt Chaining). | "Phase 1: Generate an outline for the proposal. **Do not write the content yet.**" |
| | **Explicit Output Format** | Request a machine-readable or highly predictable structure, crucial for automation and data extraction. | "Output a **JSON object** with keys 'summary' and 'steps'." |
| **Level 3: Advanced (Agentic Behavior)** | **Recursive Self-Improvement** | **Leverages the model's critique skills** to quickly move from a good draft to a great, finalized piece (Self-Correction). | "Write a first draft. **Then, critique the draft for clarity and tone, and provide the final, revised version.**" |
| | **Elicit Clarification** | **Ensures you provide all necessary context** by forcing the model to act as a *consultant* before answering. | "**Before providing the answer, ask me three clarifying questions** to ensure your response is perfectly targeted." |
| | **Tree-of-Thoughts (ToT)** | Guides the model to **explore multiple potential solutions** and self-evaluate intermediate steps, essential for planning and strategy. | "Generate **three different possible marketing slogans**. For each, provide a 2-sentence rationale before making the final selection." |
| | **Constitutional Prompting** | Embeds a fixed set of ethical, safety, or style rules that the model must constantly reference and adhere to. | "You **MUST** follow Rule #4: All statements must be free of technical jargon and must cite a source if factual." |
