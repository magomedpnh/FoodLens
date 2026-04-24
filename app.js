const TelegramApp = window.Telegram?.WebApp;

const meals = [
  { title: "Курица, рис и салат", confidence: 87, calories: 640, protein: 42, fat: 18, carbs: 73 },
  { title: "Омлет, авокадо и тост", confidence: 84, calories: 520, protein: 28, fat: 32, carbs: 34 },
  { title: "Паста с томатным соусом", confidence: 81, calories: 710, protein: 24, fat: 21, carbs: 104 },
];

const mealTypes = [
  { value: "breakfast", label: "Завтрак" },
  { value: "lunch", label: "Обед" },
  { value: "dinner", label: "Ужин" },
  { value: "snack", label: "Перекус" },
];

let currentMeal = { ...meals[0] };
let currentScale = 1;
let currentMealType = "breakfast";
let currentManualType = "breakfast";
let dailyGoal = 1900;
let diary = [];
let dayStore = {};
let selectedDate = new Date();
let selectedDateKey = "";
let waterCount = 0;
const waterGoal = 8;
let notes = [];
let favorites = [];
let weightEntries = [];
let aiMessages = [];
let profile = {
  weight: 82,
  height: 178,
  age: 28,
  sex: "male",
  activity: 1.2,
  goal: "lose",
  comment: "",
};

const cameraFeed = document.getElementById("cameraFeed");
const cameraPlaceholder = document.getElementById("cameraPlaceholder");
const cameraStatus = document.getElementById("cameraStatus");
const scanButton = document.getElementById("scanButton");
const manualButton = document.getElementById("manualButton");
const photoButton = document.getElementById("photoButton");
const photoInput = document.getElementById("photoInput");
const mealTitle = document.getElementById("mealTitle");
const confidence = document.getElementById("confidence");
const calories = document.getElementById("calories");
const protein = document.getElementById("protein");
const fat = document.getElementById("fat");
const carbs = document.getElementById("carbs");
const saveButton = document.getElementById("saveButton");
const dailyTotal = document.getElementById("dailyTotal");
const dateLabel = document.getElementById("dateLabel");
const dateValue = document.getElementById("dateValue");
const prevDay = document.getElementById("prevDay");
const nextDay = document.getElementById("nextDay");
const todayButton = document.getElementById("todayButton");
const goalProgress = document.getElementById("goalProgress");
const mealList = document.getElementById("mealList");
const remainingRow = document.getElementById("remainingRow");
const remainingLabel = document.getElementById("remainingLabel");
const remainingCalories = document.getElementById("remainingCalories");
const waterCountEl = document.getElementById("waterCount");
const waterGoalEl = document.getElementById("waterGoal");
const waterDots = document.getElementById("waterDots");
const waterHint = document.getElementById("waterHint");
const waterMinus = document.getElementById("waterMinus");
const waterPlus = document.getElementById("waterPlus");
const summaryStatus = document.getElementById("summaryStatus");
const summaryProtein = document.getElementById("summaryProtein");
const summaryFat = document.getElementById("summaryFat");
const summaryCarbs = document.getElementById("summaryCarbs");
const summaryWater = document.getElementById("summaryWater");
const summaryAdvice = document.getElementById("summaryAdvice");
const macroBalanceBadge = document.getElementById("macroBalanceBadge");
const macroProteinValue = document.getElementById("macroProteinValue");
const macroProteinGoal = document.getElementById("macroProteinGoal");
const macroProteinLeft = document.getElementById("macroProteinLeft");
const macroProteinProgress = document.getElementById("macroProteinProgress");
const macroFatValue = document.getElementById("macroFatValue");
const macroFatGoal = document.getElementById("macroFatGoal");
const macroFatLeft = document.getElementById("macroFatLeft");
const macroFatProgress = document.getElementById("macroFatProgress");
const macroCarbsValue = document.getElementById("macroCarbsValue");
const macroCarbsGoal = document.getElementById("macroCarbsGoal");
const macroCarbsLeft = document.getElementById("macroCarbsLeft");
const macroCarbsProgress = document.getElementById("macroCarbsProgress");
const themeButton = document.getElementById("themeButton");
const goalRange = document.getElementById("goalRange");
const goalValue = document.getElementById("goalValue");
const goalOutput = document.getElementById("goalOutput");
const goalPresetButtons = [...document.querySelectorAll("[data-goal]")];
const profileButton = document.getElementById("profileButton");
const profilePanel = document.getElementById("profilePanel");
const profileBackdrop = document.getElementById("profileBackdrop");
const profileClose = document.getElementById("profileClose");
const profileWeight = document.getElementById("profileWeight");
const profileHeight = document.getElementById("profileHeight");
const profileAge = document.getElementById("profileAge");
const profileActivity = document.getElementById("profileActivity");
const profileComment = document.getElementById("profileComment");
const profileSave = document.getElementById("profileSave");
const profileCalories = document.getElementById("profileCalories");
const profileInsight = document.getElementById("profileInsight");
const profileChoices = [...document.querySelectorAll("[data-profile-field]")];
const favoritesButton = document.getElementById("favoritesButton");
const favoritesPanel = document.getElementById("favoritesPanel");
const favoritesBackdrop = document.getElementById("favoritesBackdrop");
const favoritesClose = document.getElementById("favoritesClose");
const favoritesList = document.getElementById("favoritesList");
const aiButton = document.getElementById("aiButton");
const aiPanel = document.getElementById("aiPanel");
const aiBackdrop = document.getElementById("aiBackdrop");
const aiClose = document.getElementById("aiClose");
const aiChatList = document.getElementById("aiChatList");
const aiChatForm = document.getElementById("aiChatForm");
const aiInput = document.getElementById("aiInput");
const aiPromptButtons = [...document.querySelectorAll("[data-ai-prompt]")];
const notesButton = document.getElementById("notesButton");
const notesPanel = document.getElementById("notesPanel");
const notesBackdrop = document.getElementById("notesBackdrop");
const notesClose = document.getElementById("notesClose");
const noteInput = document.getElementById("noteInput");
const noteSave = document.getElementById("noteSave");
const notesList = document.getElementById("notesList");
const weightButton = document.getElementById("weightButton");
const weightPanel = document.getElementById("weightPanel");
const weightBackdrop = document.getElementById("weightBackdrop");
const weightClose = document.getElementById("weightClose");
const weightInput = document.getElementById("weightInput");
const weightNote = document.getElementById("weightNote");
const weightSave = document.getElementById("weightSave");
const weightList = document.getElementById("weightList");
const currentWeight = document.getElementById("currentWeight");
const weightTrend = document.getElementById("weightTrend");
const weightInsight = document.getElementById("weightInsight");
const manualPanel = document.getElementById("manualPanel");
const manualBackdrop = document.getElementById("manualBackdrop");
const manualClose = document.getElementById("manualClose");
const manualInput = document.getElementById("manualInput");
const manualPreview = document.getElementById("manualPreview");
const manualSave = document.getElementById("manualSave");
const manualTypeButtons = [...document.querySelectorAll("[data-manual-type]")];
const portionButtons = [...document.querySelectorAll(".portion-button")];
const mealTypeButtons = [...document.querySelectorAll("[data-meal-type]")];

