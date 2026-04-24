const OPENAI_API_URL = "https://api.openai.com/v1/responses";
const DEFAULT_MODEL = process.env.OPENAI_MODEL || "gpt-4.1-mini";

function jsonResponse(response, status, payload) {
  response.status(status).json(payload);
}

function getOpenAiKey() {
  return process.env.OPENAI_API_KEY;
}

function safeJsonParse(text) {
  try {
    return JSON.parse(text);
  } catch {
    const match = text.match(/\{[\s\S]*\}/);
    if (!match) return null;
    try {
      return JSON.parse(match[0]);
    } catch {
      return null;
    }
  }
}

function clamp(value, min, max, fallback) {
  const number = Number(value);
  if (!Number.isFinite(number)) return fallback;
  return Math.max(min, Math.min(max, Math.round(number)));
}

function normalizeMeal(data) {
  return {
    title: String(data?.title || "Блюдо").slice(0, 70),
    confidence: clamp(data?.confidence, 35, 98, 78),
    calories: clamp(data?.calories, 20, 2500, 450),
    protein: clamp(data?.protein, 0, 250, 25),
    fat: clamp(data?.fat, 0, 250, 15),
    carbs: clamp(data?.carbs, 0, 350, 45),
    note: String(data?.note || "").slice(0, 180),
  };
}

async function callOpenAi(input, instructions) {
  const key = getOpenAiKey();
  if (!key) {
    throw new Error("OPENAI_API_KEY is not configured");
  }

  const response = await fetch(OPENAI_API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${key}`,
    },
    body: JSON.stringify({
      model: DEFAULT_MODEL,
      instructions,
      input,
      max_output_tokens: 700,
    }),
  });

  const data = await response.json();

  if (!response.ok) {
    throw new Error(data?.error?.message || "OpenAI request failed");
  }

  const text = data.output_text || data.output?.flatMap((item) => item.content || []).find((item) => item.type === "output_text")?.text || "";
  return text.trim();
}

function compactContext(context = {}) {
  return {
    goalCalories: context.dailyGoal,
    todayTotals: context.totals,
    water: context.water,
    profile: context.profile,
    recentMeals: Array.isArray(context.diary) ? context.diary.slice(0, 8) : [],
    notes: Array.isArray(context.notes) ? context.notes.slice(0, 5) : [],
    weight: Array.isArray(context.weightEntries) ? context.weightEntries.slice(0, 5) : [],
  };
}

async function analyzeFood(body) {
  const content = [
    {
      type: "input_text",
      text: [
        "Определи блюдо и примерные калории/БЖУ.",
        "Если есть фото, оцени его. Если фото нет, используй описание пользователя.",
        "Верни строго JSON без markdown:",
        '{"title":"string","confidence":number,"calories":number,"protein":number,"fat":number,"carbs":number,"note":"short Russian note"}',
        "",
        `Описание: ${body.description || "нет"}`,
        `Контекст пользователя: ${JSON.stringify(compactContext(body.context))}`,
      ].join("\n"),
    },
  ];

  if (body.imageDataUrl) {
    content.push({
      type: "input_image",
      image_url: body.imageDataUrl,
    });
  }

  const text = await callOpenAi(
    [{ role: "user", content }],
    "Ты аккуратный AI-помощник по питанию. Оценивай еду приблизительно, не обещай медицинскую точность. Отвечай только валидным JSON."
  );

  const parsed = safeJsonParse(text);
  if (!parsed) {
    throw new Error("AI returned invalid food JSON");
  }

  return normalizeMeal(parsed);
}

async function chat(body) {
  const text = await callOpenAi(
    [
      {
        role: "user",
        content: [
          {
            type: "input_text",
            text: [
              `Вопрос пользователя: ${body.message || ""}`,
              "",
              `Контекст FoodLens: ${JSON.stringify(compactContext(body.context))}`,
            ].join("\n"),
          },
        ],
      },
    ],
    [
      "Ты FoodLens AI, дружелюбный помощник по питанию внутри Telegram Mini App.",
      "Отвечай по-русски, коротко и практично.",
      "Учитывай дневник, воду, вес, цель и комментарии профиля.",
      "Не ставь диагнозы и не выдавай медицинские назначения.",
      "Если данных мало, предложи простой следующий шаг.",
    ].join(" ")
  );

  return text || "Я рядом. Открой дневник, добавь еду, и я смогу точнее подсказать следующий шаг.";
}

export default async function handler(request, response) {
  if (request.method === "GET") {
    return jsonResponse(response, 200, { ok: true, status: "FoodLens AI endpoint" });
  }

  if (request.method !== "POST") {
    return jsonResponse(response, 405, { ok: false, error: "Method not allowed" });
  }

  try {
    const body = request.body || {};

    if (body.type === "food") {
      const meal = await analyzeFood(body);
      return jsonResponse(response, 200, { ok: true, meal });
    }

    if (body.type === "chat") {
      const reply = await chat(body);
      return jsonResponse(response, 200, { ok: true, reply });
    }

    return jsonResponse(response, 400, { ok: false, error: "Unknown AI request type" });
  } catch (error) {
    console.error(error);
    return jsonResponse(response, 200, { ok: false, error: error.message });
  }
}
