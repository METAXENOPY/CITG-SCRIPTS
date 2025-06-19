import { defaultSamples, customSamples, addCustomSample, getAllSamples, generateAIMail } from './emailsamp.js';

let samples = [];
let timeLeft = 60;
let timerInterval;
let score = 0;
let currentIndex = 0;
let correctAnswers = 0;
let incorrectAnswers = 0;
let buttonsEnabled = true;
let currentSample;
let streak = 0; // Add this near the top with other variables
let difficulty = 1; // 1: Easy, 2: Medium, 3: Hard
let stage = 1;
const maxStage = 3;

window.onload = () => {
  // Hide modals
  document.getElementById("help-modal").style.display = "none";
  document.getElementById("info-modal").style.display = "none";
  // Show start screen, hide game UI sections
  document.getElementById("start-screen").style.display = "";
  document.getElementById("top-bar").style.display = "none";
  document.getElementById("email-viewer").style.display = "none";
  document.getElementById("choices").style.display = "none";
  document.getElementById("feedback").style.display = "none";
  document.getElementById("final-screen").style.display = "none";

  // Attach modal event listeners here:
  document.getElementById("help-btn").onclick = function () {
    document.getElementById("help-modal").style.display = "block";
  };
  document.getElementById("close-help").onclick = function () {
    document.getElementById("help-modal").style.display = "none";
  };
  document.getElementById("info-btn").onclick = function () {
    document.getElementById("info-modal").style.display = "block";
  };
  document.getElementById("close-info").onclick = function () {
    document.getElementById("info-modal").style.display = "none";
  };
  // Close modals when clicking outside content
  window.onclick = function (event) {
    if (event.target.classList.contains("modal")) {
      event.target.style.display = "none";
    }
  };
};

function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
}

function startTimer() {
  timerInterval = setInterval(() => {
    timeLeft--;
    document.getElementById("time-left").innerText = timeLeft;
    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      endGame();
    }
  }, 1000);
}

function loadSample() {
  const samples = getAllSamples();
  if (samples.length === 0) return endGame();

  // Increase AI-generated email chance with difficulty
  let aiChance = 0.3 + (difficulty - 1) * 0.2; // 0.3, 0.5, 0.7
  let sample;
  if (Math.random() < aiChance) {
    sample = generateAIMail();
  } else {
    sample = samples[Math.floor(Math.random() * samples.length)];
  }

  currentSample = sample;

  document.getElementById("email-subject").innerText = sample.subject;
  document.getElementById("email-sender").innerText = sample.sender;
  document.getElementById("email-body").innerText = sample.body;
  document.getElementById("email-headers").innerText = sample.headers;
  document.getElementById("email-attachments").innerText = sample.attachments.length > 0 ? sample.attachments.join(", ") : "None";
  // Set a date (use sample.headers if you want to parse a real date)
  document.getElementById("email-date").innerText = new Date().toLocaleString();

  enableButtons();
  showFeedback(""); // Clear feedback on new sample
}

function choose(choice) {
  if (!buttonsEnabled) return;
  disableButtons();

  if (choice === currentSample.correct) {
    score += 10;
    correctAnswers++;
    streak++;
    if (streak > 0 && streak % 3 === 0) {
      timeLeft += 5;
      document.getElementById("time-left").innerText = timeLeft;
      showFeedback("✅ Correct! ⏱ +5s streak bonus!");
    } else {
      showFeedback("✅ Correct!");
    }
    checkStageAdvance();
  } else {
    score -= 5;
    incorrectAnswers++;
    streak = 0;
    showFeedback("❌ Incorrect!");
  }

  updateScore();
  setTimeout(loadSample, 1500);
}

