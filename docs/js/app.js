import { characters, directFeedbackCharacters, getCharactersByPhase } from './characters.js';
import { initAPI, callGemini, buildSystemPrompt, loadContent } from './api.js';

// ===== STATE =====
let currentCharacter = null;
let conversationHistory = [];  // Array of {role: 'user'|'model', text: string}
let previousPrinciple = 'None';
let systemPromptCache = null;  // Cached system prompt for current character
let dialogosHistory = [];      // Array of {userInput, response}
let dialogosViewIndex = 0;     // 0 = live, 1..N = viewing historical turn

// ===== DOM REFS =====
const $ = (id) => document.getElementById(id);

// ===== INITIALIZATION =====
document.addEventListener('DOMContentLoaded', () => {
  // Modal
  $('dismiss-modal').addEventListener('click', () => {
    $('welcome-modal').style.display = 'none';
  });

  // API key input
  const apiKeyInput = $('api-key-input');
  apiKeyInput.addEventListener('input', () => {
    const key = apiKeyInput.value.trim();
    $('api-key-status').innerHTML = key
      ? '<i class="fa fa-check-circle"></i> Key entered'
      : '';
    if (key) initAPI(key);
  });

  // URL parameter for API key
  const params = new URLSearchParams(window.location.search);
  if (params.get('key')) {
    apiKeyInput.value = params.get('key');
    apiKeyInput.dispatchEvent(new Event('input'));
  }

  // Build landing page phase sections
  buildLandingPage();

  // Build character nav sidebar icons
  buildCharacterNav();

  // Sidebar toggle
  $('sidebar-toggle').addEventListener('click', toggleSidebar);

  // Send button
  $('send-btn').addEventListener('click', handleSend);

  // Reset button
  $('reset-btn').addEventListener('click', handleReset);

  // Enter key sends (Shift+Enter for newline)
  $('user-input').addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  });
});

// ===== LANDING PAGE =====
function buildLandingPage() {
  const phases = [
    {
      phase: 'before',
      title: 'Deciding to Use AI',
      description: "Before you get started, make sure you can clearly describe the task you want to do, know how to break it down into manageable subtasks, and whether AI is appropriate for the task at hand."
    },
    {
      phase: 'during',
      title: 'Using AI: Intent, Instructions, Information, Interaction',
      description: "Intent, instructions, information, and interaction all compete for the model's attention. Getting the balance right between these four is what separates useful AI output from noise."
    },
    {
      phase: 'after',
      title: 'Understanding AI',
      description: "AI can sound confident and still be wrong. These skills help you verify what it produced, document how you got there, and understand what's happening under the hood."
    }
  ];

  const container = $('phase-sections');
  for (const { phase, title, description } of phases) {
    const chars = getCharactersByPhase(phase);
    const section = document.createElement('div');
    section.className = 'phase-section';
    section.innerHTML = `
      <div class="phase-title">${title}</div>
      <p class="phase-description">${description}</p>
      <div class="character-cards">
        ${chars.map(ch => `
          <div class="character-card${ch.active ? '' : ' coming-soon'}"
               ${ch.active ? `onclick="window.selectCharacter('${ch.id}')"` : ''}
               title="${ch.nameOrigin}">
            ${ch.image
              ? `<img src="images/${ch.image}" alt="${ch.name}">`
              : '<div class="placeholder-img">?</div>'}
            <h4>${ch.name}</h4>
            <p class="card-skill">${ch.skillLabel}</p>
            <p class="card-description">${ch.skillDescription}</p>
            ${!ch.active ? '<div class="coming-soon-badge">Coming soon</div>' : ''}
          </div>
        `).join('')}
      </div>
    `;
    container.appendChild(section);
  }
}

