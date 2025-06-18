// emailSamples.js

// Built-in game samples
export const defaultSamples = [
  {
    subject: "Unusual login detected on your account",
    sender: "security@not-google.com",
    body: "We've detected an unusual login attempt. Log in immediately: http://google-login-alerts.com",
    headers: "X-Mailer: PhishMailer/2.0",
    attachments: [],
    correct: "phish"
  },
  {
    subject: "Amazon Order Confirmation",
    sender: "order-update@amazon.com",
    body: "Your order #112-8329 has been shipped. Track your package here.",
    headers: "X-Mailer: AmazonSES",
    attachments: [],
    correct: "legit"
  },
  {
    subject: "Important: Update your password immediately",
    sender: "security@fakedomain.com",
    body: "Click here to reset your password: http://fake-security.com",
    headers: "X-Mailer: SuspiciousMailer/1.0",
    attachments: [],
    correct: "phish"
  },
  {
    subject: "Your receipt from LegitStore",
    sender: "support@legitstore.com",
    body: "Thanks for your purchase. See your receipt attached.",
    headers: "X-Mailer: Outlook",
    attachments: ["receipt.pdf"],
    correct: "legit"
  },
  {
    subject: "Claim your free reward now!",
    sender: "promo@scammerz.ru",
    body: "You've won! Click here to claim.",
    headers: "X-Mailer: MailZilla",
    attachments: [],
    correct: "phish"
  },
  {
    subject: "Unusual login detected on your account",
    sender: "security@not-google.com",
    body: "We've detected an unusual login attempt. Log in immediately: http://google-login-alerts.com",
    headers: "X-Mailer: PhishMailer/2.0",
    attachments: [],
    correct: "phish"
  },
  {
    subject: "FedEx: Your package couldn't be delivered",
    sender: "support@fedex-fake.com",
    body: "Your parcel was undeliverable. View the shipping label: http://fedex-support.org/label",
    headers: "X-Mailer: Unknown",
    attachments: ["Shipping_Label.exe"],
    correct: "phish"
  },
  {
    subject: "Invoice Due - Immediate Payment Required",
    sender: "billing@vendor-payment.com",
    body: "Attached is your invoice. Please pay within 24 hours to avoid penalties.",
    headers: "X-Originating-IP: 182.122.87.5",
    attachments: ["invoice.pdf"],
    correct: "phish"
  },
  {
    subject: "Action Required: Microsoft 365 License Suspension",
    sender: "noreply@ms365-license-support.com",
    body: "Your Microsoft license has expired. Renew now to avoid service disruption.",
    headers: "X-Mailer: OWA",
    attachments: [],
    correct: "phish"
  },
  {
    subject: "CONFIDENTIAL: Salary Adjustment Document",
    sender: "hr-dept@fakecorp.io",
    body: "You’ve been selected for a salary increase. View attached HR documents.",
    headers: "X-Mailer: Suspicious",
    attachments: ["HR-Update.docm"],
    correct: "phish"
  },

  // Legit
  {
    subject: "Google Security Alert",
    sender: "no-reply@accounts.google.com",
    body: "New sign-in from Chrome on Windows. If this was you, no further action is needed.",
    headers: "X-Mailer: Google Mail",
    attachments: [],
    correct: "legit"
  },
  {
    subject: "Zoom Meeting Confirmation - Project Sync",
    sender: "meetings@zoom.us",
    body: "Your meeting is confirmed for Thursday at 3:00 PM. Click to join.",
    headers: "X-Mailer: ZoomScheduler",
    attachments: [],
    correct: "legit"
  },
  {
    subject: "Receipt for Your Payment to Spotify",
    sender: "no-reply@spotify.com",
    body: "Thanks for your payment. Here's your monthly receipt.",
    headers: "X-Mailer: Mailgun",
    attachments: ["receipt.pdf"],
    correct: "legit"
  },
  {
    subject: "Internal Memo: Quarterly Town Hall",
    sender: "ceo@yourcompany.com",
    body: "Please join our upcoming all-hands meeting next week. Calendar invite attached.",
    headers: "X-Mailer: Microsoft Outlook",
    attachments: ["Q2-TownHall.ics"],
    correct: "legit"
  },
  {
    subject: "Amazon Order Confirmation",
    sender: "order-update@amazon.com",
    body: "Your order #112-8329 has been shipped. Track your package here.",
    headers: "X-Mailer: AmazonSES",
    attachments: [],
    correct: "legit"
  }
];

// Player-submitted emails
export let customSamples = [];

// Function to add player-created emails
export function addCustomSample(sample) {
  customSamples.push(sample);
}