TelegramApp?.ready();
TelegramApp?.expand();


function startOfDay(date) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

function dayKey(date) {
  const day = startOfDay(date);
  const year = day.getFullYear();
  const month = String(day.getMonth() + 1).padStart(2, "0");
  const dateNumber = String(day.getDate()).padStart(2, "0");
  return year + "-" + month + "-" + dateNumber;
}

function isSameDay(first, second) {
  return dayKey(first) === dayKey(second);
}

function formatDayTitle(date) {
  return new Intl.DateTimeFormat("ru-RU", { day: "numeric", month: "long" }).format(date);
}

function loadDayStore() {
  try {
    dayStore = JSON.parse(localStorage.getItem("foodlens-days") || "{}");
  } catch {
    dayStore = {};
  }
  selectedDate = startOfDay(new Date());
  selectedDateKey = dayKey(selectedDate);
  loadSelectedDay();
}

function getLegacyWaterCount(key) {
  if (key !== dayKey(new Date())) return 0;
  return clampNumber(localStorage.getItem("foodlens-water") || 0, 0, waterGoal, 0);
}

function ensureDayData(key) {
  if (!dayStore[key]) {
    dayStore[key] = { diary: [], waterCount: getLegacyWaterCount(key) };
  }

  if (!Array.isArray(dayStore[key].diary)) dayStore[key].diary = [];
  dayStore[key].waterCount = clampNumber(dayStore[key].waterCount ?? getLegacyWaterCount(key), 0, waterGoal, 0);
  return dayStore[key];
}

function saveSelectedDay() {
  if (!selectedDateKey) return;
  dayStore[selectedDateKey] = { diary, waterCount };
  localStorage.setItem("foodlens-days", JSON.stringify(dayStore));
}

function loadSelectedDay() {
  const data = ensureDayData(selectedDateKey);
  diary = Array.isArray(data.diary) ? data.diary : [];
  waterCount = clampNumber(data.waterCount ?? 0, 0, waterGoal, 0);
}

function renderDate() {
  const today = startOfDay(new Date());
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  if (isSameDay(selectedDate, today)) {
    dateLabel.textContent = "Сегодня";
  } else if (isSameDay(selectedDate, yesterday)) {
    dateLabel.textContent = "Вчера";
  } else if (isSameDay(selectedDate, tomorrow)) {
    dateLabel.textContent = "Завтра";
  } else {
    dateLabel.textContent = new Intl.DateTimeFormat("ru-RU", { weekday: "long" }).format(selectedDate);
  }

  dateValue.textContent = formatDayTitle(selectedDate);
  todayButton.hidden = isSameDay(selectedDate, today);
}

function switchDay(offset) {
  saveSelectedDay();
  selectedDate = startOfDay(new Date(selectedDate.getFullYear(), selectedDate.getMonth(), selectedDate.getDate() + offset));
  selectedDateKey = dayKey(selectedDate);
  loadSelectedDay();
  renderDate();
  renderWater();
  renderDiary();
}

function goToday() {
  saveSelectedDay();
  selectedDate = startOfDay(new Date());
  selectedDateKey = dayKey(selectedDate);
  loadSelectedDay();
  renderDate();
  renderWater();
  renderDiary();
}

function scaledMeal() {
  return {
    ...currentMeal,
    calories: Math.round(currentMeal.calories * currentScale),
    protein: Math.round(currentMeal.protein * currentScale),
    fat: Math.round(currentMeal.fat * currentScale),
    carbs: Math.round(currentMeal.carbs * currentScale),
  };
}

function renderMeal() {
  const meal = scaledMeal();
  mealTitle.textContent = meal.title;
  confidence.textContent = `AI ${meal.confidence}%`;
  calories.textContent = meal.calories;
  protein.textContent = `${meal.protein}г`;
  fat.textContent = `${meal.fat}г`;
  carbs.textContent = `${meal.carbs}г`;
}

function renderMealType() {
  mealTypeButtons.forEach((button) => {
    button.classList.toggle("active", button.dataset.mealType === currentMealType);
  });
}

function formatCalories(value) {
  return new Intl.NumberFormat("ru-RU").format(value);
}

function formatWeight(value) {
  return new Intl.NumberFormat("ru-RU", { maximumFractionDigits: 1 }).format(value) + " кг";
}


function clampNumber(value, min, max, fallback) {
  if (String(value).trim() === "") return fallback;
  const number = Number(value);
  if (!Number.isFinite(number)) return fallback;
  return Math.min(max, Math.max(min, number));
}