function reportEmail() {
  if (!buttonsEnabled) return;
  disableButtons();

  if (currentSample.correct === "phish") {
    score += 5;
    correctAnswers++;
    streak++;
    if (streak > 0 && streak % 3 === 0) {
      timeLeft += 5;
      document.getElementById("time-left").innerText = timeLeft;
      showFeedback("📨 Reported! Good job. ⏱ +5s streak bonus!");
    } else {
      showFeedback("📨 Reported! Good job.");
    }
    checkStageAdvance();
  } else {
    score -= 2;
    incorrectAnswers++;
    streak = 0;
    showFeedback("⚠️ Not a phish. Incorrect report.");
  }

  updateScore();
  setTimeout(loadSample, 1500);
}

function nextSample() {
  currentIndex++;
  const samples = getAllSamples();

  if (currentIndex < samples.length && timeLeft > 0) {
    loadSample();
  } else {
    endGame();
  }
}

function updateScore() {
  document.getElementById("score").innerText = "Score: " + score;
}

function showFeedback(text) {
  document.getElementById("feedback").innerText = text;
}

function disableButtons() {
  buttonsEnabled = false;
  document.querySelectorAll("#choices button").forEach(btn => btn.disabled = true);
}

function enableButtons() {
  buttonsEnabled = true;
  document.querySelectorAll("#choices button").forEach(btn => btn.disabled = false);
}

function endGame() {
  clearInterval(timerInterval);
  document.getElementById("email-viewer").style.display = "none";
  document.getElementById("choices").style.display = "none";
  document.getElementById("timer").style.display = "none";
  document.getElementById("feedback").style.display = "none";

  document.getElementById("final-screen").style.display = "block";
  document.getElementById("final-score").innerText = score;
  document.getElementById("emails-reviewed").innerText = correctAnswers + incorrectAnswers;
  document.getElementById("correct-count").innerText = correctAnswers;
  document.getElementById("wrong-count").innerText = incorrectAnswers;
}

function setDifficulty(stage) {
  difficulty = stage;
  if (difficulty === 1) {
    timeLeft = 60;
  } else if (difficulty === 2) {
    timeLeft = 45;
  } else if (difficulty === 3) {
    timeLeft = 30;
  }
  document.getElementById("time-left").innerText = timeLeft;
  updateDifficultyDisplay();
}

function checkStageAdvance() {
  if (correctAnswers > 0 && correctAnswers % 10 === 0 && stage < maxStage) {
    stage++;
    setDifficulty(stage);
    showFeedback(`🎉 Stage ${stage}! Difficulty increased.`);
  }
}

function updateDifficultyDisplay() {
  let label = "Easy";
  if (difficulty === 2) label = "Medium";
  if (difficulty === 3) label = "Hard";
  document.getElementById("difficulty-level").innerText = label;
}

document.getElementById("play-again-btn").onclick = function () {
  // Reset all variables
  score = 0;
  correctAnswers = 0;
  incorrectAnswers = 0;
  streak = 0;
  stage = 1;
  setDifficulty(stage);
  updateDifficultyDisplay();

  document.getElementById("final-screen").style.display = "none";
  document.getElementById("email-viewer").style.display = "";
  document.getElementById("choices").style.display = "";
  document.getElementById("timer").style.display = "";
  document.getElementById("feedback").style.display = "";

  updateScore();
  startTimer();
  loadSample();
};

document.getElementById("start-game-btn").onclick = function () {
  // Hide start screen, show game UI sections
  document.getElementById("start-screen").style.display = "none";
  document.getElementById("top-bar").style.display = "";
  document.getElementById("email-viewer").style.display = "";
  document.getElementById("choices").style.display = "";
  document.getElementById("feedback").style.display = "";
  document.getElementById("final-screen").style.display = "none";

  // Reset all game variables
  score = 0;
  correctAnswers = 0;
  incorrectAnswers = 0;
  streak = 0;
  stage = 1;
  setDifficulty(stage);
  updateDifficultyDisplay();
  updateScore();

  // Shuffle samples and start the timer and first sample
  samples = [...defaultSamples];
  shuffle(samples);
  startTimer();
  loadSample();
};

window.choose = choose;
window.reportEmail = reportEmail;
