const appUrl = process.env.MINI_APP_URL || "https://food-lens-five.vercel.app";

async function callTelegram(method, payload) {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) return;

  await fetch(`https://api.telegram.org/bot${token}/${method}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
}

export default async function handler(request, response) {
  if (request.method !== "POST") {
    response.status(200).json({ ok: true, status: "FoodLens Telegram webhook" });
    return;
  }

  const message = request.body?.message;
  const chatId = message?.chat?.id;
  const text = message?.text || "";

  if (!chatId) {
    response.status(200).json({ ok: true });
    return;
  }

  const isHelp = text.startsWith("/help");
  const replyText = isHelp
    ? "Открой FoodLens, добавляй еду по фото или вручную, следи за калориями, БЖУ, водой и весом. AI-чат поможет разобрать день."
    : "Привет! Я FoodLens — AI-помощник по питанию. Открой мини-приложение и веди дневник еды, воды, веса и целей.";

  await callTelegram("sendMessage", {
    chat_id: chatId,
    text: replyText,
    reply_markup: {
      inline_keyboard: [[
        { text: "Открыть FoodLens", web_app: { url: appUrl } },
      ]],
    },
  });

  response.status(200).json({ ok: true });
}
