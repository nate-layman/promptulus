# 🔀 AI Task Decision Key
### Should this be an LLM task, a traditional data science task, or a hybrid?

Answer each question in order. Follow the “Yes” or “No” branch to the next step.

---

## 1. Problem Definition

**Q1:** Does the desired output primarily consist of *language*, *text interpretation*, or *semantic reasoning*?  
- **Yes →** Go to **Q2 (LLM leaning)**  
- **No →** Go to **Q3 (Structured data leaning)**  

**Q2:** Is the output expected to vary by context, tone, or human nuance (e.g., summarization, explanation, reasoning)?  
- **Yes →** **LLM-based approach**  
- **No →** Go to **Q4**

**Q3:** Is the output a *numeric value, class label, or structured decision* that can be compared to a ground truth?  
- **Yes →** **Traditional data science or ML**  
- **No →** Go to **Q5**

---

## 2. Data & Ground Truth

**Q4:** Do you have large, labeled datasets or clear evaluation metrics?  
- **Yes →** **Traditional data science**  
- **No →** Go to **Q6**

**Q5:** Is there *no single correct answer*, but rather a need for plausible reasoning or synthesis?  
- **Yes →** **LLM-based approach**  
- **No →** **Traditional data science**

**Q6:** Is your goal exploratory (e.g., ideation, summarization, prototyping, hypothesis generation)?  
- **Yes →** **LLM-based approach**  
- **No →** Go to **Q7**

---

## 3. Operational Characteristics

**Q7:** Must the process produce *identical, repeatable* results for audit or regulation?  
- **Yes →** **Traditional data science**  
- **No →** Go to **Q8**

**Q8:** Will the system operate at *very large scale* (e.g., millions of identical transactions)?  
- **Yes →** **Traditional data science**  
- **No →** Go to **Q9**

**Q9:** Will a human review, correct, or collaborate on outputs in real time?  
- **Yes →** **LLM-based or Hybrid approach**  
- **No →** Go to **Q10**

---

## 4. Evaluation & Integration

**Q10:** Can you define objective numeric metrics for success (accuracy, recall, error)?  
- **Yes →** **Traditional data science**  
- **No →** Go to **Q11**

**Q11:** Can performance be evaluated by *subjective quality* or *human judgment* (e.g., clarity, persuasiveness)?  
- **Yes →** **LLM-based or Hybrid approach**  
- **No →** **Traditional data science**

---

## 5. Strategic Considerations

**Q12:** Would combining both approaches (e.g., ML → LLM → ML) provide complementary strengths?  
- **Yes →** **Hybrid system**  
- **No →** Go to **Q13**

**Q13:** Do you expect the task definition or data format to evolve frequently?  
- **Yes →** **LLM-based approach (more adaptable)**  
- **No →** **Traditional data science (more stable)**

---

### ✅ Summary Outcomes

| Path Result | When to Use |
| :--- | :--- |
| **LLM-based** | When the problem involves language, ambiguous reasoning, creativity, or semantic understanding. |
| **Traditional Data Science** | When the problem has numeric data, clear metrics, and a need for reproducibility or scalability. |
| **Hybrid** | When structured analytics and generative reasoning complement each other (e.g., ML feature extraction + LLM interpretation). |
