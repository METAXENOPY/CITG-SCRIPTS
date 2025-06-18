let samples = [
  {
    from: "support@apple.com",
    subject: "Apple ID Locked – Action Required",
    headers: "Return-Path: spoof@phishing.biz\nReceived: from mail.fake.net (unknown)\nX-Mailer: PHISHBOT",
    content: `We've detected suspicious activity on your Apple ID. For your safety, your account has been locked. <a href="http://apple-verification-login.com">Verify your account</a>.`,
    attachments: [],
    correct: "phish"
  },
  {
    from: "alerts@bankofamerica.com",
    subject: "Unusual Login Attempt Detected",
    headers: "Return-Path: phishing@scamdomain.co\nReceived: from unknown (HELO mailhost)\nX-Sender-IP: 203.0.113.77",
    content: `Login attempt detected from new device. <a href="http://secure-bofa-login.com">Click here</a> to verify.`,
    attachments: [],
    correct: "phish"
  },
  {
    from: "hr@company.com",
    subject: "Updated Leave Policy",
    headers: "Received: from mail.company.com\nX-Mailer: Outlook 16.0",
    content: `Please review the attached leave policy updates.`,
    attachments: ["Leave_Policy_2025.pdf"],
    correct: "legit"
  },
  {
    from: "no-reply@amazon.com",
    subject: "Your Order Has Shipped",
    headers: "Received: from mail.amazon.com\nX-Mailer: Amazon Mailer",
    content: `Your order has shipped. <a href="https://amazon.com/track/123456">Track your package</a>.`,
    attachments: [],
    correct: "legit"
  },
  {
    from: "admin@office365-notice.com",
    subject: "Mailbox Almost Full!",
    headers: "Received: from unknown (spoof)\nX-Fraud-Check: Failed",
    content: `Your storage is full. <a href="http://o365-upgrade-storage.click">Upgrade now</a>.`,
    attachments: [],
    correct: "phish"
  },
  {
    from: "it-helpdesk@company.com",
    subject: "New VPN Client Installer",
    headers: "Received: from internal.company.com\nX-Mailer: Outlook",
    content: `Please install the new VPN client from the attachment.`,
    attachments: ["VPN_Setup.exe"],
    correct: "phish"
  },
  {
    from: "devteam@company.com",
    subject: "Weekly Standup Recording",
    headers: "Received: from mail.company.com\nX-Mailer: MS Teams",
    content: `Attached is the recorded meeting for this week.`,
    attachments: ["Standup_Recording.mp4"],
    correct: "legit"
  },
  {
    from: "rewards@paypal-secure.com",
    subject: "You've earned a cashback reward!",
    headers: "Return-Path: cashback@fake-paypal.com\nReceived: from 185.12.35.10",
    content: `Click here to claim your $50 reward now: <a href="http://paypal-cashback.info">Claim Reward</a>`,
    attachments: [],
    correct: "phish"
  }
];

samples = shuffleArray(samples);

let currentIndex = 0;
let score = 0;

function loadSample() {
  const sample = samples[currentIndex];
  document.getElementById("email-from").innerText = sample.from;
  document.getElementById("email-subject").innerText = sample.subject;
  document.getElementById("email-content").innerHTML = sample.content;
  document.getElementById("email-headers").innerText = sample.headers;
  document.getElementById("email-headers").style.display = "none";

  const attachBox = document.getElementById("email-attachments");
  attachBox.innerHTML = "";
  if (sample.attachments.length > 0) {
    attachBox.innerHTML = "📎 Attachments: " + sample.attachments.join(", ");
  }
  document.getElementById("feedback").innerText = "";
}

function choose(answer) {
  const result = samples[currentIndex].correct;
  if (answer === result) {
    score++;
    document.getElementById("feedback").innerText = "✅ Correct!";
  } else {
    document.getElementById("feedback").innerText = `❌ Incorrect. This email was "${result.toUpperCase()}".`;
  }
  document.getElementById("score").innerText = "Score: " + score;
  nextSample();
}

function reportEmail() {
  const result = samples[currentIndex].correct;
  if (result === "phish") {
    score++;
    document.getElementById("feedback").innerText = "📨 Reported correctly! That was phishing.";
  } else {
    document.getElementById("feedback").innerText = "⚠️ That email was legit. False reports hurt trust!";
  }
  document.getElementById("score").innerText = "Score: " + score;
  nextSample();
}

function nextSample() {
  currentIndex++;
  if (currentIndex < samples.length) {
    setTimeout(loadSample, 1500);
  } else {
    setTimeout(() => {
      document.getElementById("email-from").innerText = "";
      document.getElementById("email-subject").innerText = "";
      document.getElementById("email-content").innerText = "🎉 Game Over! Final Score: " + score;
      document.getElementById("email-headers").style.display = "none";
      document.getElementById("choices").style.display = "none";
    }, 1500);
  }
}

function toggleHeaders() {
  const header = document.getElementById("email-headers");
  header.style.display = header.style.display === "none" ? "block" : "none";
}

function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

window.onload = loadSample;