function loadProfile() {
  try {
    profile = { ...profile, ...JSON.parse(localStorage.getItem("foodlens-profile") || "{}") };
  } catch {
    profile = { ...profile };
  }
  dailyGoal = clampNumber(localStorage.getItem("foodlens-goal") || calculateProfileCalories(), 1, 3000, 1900);
}

function saveProfile() {
  localStorage.setItem("foodlens-profile", JSON.stringify(profile));
  localStorage.setItem("foodlens-goal", String(dailyGoal));
}

function readProfileForm() {
  profile.weight = clampNumber(profileWeight.value, 30, 250, profile.weight);
  profile.height = clampNumber(profileHeight.value, 120, 230, profile.height);
  profile.age = clampNumber(profileAge.value, 12, 90, profile.age);
  profile.activity = clampNumber(profileActivity.value, 1.2, 1.9, profile.activity);
  profile.comment = profileComment.value.trim();
}

function calculateProfileCalories() {
  const base = profile.sex === "female"
    ? 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161
    : 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
  const goalShift = profile.goal === "lose" ? -350 : profile.goal === "gain" ? 300 : 0;
  return Math.round(Math.min(3000, Math.max(1, base * profile.activity + goalShift)));
}

function makeProfileInsight() {
  const goalText = profile.goal === "lose" ? "держим легкий дефицит" : profile.goal === "gain" ? "добавляем запас на набор" : "держим баланс без жестких ограничений";
  const proteinTarget = Math.round(profile.weight * (profile.goal === "gain" ? 1.8 : 1.6));
  const userNote = profile.comment ? " Учту: " + profile.comment : "";
  return "Норма пересчитана: " + formatCalories(dailyGoal) + " ккал, белок около " + proteinTarget + "г, " + goalText + "." + userNote;
}

function renderProfileSummary() {
  profileCalories.textContent = formatCalories(dailyGoal) + " ккал";
  profileInsight.textContent = makeProfileInsight();
}

function renderProfile() {
  profileWeight.value = profile.weight;
  profileHeight.value = profile.height;
  profileAge.value = profile.age;
  profileActivity.value = String(profile.activity);
  profileComment.value = profile.comment;
  renderProfileSummary();
  profileChoices.forEach((button) => {
    button.classList.toggle("active", profile[button.dataset.profileField] === button.dataset.value);
  });
}


function openProfile() {
  renderProfile();
  profilePanel.hidden = false;
  setTimeout(() => profileWeight.focus(), 80);
}

function closeProfile() {
  profilePanel.hidden = true;
}

function applyProfileGoal() {
  readProfileForm();
  dailyGoal = calculateProfileCalories();
  saveProfile();
  renderProfile();
  renderGoal();
  renderDiary();
}


function loadWater() {
  loadSelectedDay();
}

function saveWater() {
  saveSelectedDay();
}

function renderWater() {
  waterCountEl.textContent = waterCount;
  waterGoalEl.textContent = waterGoal;
  waterDots.innerHTML = Array.from({ length: waterGoal }, (_, index) => '<span class="' + (index < waterCount ? 'filled' : '') + '"></span>').join("");
  waterMinus.disabled = waterCount <= 0;
  waterPlus.disabled = waterCount >= waterGoal;
  if (waterCount === 0) {
    waterHint.textContent = "Начни с первого стакана воды.";
  } else if (waterCount < Math.ceil(waterGoal / 2)) {
    waterHint.textContent = "Хороший старт, держи воду рядом.";
  } else if (waterCount < waterGoal) {
    waterHint.textContent = "Больше половины цели уже есть.";
  } else {
    waterHint.textContent = "Цель по воде на сегодня закрыта.";
  }
}

function updateWater(nextValue) {
  waterCount = clampNumber(nextValue, 0, waterGoal, waterCount);
  saveWater();
  renderWater();
  renderSummary();
}

function renderGoal() {
  goalRange.value = dailyGoal;
  goalValue.textContent = formatCalories(dailyGoal);
  goalOutput.textContent = formatCalories(dailyGoal);
  goalPresetButtons.forEach((button) => button.classList.toggle("active", Number(button.dataset.goal) === dailyGoal));
}



function mealTypeLabel(type) {
  return mealTypes.find((item) => item.value === type)?.label || "Перекус";
}

function favoriteKey(meal) {
  return [meal.title, meal.calories, meal.protein, meal.fat, meal.carbs].join("|");
}

function isFavoriteMeal(meal) {
  return favorites.some((favorite) => favoriteKey(favorite) === favoriteKey(meal));
}

function loadFavorites() {
  try {
    favorites = JSON.parse(localStorage.getItem("foodlens-favorites") || "[]");
  } catch {
    favorites = [];
  }
}

function saveFavorites() {
  localStorage.setItem("foodlens-favorites", JSON.stringify(favorites));
}

function toggleFavoriteMeal(meal) {
  const key = favoriteKey(meal);
  const existingIndex = favorites.findIndex((favorite) => favoriteKey(favorite) === key);
  if (existingIndex >= 0) {
    favorites.splice(existingIndex, 1);
  } else {
    favorites = [{ ...meal, type: meal.type || currentMealType }, ...favorites];
  }
  saveFavorites();
  renderFavorites();
  renderDiary();
}

function renderFavorites() {
  if (!favorites.length) {
    favoritesList.innerHTML = '<li class="empty-state">Любимых блюд пока нет</li>';
    return;
  }

  favoritesList.innerHTML = favorites.map((meal, index) =>
    '<li class="favorite-item">' +
      '<div class="favorite-item-main">' +
        '<div><strong>' + escapeHtml(meal.title) + '</strong><span>' + mealTypeLabel(meal.type) + ' · ' + formatCalories(meal.calories) + ' ккал · Б ' + meal.protein + 'г / Ж ' + meal.fat + 'г / У ' + meal.carbs + 'г</span></div>' +
      '</div>' +
      '<div class="favorite-item-actions">' +
        '<button class="favorite-add" type="button" data-favorite-add="' + index + '">Добавить</button>' +
        '<button class="favorite-remove" type="button" data-favorite-remove="' + index + '">Удалить</button>' +
      '</div>' +
    '</li>'
  ).join("");
}