// ===== CHARACTER NAV =====
function buildCharacterNav() {
  const nav = $('character-nav');
  const phases = [
    { phase: 'before', label: 'Deciding' },
    { phase: 'during', label: 'Using' },
    { phase: 'after', label: 'Checking' }
  ];

  // Home button
  const homeImg = document.createElement('img');
  homeImg.src = 'images/octopus.png';
  homeImg.className = 'home-icon';
  homeImg.title = 'Back to home';
  homeImg.addEventListener('click', goHome);
  nav.appendChild(homeImg);

  nav.appendChild(makeSeparator());

  for (let i = 0; i < phases.length; i++) {
    const { phase, label } = phases[i];
    const chars = getCharactersByPhase(phase);

    const groupLabel = document.createElement('span');
    groupLabel.className = 'nav-group-label';
    groupLabel.textContent = label;
    nav.appendChild(groupLabel);

    for (const ch of chars) {
      const icon = document.createElement('img');
      icon.src = `images/${ch.image}`;
      icon.className = `character-icon${ch.active ? '' : ' inactive'}`;
      icon.id = `icon-${ch.id}`;
      icon.title = `${ch.name}: ${ch.nameOrigin}`;
      if (ch.active) {
        icon.addEventListener('click', () => selectCharacter(ch.id));
      }
      nav.appendChild(icon);
    }

    if (i < phases.length - 1) {
      nav.appendChild(makeSeparator());
    }
  }
}

function makeSeparator() {
  const sep = document.createElement('div');
  sep.className = 'nav-separator';
  return sep;
}

// ===== NAVIGATION =====
// Expose globally for onclick attributes in HTML
window.selectCharacter = selectCharacter;

function selectCharacter(charId) {
  const config = characters[charId];
  if (!config || !config.active) return;

  currentCharacter = charId;
  conversationHistory = [];
  previousPrinciple = 'None';
  systemPromptCache = null;
  dialogosHistory = [];
  dialogosViewIndex = 0;

  // Switch views
  $('landing-view').style.display = 'none';
  $('character-view').style.display = 'block';
  $('sidebar-toggle').classList.remove('hidden');

  // Update character image
  $('character-image').src = `images/${config.image}`;
  $('character-image').alt = config.name;
  $('character-name-label').textContent = config.name;

  // Update gear
  const gearImg = $('gear-image');
  const gearContainer = $('loading-gear');
  if (config.gear) {
    gearImg.src = `images/${config.gear}`;
    gearImg.style.display = '';
  } else {
    gearImg.style.display = 'none';
  }

  // Reset gear classes
  gearContainer.className = 'loading-gear';
  if (config.gearClass) {
    gearContainer.classList.add(config.gearClass);
  }

  // Update greeting
  setBubbleText(config.greeting);

  // Update input placeholder
  $('user-input').placeholder = config.inputPlaceholder;
  $('user-input').value = '';

  // Show/hide reset button (only for guided learning)
  const isDirectFeedback = directFeedbackCharacters.includes(charId);
  $('reset-btn').style.display = isDirectFeedback ? 'none' : '';

  // Update active icon
  document.querySelectorAll('.character-icon').forEach(el => el.classList.remove('active'));
  const activeIcon = $(`icon-${charId}`);
  if (activeIcon) activeIcon.classList.add('active');

  // Load sidebar content
  loadSidebar(config);

  // Clear conversation nav
  $('conversation-nav-container').innerHTML = '';

  // Close sidebar
  $('sidebar').classList.remove('open');
}

function goHome() {
  currentCharacter = null;
  conversationHistory = [];
  systemPromptCache = null;
  dialogosHistory = [];
  dialogosViewIndex = 0;

  $('landing-view').style.display = 'block';
  $('character-view').style.display = 'none';
  $('sidebar-toggle').classList.add('hidden');
  $('sidebar').classList.remove('open');

  document.querySelectorAll('.character-icon').forEach(el => el.classList.remove('active'));
}

// ===== SIDEBAR =====
async function loadSidebar(config) {
  $('sidebar-title').textContent = config.sidebarTitle;
  $('sidebar-description').innerHTML = config.sidebarDescription;

  try {
    const guidelinesText = await loadContent(config.principlesFile);
    $('sidebar-guidelines').innerHTML = markdownToHTML(guidelinesText);
  } catch (e) {
    $('sidebar-guidelines').innerHTML = `<p style="color: red;">Error loading guidelines: ${e.message}</p>`;
  }
}

function toggleSidebar() {
  const sidebar = $('sidebar');
  const toggle = $('sidebar-toggle');
  sidebar.classList.toggle('open');
  toggle.querySelector('i').className = sidebar.classList.contains('open')
    ? 'fa fa-chevron-right'
    : 'fa fa-chevron-left';
}

