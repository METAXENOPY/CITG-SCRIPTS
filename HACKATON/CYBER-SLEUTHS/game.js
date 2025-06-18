import { defaultSamples, customSamples, addCustomSample } from './emailSamples.js';

let timeLeft = 60;
let timerInterval;
let score = 0;
let currentIndex = 0;
let correctAnswers = 0;
let incorrectAnswers = 0;
let writingScore = 0;
let buttonsEnabled = true;

window.onload = () => {
  shuffle(samples);
  startTimer();
  loadSample();
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
  const sample = samples[currentIndex];
  document.getElementById("email-subject").innerText = sample.subject;
  document.getElementById("email-sender").innerText = sample.sender;
  document.getElementById("email-body").innerText = sample.body;
  document.getElementById("email-headers").innerText = sample.headers;

  const attachmentDiv = document.getElementById("email-attachments");
  attachmentDiv.innerHTML = "";
  sample.attachments.forEach(att => {
    const a = document.createElement("div");
    a.innerText = "📎 " + att;
    attachmentDiv.appendChild(a);
  });

  enableButtons();
  document.getElementById("feedback").innerText = "";
}

function choose(choice) {
  if (!buttonsEnabled) return;
  disableButtons();

  const result = samples[currentIndex].correct;
  if (choice === result) {
    score++;
    correctAnswers++;
    document.getElementById("feedback").innerText = "✅ Correct!";
  } else {
    incorrectAnswers++;
    document.getElementById("feedback").innerText = "❌ Incorrect!";
  }

  document.getElementById("score").innerText = "Score: " + score;
  nextSample();
}

function reportEmail() {
  if (!buttonsEnabled) return;
  disableButtons();

  const result = samples[currentIndex].correct;
  if (result === "phish") {
    score += 2;
    correctAnswers++;
    document.getElementById("feedback").innerText = "📨 Reported correctly! That was phishing. +2 points!";
  } else {
    incorrectAnswers++;
    document.getElementById("feedback").innerText = "⚠️ That email was legit. False reports hurt trust!";
  }

  document.getElementById("score").innerText = "Score: " + score;
  nextSample();
}

function nextSample() {
  currentIndex = (currentIndex + 1) % samples.length;
  if (timeLeft > 0) {
    setTimeout(loadSample, 1500);
  } else {
    endGame();
  }
}

function submitCustomEmail() {
  const subject = document.getElementById("custom-subject").value.trim();
  const sender = document.getElementById("custom-sender").value.trim();
  const body = document.getElementById("custom-body").value.trim();
  const label = document.getElementById("custom-label").value;

  const feedback = document.getElementById("custom-feedback");

  if (subject && sender && body) {
    const newSample = {
      subject,
      sender,
      body,
      headers: "X-Mailer: PlayerSubmission",
      attachments: [],
      correct: label
    };

    writingScore += 2;
    feedback.innerText = "✅ Email submitted successfully! +2 points!";

    addCustomSample(newSample);
    samples.push(newSample);
    shuffle(samples);

    // Clear input fields
    document.getElementById("custom-subject").value = "";
    document.getElementById("custom-sender").value = "";
    document.getElementById("custom-body").value = "";
  } else {
    feedback.innerText = "⚠️ Please fill in all fields.";
  }

  document.getElementById("writing-score").innerText = writingScore;
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
  document.getElementById("emails-reviewed").innerText = currentIndex;
  document.getElementById("correct-count").innerText = correctAnswers;
  document.getElementById("wrong-count").innerText = incorrectAnswers;
  document.getElementById("writing-score").innerText = writingScore;

  updateLeaderboard();
}

function updateLeaderboard() {
  const list = document.getElementById("leaderboard");
  const entry = document.createElement("li");
  entry.innerText = `Player: ${score} pts`;
  list.appendChild(entry);
}