function openFavorites() {
  renderFavorites();
  favoritesPanel.hidden = false;
}

function closeFavorites() {
  favoritesPanel.hidden = true;
}

function getDailyTotals() {
  return diary.reduce((totals, meal) => ({
    calories: totals.calories + meal.calories,
    protein: totals.protein + meal.protein,
    fat: totals.fat + meal.fat,
    carbs: totals.carbs + meal.carbs,
  }), { calories: 0, protein: 0, fat: 0, carbs: 0 });
}

function macroTargets() {
  const proteinMultiplier = profile.goal === "gain" ? 1.7 : profile.goal === "lose" ? 1.5 : 1.3;
  const proteinByWeight = Math.round(profile.weight * proteinMultiplier);
  const proteinByCalories = Math.max(1, Math.round((dailyGoal * 0.34) / 4));
  const protein = Math.max(1, Math.min(proteinByWeight, proteinByCalories));
  const fatRatio = profile.goal === "lose" ? 0.25 : profile.goal === "gain" ? 0.28 : 0.3;
  const fat = Math.max(1, Math.round((dailyGoal * fatRatio) / 9));
  const carbsCalories = Math.max(dailyGoal - protein * 4 - fat * 9, dailyGoal * 0.18);
  const carbs = Math.max(1, Math.round(carbsCalories / 4));
  return { protein, fat, carbs };
}

function macroLeftText(value, target) {
  const left = target - value;
  if (left > 0) return "Осталось " + left + "г";
  if (left === 0) return "Цель закрыта";
  return "Выше на " + Math.abs(left) + "г";
}

function renderMacroGoal(kind, value, target, valueEl, goalEl, leftEl, progressEl) {
  valueEl.textContent = value;
  goalEl.textContent = target;
  leftEl.textContent = macroLeftText(value, target);
  progressEl.style.width = Math.min(100, Math.round((value / target) * 100)) + "%";
  progressEl.closest(".macro-goal").classList.toggle("over", value > target);
}

function makeDailyAdvice(totals) {
  if (!diary.length) return "Добавь первый прием пищи, и FoodLens соберет итог дня.";
  const remaining = dailyGoal - totals.calories;
  const targets = macroTargets();
  if (waterCount < Math.ceil(waterGoal / 2)) return "Воды пока мало. Добавь 1-2 стакана и держи бутылку рядом.";
  if (remaining < 0) return "Калории уже выше цели. Следующий прием лучше сделать легче и с овощами.";
  if (totals.protein < Math.round(targets.protein * 0.7)) return "Белка пока маловато. Подойдет курица, рыба, яйца, творог или бобовые.";
  if (remaining > 500) return "Есть запас по калориям. Можно запланировать нормальный прием пищи без спешки.";
  return "День идет ровно. Держи баланс и не забывай воду.";
}

function renderMacroGoals(totals) {
  const targets = macroTargets();
  renderMacroGoal("protein", totals.protein, targets.protein, macroProteinValue, macroProteinGoal, macroProteinLeft, macroProteinProgress);
  renderMacroGoal("fat", totals.fat, targets.fat, macroFatValue, macroFatGoal, macroFatLeft, macroFatProgress);
  renderMacroGoal("carbs", totals.carbs, targets.carbs, macroCarbsValue, macroCarbsGoal, macroCarbsLeft, macroCarbsProgress);

  const progress = Math.round(((Math.min(totals.protein / targets.protein, 1) + Math.min(totals.fat / targets.fat, 1) + Math.min(totals.carbs / targets.carbs, 1)) / 3) * 100);
  const hasOver = totals.protein > targets.protein || totals.fat > targets.fat || totals.carbs > targets.carbs;
  macroBalanceBadge.textContent = diary.length ? progress + "% БЖУ" : "Пока пусто";
  macroBalanceBadge.classList.toggle("over", hasOver);
}

function renderSummary() {
  const totals = getDailyTotals();
  const progress = Math.round((totals.calories / dailyGoal) * 100);
  summaryProtein.textContent = totals.protein + "г";
  summaryFat.textContent = totals.fat + "г";
  summaryCarbs.textContent = totals.carbs + "г";
  summaryWater.textContent = waterCount + "/" + waterGoal;
  summaryStatus.textContent = diary.length ? Math.min(100, progress) + "% цели" : "Пока пусто";
  summaryStatus.classList.toggle("over", totals.calories > dailyGoal);
  if (totals.calories > dailyGoal) summaryStatus.textContent = "Выше цели";
  renderMacroGoals(totals);
  summaryAdvice.textContent = makeDailyAdvice(totals);
}

function proteinTarget() {
  return macroTargets().protein;
}

function makeAiGreeting() {
  return "Привет. Я помогу разобрать питание, подобрать следующий прием пищи, добрать белок и держать цель без жестких диет.";
}

function loadAiMessages() {
  try {
    aiMessages = JSON.parse(localStorage.getItem("foodlens-ai-chat") || "[]");
  } catch {
    aiMessages = [];
  }

  if (!Array.isArray(aiMessages) || !aiMessages.length) {
    aiMessages = [{ id: Date.now(), role: "assistant", text: makeAiGreeting(), createdAt: Date.now() }];
    saveAiMessages();
  }
}

function saveAiMessages() {
  localStorage.setItem("foodlens-ai-chat", JSON.stringify(aiMessages.slice(-40)));
}

