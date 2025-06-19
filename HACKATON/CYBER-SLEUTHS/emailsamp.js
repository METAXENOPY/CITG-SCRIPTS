// Built-in game samples

export const defaultSamples = [
  // Legitimate Email 1
  {
    subject: "Your Amazon.com order has shipped",
    sender: "shipment-tracking@amazon.com",
    body: "Hello,\n\nYour order #123-4567890-1234567 has shipped. Track your package for the latest updates.\n\nThank you for shopping with us.",
    headers: "From: shipment-tracking@amazon.com\nTo: you@example.com\nDate: Tue, 18 Jun 2024 10:23:45 -0700",
    attachments: [],
    correct: "legit"
  },
  // Legitimate Email 2
  {
    subject: "Your monthly bank statement is ready",
    sender: "no-reply@yourbank.com",
    body: "Dear Customer,\n\nYour monthly statement is now available. Please log in to your online banking account to view your statement securely.\n\nThank you,\nYourBank",
    headers: "From: no-reply@yourbank.com\nTo: you@example.com\nDate: Wed, 19 Jun 2024 08:12:30 -0700",
    attachments: [],
    correct: "legit"
  },
  // Legitimate Email 3
  {
    subject: "Company All-Hands Meeting Tomorrow",
    sender: "hr@company.com",
    body: "Hi Team,\n\nThis is a reminder for our all-hands meeting scheduled for tomorrow at 10:00 AM in the main conference room.\n\nBest,\nHR Department",
    headers: "From: hr@company.com\nTo: you@example.com\nDate: Mon, 17 Jun 2024 15:00:00 -0700",
    attachments: [],
    correct: "legit"
  },
  // Phishing Email 1
  {
    subject: "Your account has been suspended",
    sender: "support@paypa1.com",
    body: "Dear Customer,\n\nWe noticed suspicious activity in your account. Please verify your information immediately by clicking the link below:\nhttp://paypa1-security.com/verify\n\nFailure to do so will result in permanent suspension.",
    headers: "From: support@paypa1.com\nTo: you@example.com\nDate: Thu, 20 Jun 2024 09:45:12 -0700",
    attachments: [],
    correct: "phish"
  },
  // Phishing Email 2
  {
    subject: "Unusual sign-in activity",
    sender: "security-alert@microsoft-support.com",
    body: "We've detected unusual sign-in activity on your Microsoft account. Please confirm your identity by downloading the attached form and replying with your credentials.",
    headers: "From: security-alert@microsoft-support.com\nTo: you@example.com\nDate: Fri, 21 Jun 2024 11:30:00 -0700",
    attachments: ["SecurityForm.docx"],
    correct: "phish"
  },
  // Phishing Email 3
  {
    subject: "Congratulations! You've won a $500 gift card",
    sender: "promo@amaz0n.com",
    body: "Dear Winner,\n\nYou have been selected to receive a $500 Amazon gift card. Click the link below to claim your prize:\nhttp://amaz0n-prizes.com/claim\n\nAct fast, this offer expires soon!",
    headers: "From: promo@amaz0n.com\nTo: you@example.com\nDate: Sat, 22 Jun 2024 14:20:00 -0700",
    attachments: [],
    correct: "phish"
  }
];

export const customSamples = [];

export function addCustomSample(sample) {
  customSamples.push(sample);
}

export function getAllSamples() {
  return [...defaultSamples, ...customSamples];
}

export function generateAIMail() {
  // Define some sample data for legit and phishing emails
  const legitSubjects = [
    "Your invoice for last month",
    "Team meeting scheduled",
    "Welcome to our service",
    "Password changed successfully",
    "Your subscription is active"
  ];
  const legitSenders = [
    "billing@company.com",
    "hr@company.com",
    "support@trustedsite.com",
    "no-reply@service.com",
    "admin@company.com"
  ];
  const legitBodies = [
    "Dear user, your invoice for last month is attached. Thank you for your business.",
    "The team meeting is scheduled for tomorrow at 10 AM in the main conference room.",
    "Thank you for signing up! Let us know if you have any questions.",
    "Your password was changed successfully. If this wasn't you, contact support.",
    "Your subscription is now active. Enjoy our premium features!"
  ];

  const phishSubjects = [
    "URGENT: Account Suspended",
    "Verify your account now",
    "Unusual login detected",
    "Claim your reward",
    "Payment failed"
  ];
  const phishSenders = [
    "security@secure-mail.com",
    "alert@bank-secure.com",
    "admin@paypall.com",
    "support@amaz0n.com",
    "it-support@company-secure.com"
  ];
  const phishBodies = [
    "Your account has been suspended. Click the link to reactivate.",
    "We noticed unusual activity. Please verify your account immediately.",
    "Congratulations! You have won a $1000 gift card. Click here to claim.",
    "Your payment could not be processed. Update your billing information.",
    "Immediate action required: Your account will be locked unless you respond."
  ];

  const isPhish = Math.random() < 0.5;
  if (isPhish) {
    const idx = Math.floor(Math.random() * phishSubjects.length);
    return {
      subject: phishSubjects[idx],
      sender: phishSenders[idx],
      body: phishBodies[idx],
      headers: `From: ${phishSenders[idx]}\nTo: you@example.com\nDate: ...`,
      attachments: [],
      correct: "phish"
    };
  } else {
    const idx = Math.floor(Math.random() * legitSubjects.length);
    return {
      subject: legitSubjects[idx],
      sender: legitSenders[idx],
      body: legitBodies[idx],
      headers: `From: ${legitSenders[idx]}\nTo: you@example.com\nDate: ...`,
      attachments: [],
      correct: "legit"
    };
  }
}