// ===== SEND HANDLER =====
async function handleSend() {
  if (!currentCharacter) return;

  const input = $('user-input');
  const userPrompt = input.value.trim();
  if (!userPrompt) return;

  const apiKey = $('api-key-input').value.trim();
  if (!apiKey) {
    setBubbleText("Please enter your Gemini API key on the landing page (click the octopus to go back).");
    return;
  }

  initAPI(apiKey);

  const config = characters[currentCharacter];
  const isDirectFeedback = directFeedbackCharacters.includes(currentCharacter);

  // Snap Dialogos to live view
  if (currentCharacter === 'dialogos') {
    dialogosViewIndex = 0;
  }

  // Show loading
  $('loading-gear').classList.add('spinning');
  $('send-btn').disabled = true;

  try {
    // Build system prompt if needed
    if (isDirectFeedback || !systemPromptCache) {
      systemPromptCache = await buildSystemPrompt(
        config.systemPromptFile,
        config.principlesFile,
        previousPrinciple
      );
    }

    // For direct feedback: reset conversation each time
    if (isDirectFeedback) {
      conversationHistory = [];
    }

    // Call the API
    const response = await callGemini(
      systemPromptCache,
      conversationHistory,
      "Please review this prompt:\n\n" + userPrompt
    );

    // Update conversation history
    conversationHistory.push({ role: 'user', text: "Please review this prompt:\n\n" + userPrompt });
    conversationHistory.push({ role: 'model', text: response });

    // Store Dialogos history
    if (currentCharacter === 'dialogos') {
      dialogosHistory.push({ userInput: userPrompt, response: response });
      dialogosViewIndex = 0;
      renderConversationNav();
    }

    // Parse Sequita transparency zone
    if (currentCharacter === 'sequita') {
      const zoneMatch = response.match(/\[TRANSPARENCY: (high|low)\]/);
      let cleanResponse = response;
      let spectrumHtml = '';
      if (zoneMatch) {
        const zone = zoneMatch[1];
        cleanResponse = response.replace(/\s*\[TRANSPARENCY: [^\]]+\]\s*/g, '');
        spectrumHtml = buildSpectrumHTML(zone);
      }
      setBubbleText(cleanResponse + spectrumHtml);
    } else {
      setBubbleText(response);
    }

    // Track previous principle for direct feedback
    if (isDirectFeedback) {
      const principleMatch = response.match(/consider using the \*\*([^*]+)\*\*/);
      if (principleMatch) {
        previousPrinciple = principleMatch[1];
      }
    }

  } catch (e) {
    console.error('API error:', e);
    setBubbleText(`Error: ${e.message}`);
  } finally {
    $('loading-gear').classList.remove('spinning');
    $('send-btn').disabled = false;
  }
}

// ===== RESET =====
function handleReset() {
  if (!currentCharacter) return;

  conversationHistory = [];
  systemPromptCache = null;
  dialogosHistory = [];
  dialogosViewIndex = 0;

  const config = characters[currentCharacter];
  setBubbleText(config.greeting);
  $('user-input').value = '';
  $('conversation-nav-container').innerHTML = '';
}

// ===== CONVERSATION NAVIGATOR (Dialogos) =====
function renderConversationNav() {
  const container = $('conversation-nav-container');
  if (currentCharacter !== 'dialogos' || dialogosHistory.length === 0) {
    container.innerHTML = '';
    return;
  }

  const total = dialogosHistory.length;
  const isLive = dialogosViewIndex === 0;
  const displayTurn = isLive ? total : dialogosViewIndex;

  const entry = dialogosHistory[displayTurn - 1];
  const preview = entry.userInput.length > 50
    ? entry.userInput.substring(0, 50) + '...'
    : entry.userInput;

  container.innerHTML = `
    <div class="conversation-nav">
      <button class="nav-arrow" ${displayTurn <= 1 ? 'disabled' : ''} id="nav-prev">
        <i class="fa fa-chevron-left"></i>
      </button>
      <span class="nav-label">Turn ${displayTurn} of ${total}</span>
      <button class="nav-arrow" ${isLive ? 'disabled' : ''} id="nav-next">
        <i class="fa fa-chevron-right"></i>
      </button>
      ${!isLive ? '<span class="nav-context">Viewing history</span>' : ''}
    </div>
  `;

  // Bind nav buttons
  const prevBtn = $('nav-prev');
  const nextBtn = $('nav-next');
  if (prevBtn) prevBtn.addEventListener('click', () => navigateHistory(-1));
  if (nextBtn) nextBtn.addEventListener('click', () => navigateHistory(1));
}