function recentMealText() {
  if (!diary.length) return "В дневнике пока нет еды.";
  return "В дневнике уже есть: " + diary.slice(0, 3).map((meal) => meal.title).join(", ") + ".";
}

function makeNextMealAdvice(remaining, proteinLeft) {
  const proteinLine = proteinLeft > 15 ? " Белка не хватает примерно " + proteinLeft + "г, поэтому лучше сделать упор на мясо, рыбу, яйца, творог или бобовые." : " По белку день выглядит нормально, можно держать легкий баланс.";

  if (remaining <= 0) {
    return "Калории уже выше цели на " + formatCalories(Math.abs(remaining)) + " ккал. Без паники: следующий прием лучше сделать легким — овощи плюс белок, без сладких напитков и большого гарнира." + proteinLine;
  }

  if (remaining < 300) {
    return "Запас небольшой: " + formatCalories(remaining) + " ккал. Подойдет творог, йогурт без сахара, яйца, рыба или салат с курицей." + proteinLine;
  }

  if (remaining < 700) {
    return "Можно нормальный спокойный прием на " + formatCalories(remaining) + " ккал: белок, овощи и небольшая порция крупы или картофеля." + proteinLine;
  }

  return "Запас хороший: " + formatCalories(remaining) + " ккал. Можно собрать полноценный прием: белок, гарнир, овощи и немного жиров, чтобы не тянуло на перекусы." + proteinLine;
}

function buildAiReply(question) {
  const lower = question.toLowerCase();
  const totals = getDailyTotals();
  const remaining = dailyGoal - totals.calories;
  const proteinLeft = Math.max(0, proteinTarget() - totals.protein);
  const waterLine = waterCount < Math.ceil(waterGoal / 2) ? "Воды пока маловато: " + waterCount + "/" + waterGoal + ". Добавь 1-2 стакана в ближайшее время." : "По воде сейчас " + waterCount + "/" + waterGoal + ", уже неплохо.";

  if (lower.includes("бел")) {
    if (proteinLeft <= 0) return "Белка на сегодня уже достаточно: " + totals.protein + "г. Дальше можно держать еду легче: овощи, крупы по цели и без лишних перекусов.";
    return "Чтобы добрать белок, осталось примерно " + proteinLeft + "г. Самые простые варианты: 150-200г курицы или рыбы, 200г творога, 3 яйца с белками, греческий йогурт или бобовые. " + recentMealText();
  }

  if (lower.includes("вод")) {
    return waterLine + " Хороший ориентир — пить небольшими порциями, а не пытаться закрыть всю воду вечером.";
  }

  if (lower.includes("сор") || lower.includes("мотива") || lower.includes("слад") || lower.includes("голод")) {
    return "Давай без жесткого запрета. Сначала нормальный прием пищи с белком и клетчаткой, потом решаем по сладкому. Часто срыв начинается не из-за слабости, а из-за слишком голодного дня. " + makeNextMealAdvice(remaining, proteinLeft);
  }

  if (lower.includes("что") || lower.includes("съесть") || lower.includes("ужин") || lower.includes("обед") || lower.includes("завтрак") || lower.includes("перекус")) {
    return makeNextMealAdvice(remaining, proteinLeft);
  }

  if (lower.includes("разбер") || lower.includes("анализ") || lower.includes("день") || lower.includes("итог")) {
    const calorieLine = remaining >= 0 ? "Осталось " + formatCalories(remaining) + " ккал до цели." : "Цель превышена на " + formatCalories(Math.abs(remaining)) + " ккал.";
    return "Сейчас: " + formatCalories(totals.calories) + " из " + formatCalories(dailyGoal) + " ккал. " + calorieLine + " Белки " + totals.protein + "г, жиры " + totals.fat + "г, углеводы " + totals.carbs + "г. " + waterLine + " " + makeDailyAdvice(totals);
  }

  return "Я смотрю на текущий день: " + formatCalories(totals.calories) + " из " + formatCalories(dailyGoal) + " ккал. " + recentMealText() + " " + makeNextMealAdvice(remaining, proteinLeft);
}

function renderAiChat() {
  if (!aiMessages.length) aiMessages = [{ id: Date.now(), role: "assistant", text: makeAiGreeting(), createdAt: Date.now() }];

  aiChatList.innerHTML = aiMessages.map((message) => {
    const role = message.role === "user" ? "user" : "assistant";
    const label = role === "user" ? "Ты" : "FoodLens AI";
    return '<article class="ai-message ' + role + '"><span>' + label + '</span><p>' + escapeHtml(message.text) + '</p></article>';
  }).join("");
  aiChatList.scrollTop = aiChatList.scrollHeight;
}

function openAiChat() {
  renderAiChat();
  aiPanel.hidden = false;
  setTimeout(() => aiInput.focus(), 80);
}

function closeAiChat() {
  aiPanel.hidden = true;
}

function sendAiPrompt(text) {
  const clean = text.trim();
  if (!clean) return;
  aiMessages = [...aiMessages, { id: Date.now(), role: "user", text: clean, createdAt: Date.now() }];
  aiMessages = [...aiMessages, { id: Date.now() + 1, role: "assistant", text: buildAiReply(clean), createdAt: Date.now() }].slice(-40);
  saveAiMessages();
  renderAiChat();
}

