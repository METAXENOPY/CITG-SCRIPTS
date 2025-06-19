// Infinite, unique, scenario-based email generator

export const defaultSamples = []; // No static samples

export const customSamples = [];

export function addCustomSample(sample) {
  customSamples.push(sample);
}

export function getAllSamples() {
  // Always return empty; game uses generateAIMail for infinite samples
  return [];
}

function randomFrom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomDate() {
  const now = new Date();
  const daysAgo = Math.floor(Math.random() * 30);
  now.setDate(now.getDate() - daysAgo);
  return now.toLocaleString();
}

function randomAmount() {
  return "$" + (Math.floor(Math.random() * 900) + 100) + "." + (Math.floor(Math.random() * 100)).toString().padStart(2, "0");
}

function randomOrderId() {
  return "#" + Math.floor(Math.random() * 9000000 + 1000000);
}

function randomName() {
  const names = ["Alice", "Bob", "Charlie", "Dana", "Eli", "Fay", "Gina", "Hank", "Ivy", "Jack"];
  return randomFrom(names);
}

function randomCompany() {
  const companies = ["Amazon", "Microsoft", "Google", "Apple", "Netflix", "Bank of America", "Wells Fargo", "FedEx", "PayPal", "Meta"];
  return randomFrom(companies);
}

function randomDomain(company) {
  return company.toLowerCase().replace(/\s/g, '') + ".com";
}

export function generateAIMail() {
  const legitTemplates = [
    {
      subject: () => `Your ${randomCompany()} order has shipped`,
      sender: () => `shipment@${randomDomain(randomCompany())}`,
      body: () => `Hello ${randomName()},\n\nYour order ${randomOrderId()} has shipped. Track your package for the latest updates.\n\nThank you for shopping with us.`,
      attachments: () => [],
    },
    {
      subject: () => `Your monthly statement is ready`,
      sender: () => `no-reply@${randomDomain(randomCompany())}`,
      body: () => `Dear ${randomName()},\n\nYour monthly statement is now available. Please log in to your online account to view it securely.\n\nThank you,\n${randomCompany()}`,
      attachments: () => [],
    },
    {
      subject: () => `Password changed successfully`,
      sender: () => `security@${randomDomain(randomCompany())}`,
      body: () => `Hi ${randomName()},\n\nYour password was changed successfully on ${randomDate()}.\nIf this wasn't you, please contact support immediately.`,
      attachments: () => [],
    },
    {
      subject: () => `Meeting Reminder: Project Sync`,
      sender: () => `hr@${randomDomain(randomCompany())}`,
      body: () => `Hi Team,\n\nThis is a reminder for our project sync meeting scheduled for tomorrow at 10:00 AM.\n\nBest,\nHR Department`,
      attachments: () => [],
    },
    {
      subject: () => `Payment received`,
      sender: () => `billing@${randomDomain(randomCompany())}`,
      body: () => `Dear ${randomName()},\n\nWe have received your payment of ${randomAmount()} on ${randomDate()}.\nThank you for your business!`,
      attachments: () => [],
    }
  ];

  const phishTemplates = [
    {
      subject: () => `URGENT: Account Suspended`,
      sender: () => `support@${randomDomain(randomCompany()).replace('a', '4')}`,
      body: () => `Dear ${randomName()},\n\nWe noticed suspicious activity in your account. Please verify your information immediately by clicking the link below:\nhttp://secure-${randomCompany().toLowerCase()}-verify.com/verify\n\nFailure to do so will result in permanent suspension.`,
      attachments: () => [],
    },
    {
      subject: () => `Unusual sign-in activity`,
      sender: () => `security-alert@${randomDomain(randomCompany())}`,
      body: () => `We've detected unusual sign-in activity on your account. Please confirm your identity by downloading the attached form and replying with your credentials.`,
      attachments: () => ["SecurityForm.docx"],
    },
    {
      subject: () => `Congratulations! You've won a ${randomAmount()} gift card`,
      sender: () => `promo@${randomDomain(randomCompany()).replace('o', '0')}`,
      body: () => `Dear Winner,\n\nYou have been selected to receive a ${randomAmount()} ${randomCompany()} gift card. Click the link below to claim your prize:\nhttp://${randomCompany().toLowerCase()}-prizes.com/claim\n\nAct fast, this offer expires soon!`,
      attachments: () => [],
    },
    {
      subject: () => `Payment failed`,
      sender: () => `billing@${randomDomain(randomCompany()).replace('i', '1')}`,
      body: () => `Dear ${randomName()},\n\nYour recent payment of ${randomAmount()} could not be processed. Please update your billing information to avoid service interruption.`,
      attachments: () => [],
    },
    {
      subject: () => `Verify your account now`,
      sender: () => `alert@${randomDomain(randomCompany()).replace('e', '3')}`,
      body: () => `Dear ${randomName()},\n\nWe noticed unusual activity. Please verify your account immediately by clicking the link below:\nhttp://verify-${randomCompany().toLowerCase()}.com/secure\n\nThank you.`,
      attachments: () => [],
    }
  ];

  const isPhish = Math.random() < 0.5;
  const template = isPhish ? randomFrom(phishTemplates) : randomFrom(legitTemplates);

  const subject = template.subject();
  const sender = template.sender();
  const body = template.body();
  const attachments = template.attachments();
  const date = randomDate();

  return {
    subject,
    sender,
    body,
    headers: `From: ${sender}\nTo: you@example.com\nDate: ${date}`,
    attachments,
    correct: isPhish ? "phish" : "legit"
  };
}