function navigateHistory(direction) {
  if (dialogosHistory.length === 0) return;

  const total = dialogosHistory.length;
  const currentTurn = dialogosViewIndex === 0 ? total : dialogosViewIndex;

  if (direction === -1 && currentTurn > 1) {
    dialogosViewIndex = currentTurn - 1;
  } else if (direction === 1) {
    if (dialogosViewIndex === 0) return;
    if (dialogosViewIndex < total) {
      dialogosViewIndex = dialogosViewIndex + 1;
    } else {
      dialogosViewIndex = 0; // Back to live
    }
  }

  // Show the historical response
  const displayTurn = dialogosViewIndex === 0 ? total : dialogosViewIndex;
  const entry = dialogosHistory[displayTurn - 1];

  // Show user input header for Dialogos
  const historyHeader = `<div class="history-user-input">
    <div class="history-label">You said:</div>
    ${escapeHTML(entry.userInput)}
  </div>`;

  setBubbleHTML(historyHeader + formatResponse(entry.response));
  renderConversationNav();
}

// ===== TEXT FORMATTING =====
function setBubbleText(text) {
  $('bubble-text').innerHTML = formatResponse(text);
}

function setBubbleHTML(html) {
  $('bubble-text').innerHTML = html;
}

function formatResponse(text) {
  // Bold: **text** -> <strong>text</strong>
  let html = text.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
  // Newlines -> <br>
  html = html.replace(/\n/g, '<br>');
  return html;
}

function escapeHTML(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// ===== SPECTRUM VISUALIZATION (Sequita) =====
function buildSpectrumHTML(zone) {
  const pos = zone === 'high' ? '20%' : '80%';
  return `
    <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
      <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 5px; font-weight: bold;">
        <span>&larr; High Transparency</span><span>Low Transparency &rarr;</span>
      </div>
      <div style="position: relative; height: 30px; background: linear-gradient(to right, #e74c3c, #27ae60); border-radius: 15px;">
        <div style="position: absolute; left: ${pos}; top: -5px; transform: translateX(-50%);
          width: 20px; height: 40px; background: white; border: 3px solid #333; border-radius: 50%;"></div>
      </div>
      <div style="display: flex; justify-content: space-between; font-size: 11px; margin-top: 5px; color: #666;">
        <span>Show your work</span><span>Results matter, method doesn't</span>
      </div>
    </div>
  `;
}

// ===== SIMPLE MARKDOWN TO HTML =====
function markdownToHTML(md) {
  // Very basic markdown-to-HTML for the guidelines tables
  let html = '';
  const lines = md.split('\n');
  let inTable = false;
  let isHeaderRow = true;

  for (const line of lines) {
    const trimmed = line.trim();

    // Table rows
    if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
      // Skip separator rows like | :--- | :--- |
      if (/^\|[\s:|-]+\|$/.test(trimmed)) {
        continue;
      }

      if (!inTable) {
        html += '<table>';
        inTable = true;
        isHeaderRow = true;
      }

      const cells = trimmed.split('|').filter((_, i, arr) => i > 0 && i < arr.length - 1);
      const tag = isHeaderRow ? 'th' : 'td';
      html += '<tr>' + cells.map(c => `<${tag}>${formatCell(c.trim())}</${tag}>`).join('') + '</tr>';
      isHeaderRow = false;
      continue;
    }

    if (inTable) {
      html += '</table>';
      inTable = false;
    }

    // Headers
    if (trimmed.startsWith('### ')) {
      html += `<h3>${trimmed.substring(4)}</h3>`;
    } else if (trimmed.startsWith('## ')) {
      html += `<h2>${trimmed.substring(3)}</h2>`;
    } else if (trimmed.startsWith('# ')) {
      html += `<h1>${trimmed.substring(2)}</h1>`;
    } else if (trimmed) {
      html += `<p>${formatCell(trimmed)}</p>`;
    }
  }

  if (inTable) html += '</table>';
  return html;
}

function formatCell(text) {
  // Bold
  text = text.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
  // Italic
  text = text.replace(/\*([^*]+)\*/g, '<em>$1</em>');
  // Links
  text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>');
  return text;
}