function renderDiary() {
  saveSelectedDay();
  const total = diary.reduce((sum, meal) => sum + meal.calories, 0);
  const remaining = dailyGoal - total;
  dailyTotal.textContent = formatCalories(total);
  remainingRow.classList.toggle("over", remaining < 0);
  remainingLabel.textContent = remaining < 0 ? "Превышено сегодня" : "Осталось на сегодня";
  remainingCalories.textContent = formatCalories(Math.abs(remaining));
  goalProgress.style.width = `${Math.min(100, Math.round((total / dailyGoal) * 100))}%`;
  renderSummary();

  if (!diary.length) {
    mealList.innerHTML = '<li class="empty-state">Сохрани первый прием пищи</li>';
    return;
  }

  mealList.innerHTML = mealTypes
    .map((type) => {
      const items = diary
        .map((meal, index) => ({ meal, index }))
        .filter(({ meal }) => (meal.type || "snack") === type.value);

      if (!items.length) return "";

      const typeTotal = items.reduce((sum, item) => sum + item.meal.calories, 0);
      const mealsHtml = items.map(({ meal, index }) => `
        <li class="meal-item">
          <div><strong>${meal.title}</strong><span>Б ${meal.protein}г / Ж ${meal.fat}г / У ${meal.carbs}г</span></div>
          <div class="meal-actions">
            <strong>${meal.calories}</strong>
            <button class="meal-favorite ${isFavoriteMeal(meal) ? "active" : ""}" type="button" data-favorite-meal-index="${index}" aria-label="В любимые">★</button>
            <button class="meal-delete" type="button" data-meal-index="${index}" aria-label="Удалить запись">×</button>
          </div>
        </li>
      `).join("");

      return `
        <li class="meal-group">
          <div class="meal-group-title"><span>${type.label}</span><strong>${formatCalories(typeTotal)} ккал</strong></div>
          <ul class="meal-group-list">${mealsHtml}</ul>
        </li>
      `;
    })
    .join("");
}

async function startCamera() {
  if (!navigator.mediaDevices?.getUserMedia) {
    cameraStatus.textContent = "Камера недоступна, можно выбрать фото";
    return;
  }

  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: false });
    cameraFeed.srcObject = stream;
    cameraFeed.classList.add("active");
    cameraPlaceholder.style.display = "none";
    cameraStatus.textContent = "Наведи камеру на еду";
  } catch {
    cameraStatus.textContent = "Камера не открылась, включен демо-режим";
  }
}


function loadNotes() {
  try {
    notes = JSON.parse(localStorage.getItem("foodlens-notes") || "[]");
  } catch {
    notes = [];
  }
}

function saveNotes() {
  localStorage.setItem("foodlens-notes", JSON.stringify(notes));
}

function formatNoteDate(timestamp) {
  return new Intl.DateTimeFormat("ru-RU", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" }).format(new Date(timestamp));
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"]/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;" })[char]);
}

function renderNotes() {
  if (!notes.length) {
    notesList.innerHTML = '<li class="empty-state">Записей пока нет</li>';
    return;
  }

  notesList.innerHTML = notes.map((note) =>
    '<li class="note-item">' +
      '<div class="note-meta">' +
        '<span>' + formatNoteDate(note.createdAt) + '</span>' +
        '<button class="note-delete" type="button" data-note-id="' + note.id + '">Удалить</button>' +
      '</div>' +
      '<p>' + escapeHtml(note.text) + '</p>' +
    '</li>'
  ).join("");
}

function openNotes() {
  notesPanel.hidden = false;
  document.body.classList.add("notes-open");
  setTimeout(() => noteInput.focus(), 80);
}

function closeNotes() {
  notesPanel.hidden = true;
  document.body.classList.remove("notes-open");
}


function loadWeightEntries() {
  try {
    weightEntries = JSON.parse(localStorage.getItem("foodlens-weights") || "[]");
  } catch {
    weightEntries = [];
  }
  weightEntries.sort((a, b) => b.createdAt - a.createdAt);
}

function saveWeightEntries() {
  localStorage.setItem("foodlens-weights", JSON.stringify(weightEntries));
}

function latestWeightValue() {
  return weightEntries[0]?.value || profile.weight;
}

function weightDelta() {
  if (weightEntries.length < 2) return null;
  return Number((weightEntries[0].value - weightEntries[weightEntries.length - 1].value).toFixed(1));
}

function makeWeightInsight() {
  if (!weightEntries.length) {
    return "Добавь первую запись веса, и FoodLens начнет смотреть динамику.";
  }

  if (weightEntries.length === 1) {
    return "Первая точка есть. Для анализа лучше записывать вес 2-4 раза в неделю утром.";
  }

  const delta = weightDelta();
  const absDelta = Math.abs(delta);
  const direction = delta < 0 ? "снизился" : delta > 0 ? "вырос" : "стоит ровно";
  const goalAdvice = {
    lose: delta < -0.2 ? "Для похудения направление хорошее, главное не гнать темп слишком резко." : delta > 0.2 ? "Если цель похудеть, проверь соль, воду и средние калории за неделю." : "Для похудения пока держим спокойный режим и смотрим среднюю за неделю.",
    maintain: absDelta <= 0.4 ? "Для поддержания это нормальная стабильность." : "Для поддержания стоит слегка подровнять калории и режим сна.",
    gain: delta > 0.2 ? "Для набора направление хорошее, держи белок и тренировки." : "Для набора можно добавить немного калорий, если вес долго не растет.",
  }[profile.goal];

  return "С последней серии записей вес " + direction + " на " + formatWeight(absDelta) + ". " + goalAdvice;
}

function renderWeights() {
  const latest = latestWeightValue();
  const delta = weightDelta();
  currentWeight.textContent = formatWeight(latest);
  weightTrend.textContent = delta === null ? "пока нет" : (delta > 0 ? "+" : delta < 0 ? "-" : "") + formatWeight(Math.abs(delta));
  weightInsight.textContent = makeWeightInsight();

  if (document.activeElement !== weightInput) {
    weightInput.value = latest;
  }

  if (!weightEntries.length) {
    weightList.innerHTML = '<li class="empty-state">Записей веса пока нет</li>';
    return;
  }

  weightList.innerHTML = weightEntries.map((entry) =>
    '<li class="weight-item">' +
      '<div>' +
        '<span>' + formatNoteDate(entry.createdAt) + '</span>' +
        '<strong>' + formatWeight(entry.value) + '</strong>' +
        (entry.note ? '<p>' + escapeHtml(entry.note) + '</p>' : '') +
      '</div>' +
      '<button class="weight-delete" type="button" data-weight-id="' + entry.id + '">Удалить</button>' +
    '</li>'
  ).join("");
}

