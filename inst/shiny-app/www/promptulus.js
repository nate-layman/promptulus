// Promptulus JavaScript interactions

// Smooth scroll to feedback when it appears
function scrollToFeedback() {
  const feedbackSection = document.querySelector('[data-value="Feedback"]');
  if (feedbackSection) {
    feedbackSection.scrollIntoView({ behavior: 'smooth' });
  }
}

// Add visual feedback when form is submitted
document.addEventListener('DOMContentLoaded', function() {
  const submitBtn = document.getElementById('submit_prompt');
  if (submitBtn) {
    submitBtn.addEventListener('click', function() {
      // Add a small animation to show it was clicked
      this.style.opacity = '0.8';
      setTimeout(() => {
        this.style.opacity = '1';
      }, 200);
    });
  }

  // Auto-focus on textarea when page loads
  const promptInput = document.getElementById('user_prompt');
  if (promptInput) {
    promptInput.focus();
  }
});

// Clipboard functionality for sharing
function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(function() {
    console.log('Copied to clipboard');
  }, function(err) {
    console.error('Could not copy text: ', err);
  });
}

// Keyboard shortcut for submitting prompt (Ctrl/Cmd + Enter)
document.addEventListener('keydown', function(event) {
  if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
    const submitBtn = document.getElementById('submit_prompt');
    if (submitBtn && document.activeElement.id === 'user_prompt') {
      submitBtn.click();
    }
  }
});
