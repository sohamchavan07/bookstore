// Devise auth page JS helpers (extracted from inline templates)
function safeGet(id) {
  try { return document.getElementById(id); } catch { return null; }
}

export function lsuUpdateStrength(v) {
  const bars = [
    document.getElementById("lsu-s1"),
    document.getElementById("lsu-s2"),
    document.getElementById("lsu-s3"),
    document.getElementById("lsu-s4")
  ].filter(Boolean);
  let score = 0;
  if (v.length >= 8) score++;
  if (v.length >= 12) score++;
  if (/[A-Z]/.test(v) && /[0-9]/.test(v)) score++;
  if (/[^A-Za-z0-9]/.test(v)) score++;
  bars.forEach((bar, i) => bar.classList.toggle("lsu-active", i < score));
  const labels = ["8 characters minimum", "Weak", "Fair", "Good", "Strong"];
  const label = document.getElementById("lsu-slabel");
  if (label) label.textContent = labels[score];
}

export function lsuTogglePassword() {
  const input = safeGet("lsu-pw");
  const button = document.querySelector(".lsu-eye-btn");
  if (!input || !button) return;

  const showing = input.type === "text";
  input.type = showing ? "password" : "text";
  button.classList.toggle("lsu-showing", !showing);
  button.setAttribute("aria-label", showing ? "Show password" : "Hide password");
}

export function sessionTogglePassword() {
  const input = safeGet("session-pw");
  const button = document.querySelector(".session-eye-btn");
  if (!input || !button) return;

  const showing = input.type === "text";
  input.type = showing ? "password" : "text";
  button.classList.toggle("session-showing", !showing);
  button.setAttribute("aria-label", showing ? "Show password" : "Hide password");
}

// Auto-wireup: attach global helpers so inline attributes can still call them
if (typeof window !== 'undefined') {
  window.lsuUpdateStrength = lsuUpdateStrength;
  window.lsuTogglePassword = lsuTogglePassword;
  window.sessionTogglePassword = sessionTogglePassword;
}