function openWeight() {
  renderWeights();
  weightPanel.hidden = false;
  setTimeout(() => weightInput.focus(), 80);
}

function closeWeight() {
  weightPanel.hidden = true;
}

function applyLatestWeightToProfile(value) {
  profile.weight = value;
  dailyGoal = calculateProfileCalories();
  saveProfile();
  renderProfile();
  renderGoal();
  renderDiary();
}


function renderManualType() {
  manualTypeButtons.forEach((button) => {
    button.classList.toggle("active", button.dataset.manualType === currentManualType);
  });
}

function estimateManualMeal(text) {
  const clean = text.trim();
  if (!clean) return null;
  const lower = clean.toLowerCase();
  let calories = 260;
  if (/кур|мяс|рыб|яйц|творог|сыр/.test(lower)) calories += 140;
  if (/рис|греч|паст|макарон|хлеб|овсян|карто/.test(lower)) calories += 180;
  if (/масл|соус|майон|авокад|орех/.test(lower)) calories += 160;
  if (/салат|овощ|огур|помид|зел/.test(lower)) calories -= 60;
  const gramMatches = clean.match(/\d+/g) || [];
  const grams = gramMatches.map(Number).filter((value) => value >= 50 && value <= 800);
  if (grams.length) calories += Math.min(260, Math.round((grams.reduce((sum, value) => sum + value, 0) - 250) * 0.45));
  calories = Math.max(120, Math.min(1100, Math.round(calories)));
  return {
    title: clean.length > 48 ? clean.slice(0, 45) + "..." : clean,
    confidence: 72,
    calories,
    protein: Math.max(5, Math.round(calories * 0.06)),
    fat: Math.max(4, Math.round(calories * 0.035)),
    carbs: Math.max(8, Math.round(calories * 0.12)),
  };
}

function renderManualPreview() {
  const meal = estimateManualMeal(manualInput.value);
  if (!meal) {
    manualPreview.innerHTML = '<span>Демо-расчет</span><strong>Введите еду</strong>';
    return;
  }
  manualPreview.innerHTML = '<span>Демо-расчет</span><strong>' + formatCalories(meal.calories) + ' ккал</strong><small>Б ' + meal.protein + 'г / Ж ' + meal.fat + 'г / У ' + meal.carbs + 'г</small>';
}

function openManual() {
  currentManualType = currentMealType;
  renderManualType();
  renderManualPreview();
  manualPanel.hidden = false;
  setTimeout(() => manualInput.focus(), 80);
}

function closeManual() {
  manualPanel.hidden = true;
}

function resetPortion() {
  currentScale = 1;
  portionButtons.forEach((button) => button.classList.toggle("active", button.dataset.scale === "1"));
}

function pickDemoMeal() {
  currentMeal = { ...meals[Math.floor(Math.random() * meals.length)] };
  resetPortion();
  renderMeal();
}

function scanFood() {
  scanButton.classList.add("loading");
  scanButton.textContent = "Анализирую...";
  cameraStatus.textContent = "AI оценивает блюдо и порцию";

  setTimeout(() => {
    pickDemoMeal();
    scanButton.classList.remove("loading");
    scanButton.innerHTML = '<span class="scan-dot"></span>Сканировать еду';
    cameraStatus.textContent = "Готово, можно сохранить в дневник";
  }, 900);
}


profileButton.addEventListener("click", openProfile);
profileBackdrop.addEventListener("click", closeProfile);
profileClose.addEventListener("click", closeProfile);

portionButtons.forEach((button) => {
  button.addEventListener("click", () => {
    currentScale = Number(button.dataset.scale);
    portionButtons.forEach((item) => item.classList.toggle("active", item === button));
    renderMeal();
  });
});

mealTypeButtons.forEach((button) => {
  button.addEventListener("click", () => {
    currentMealType = button.dataset.mealType;
    renderMealType();
  });
});


profileChoices.forEach((button) => {
  button.addEventListener("click", () => {
    profile[button.dataset.profileField] = button.dataset.value;
    applyProfileGoal();
  });
});

[profileWeight, profileHeight, profileAge, profileActivity, profileComment].forEach((field) => {
  field.addEventListener("input", () => {
    readProfileForm();
    dailyGoal = calculateProfileCalories();
    renderProfileSummary();
    renderGoal();
    renderDiary();
  });
});

profileSave.addEventListener("click", () => {
  applyProfileGoal();
  closeProfile();
  cameraStatus.textContent = "Профиль сохранен";
  TelegramApp?.HapticFeedback?.notificationOccurred("success");
});

prevDay.addEventListener("click", () => switchDay(-1));
nextDay.addEventListener("click", () => switchDay(1));
todayButton.addEventListener("click", goToday);

scanButton.addEventListener("click", scanFood);
manualButton.addEventListener("click", openManual);
photoButton.addEventListener("click", () => photoInput.click());

waterMinus.addEventListener("click", () => updateWater(waterCount - 1));
waterPlus.addEventListener("click", () => updateWater(waterCount + 1));

themeButton.addEventListener("click", () => {
  const nextTheme = document.body.dataset.theme === "dark" ? "light" : "dark";
  document.body.dataset.theme = nextTheme;
  localStorage.setItem("foodlens-theme", nextTheme);
});

goalRange.addEventListener("input", () => {
  dailyGoal = Number(goalRange.value);
  localStorage.setItem("foodlens-goal", String(dailyGoal));
  renderGoal();
  renderDiary();
  renderProfile();
});

goalPresetButtons.forEach((button) => {
  button.addEventListener("click", () => {
    dailyGoal = Number(button.dataset.goal);
    localStorage.setItem("foodlens-goal", String(dailyGoal));
    renderGoal();
    renderDiary();
    renderProfile();
  });
});




manualBackdrop.addEventListener("click", closeManual);
manualClose.addEventListener("click", closeManual);
manualInput.addEventListener("input", renderManualPreview);
manualTypeButtons.forEach((button) => {
  button.addEventListener("click", () => {
    currentManualType = button.dataset.manualType;
    renderManualType();
  });
});
manualSave.addEventListener("click", () => {
  const meal = estimateManualMeal(manualInput.value);
  if (!meal) return;
  diary = [{ ...meal, type: currentManualType }, ...diary];
  manualInput.value = "";
  renderManualPreview();
  renderDiary();
  closeManual();
  cameraStatus.textContent = "Добавлено вручную";
  TelegramApp?.HapticFeedback?.notificationOccurred("success");
});


favoritesButton.addEventListener("click", openFavorites);
favoritesBackdrop.addEventListener("click", closeFavorites);
favoritesClose.addEventListener("click", closeFavorites);

aiButton.addEventListener("click", openAiChat);
aiBackdrop.addEventListener("click", closeAiChat);
aiClose.addEventListener("click", closeAiChat);
aiChatForm.addEventListener("submit", (event) => {
  event.preventDefault();
  sendAiPrompt(aiInput.value);
  aiInput.value = "";
});
aiPromptButtons.forEach((button) => {
  button.addEventListener("click", () => sendAiPrompt(button.dataset.aiPrompt));
});

favoritesList.addEventListener("click", (event) => {
  const addButton = event.target.closest("[data-favorite-add]");
  const removeButton = event.target.closest("[data-favorite-remove]");

  if (addButton) {
    const favorite = favorites[Number(addButton.dataset.favoriteAdd)];
    if (!favorite) return;
    diary = [{ ...favorite, type: favorite.type || currentMealType }, ...diary];
    renderDiary();
    saveSelectedDay();
    closeFavorites();
    cameraStatus.textContent = "Любимое добавлено";
    TelegramApp?.HapticFeedback?.notificationOccurred("success");
    return;
  }

  if (removeButton) {
    favorites.splice(Number(removeButton.dataset.favoriteRemove), 1);
    saveFavorites();
    renderFavorites();
    renderDiary();
  }
});

weightButton.addEventListener("click", openWeight);
weightBackdrop.addEventListener("click", closeWeight);
weightClose.addEventListener("click", closeWeight);

weightSave.addEventListener("click", () => {
  const value = Math.round(clampNumber(weightInput.value, 30, 250, profile.weight) * 10) / 10;
  const note = weightNote.value.trim();
  weightEntries = [{ id: Date.now(), value, note, createdAt: Date.now() }, ...weightEntries];
  weightNote.value = "";
  saveWeightEntries();
  applyLatestWeightToProfile(value);
  renderWeights();
  cameraStatus.textContent = "Вес сохранен";
  TelegramApp?.HapticFeedback?.notificationOccurred("success");
});

weightList.addEventListener("click", (event) => {
  const deleteButton = event.target.closest("[data-weight-id]");
  if (!deleteButton) return;
  weightEntries = weightEntries.filter((entry) => String(entry.id) !== deleteButton.dataset.weightId);
  saveWeightEntries();
  if (weightEntries.length) {
    applyLatestWeightToProfile(weightEntries[0].value);
  }
  renderWeights();
});

notesButton.addEventListener("click", openNotes);
notesBackdrop.addEventListener("click", closeNotes);
notesClose.addEventListener("click", closeNotes);

noteSave.addEventListener("click", () => {
  const text = noteInput.value.trim();
  if (!text) return;
  notes = [{ id: Date.now(), text, createdAt: Date.now() }, ...notes];
  noteInput.value = "";
  saveNotes();
  renderNotes();
  TelegramApp?.HapticFeedback?.notificationOccurred("success");
});

notesList.addEventListener("click", (event) => {
  const deleteButton = event.target.closest("[data-note-id]");
  if (!deleteButton) return;
  notes = notes.filter((note) => String(note.id) !== deleteButton.dataset.noteId);
  saveNotes();
  renderNotes();
});

photoInput.addEventListener("change", () => {
  if (!photoInput.files?.[0]) return;
  const imageUrl = URL.createObjectURL(photoInput.files[0]);
  cameraPlaceholder.style.display = "block";
  cameraPlaceholder.innerHTML = `<img src="${imageUrl}" alt="" class="uploaded-photo" />`;
  cameraStatus.textContent = "Фото выбрано, нажми сканировать";
});

mealList.addEventListener("click", (event) => {
  const favoriteButton = event.target.closest("[data-favorite-meal-index]");
  const deleteButton = event.target.closest("[data-meal-index]");

  if (favoriteButton) {
    const meal = diary[Number(favoriteButton.dataset.favoriteMealIndex)];
    if (meal) toggleFavoriteMeal(meal);
    return;
  }

  if (!deleteButton) return;
  diary.splice(Number(deleteButton.dataset.mealIndex), 1);
  renderDiary();
  saveSelectedDay();
});

saveButton.addEventListener("click", () => {
  diary = [{ ...scaledMeal(), type: currentMealType }, ...diary];
  renderDiary();
  saveSelectedDay();
  cameraStatus.textContent = "Добавлено в дневник";
  TelegramApp?.HapticFeedback?.notificationOccurred("success");
});

document.body.dataset.theme = localStorage.getItem("foodlens-theme") || "light";
loadProfile();
loadDayStore();
loadWater();
loadNotes();
loadFavorites();
loadWeightEntries();
loadAiMessages();
renderDate();
renderNotes();
renderFavorites();
renderWeights();
renderAiChat();
renderProfile();
renderWater();
renderSummary();
renderGoal();
renderMeal();
renderMealType();
renderManualType();
renderDiary();
startCamera();
