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
let cameraStream = null;
let hasUploadedPhoto = false;
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
  if (cameraStream) return true;

  if (!navigator.mediaDevices?.getUserMedia) {
    cameraStatus.textContent = "Камера недоступна, можно выбрать фото";
    return false;
  }

  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: false });
    cameraStream = stream;
    cameraFeed.srcObject = stream;
    cameraFeed.classList.add("active");
    cameraPlaceholder.style.display = "none";
    cameraStatus.textContent = "Наведи камеру на еду";
    return true;
  } catch {
    cameraStatus.textContent = "Камера не открылась, включен демо-режим";
    return false;
  }
}

function stopCamera() {
  if (!cameraStream) return;
  cameraStream.getTracks().forEach((track) => track.stop());
  cameraStream = null;
  cameraFeed.srcObject = null;
  cameraFeed.classList.remove("active");
  if (!hasUploadedPhoto) {
    cameraPlaceholder.style.display = "grid";
    cameraStatus.textContent = "Камера выключена";
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

async function scanFood() {
  if (!hasUploadedPhoto) {
    await startCamera();
  }

  scanButton.classList.add("loading");
  scanButton.textContent = "Анализирую...";
  cameraStatus.textContent = "AI оценивает блюдо и порцию";

  setTimeout(() => {
    pickDemoMeal();
    scanButton.classList.remove("loading");
    scanButton.innerHTML = '<span class="scan-dot"></span>Сканировать еду';
    cameraStatus.textContent = "Готово, можно сохранить в дневник";
    stopCamera();
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
  stopCamera();
  hasUploadedPhoto = true;
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

<!doctype html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
    <title>FoodLens</title>
    <link rel="stylesheet" href="./styles.css" />
  </head>
  <body>
    <main class="app-shell">
      <section class="camera-section" aria-label="Сканирование еды">
        <div class="topbar">
          <div>
            <p class="eyebrow">AI питание</p>
            <h1>FoodLens</h1>
          </div>
          <div class="top-actions">
            <button class="profile-button" id="profileButton" type="button" aria-label="Профиль"><span class="profile-icon" aria-hidden="true"></span></button>
            <button class="theme-button" id="themeButton" type="button" aria-label="Сменить тему"><span class="theme-icon" aria-hidden="true"></span></button>
          </div>
        </div>

        <div class="camera-frame">
          <video id="cameraFeed" class="camera-feed" autoplay muted playsinline></video>
          <div class="camera-placeholder" id="cameraPlaceholder">
            <div class="plate">
              <span class="food rice"></span>
              <span class="food chicken"></span>
              <span class="food greens"></span>
              <span class="food tomato"></span>
            </div>
          </div>
          <div class="scan-guides" aria-hidden="true"><span></span><span></span><span></span><span></span></div>
          <div class="camera-status" id="cameraStatus">Камера выключена</div>
        </div>

        <div class="scan-actions">
          <button class="secondary-button" id="manualButton" type="button">Вручную</button>
          <button class="scan-button" id="scanButton" type="button"><span class="scan-dot"></span>Сканировать еду</button>
          <button class="secondary-button" id="photoButton" type="button">Фото</button>
        </div>
        <input id="photoInput" type="file" accept="image/*" capture="environment" hidden />
      </section>

      <section class="result-section" aria-label="Результат анализа">
        <div class="section-header">
          <div>
            <p class="eyebrow">Результат</p>
            <h2 id="mealTitle">Курица, рис и салат</h2>
          </div>
          <span class="confidence" id="confidence">AI 87%</span>
        </div>

        <div class="calorie-card">
          <div>
            <span class="metric-label">Примерно</span>
            <strong id="calories">640</strong>
            <span class="metric-unit">ккал</span>
          </div>
          <div class="macro-grid">
            <div><span>Белки</span><strong id="protein">42г</strong></div>
            <div><span>Жиры</span><strong id="fat">18г</strong></div>
            <div><span>Углеводы</span><strong id="carbs">73г</strong></div>
          </div>
        </div>

        <div class="portion-control">
          <span class="control-label">Порция</span>
          <div class="segment-control" role="group" aria-label="Размер порции">
            <button class="portion-button" type="button" data-scale="0.75">Меньше</button>
            <button class="portion-button active" type="button" data-scale="1">Средняя</button>
            <button class="portion-button" type="button" data-scale="1.3">Больше</button>
          </div>
        </div>

        <div class="meal-type-control">
          <span class="control-label">Прием пищи</span>
          <div class="segment-control meal-type-segments" role="group" aria-label="Прием пищи">
            <button class="meal-type-button active" type="button" data-meal-type="breakfast">Завтрак</button>
            <button class="meal-type-button" type="button" data-meal-type="lunch">Обед</button>
            <button class="meal-type-button" type="button" data-meal-type="dinner">Ужин</button>
            <button class="meal-type-button" type="button" data-meal-type="snack">Перекус</button>
          </div>
        </div>

        <button class="save-button" id="saveButton" type="button">Добавить в дневник</button>
      </section>

      <section class="daily-section" aria-label="Дневник питания">
        <div class="section-header">
          <div>
            <p class="eyebrow">История</p>
            <h2>Дневник</h2>
          </div>
          <div class="daily-total"><strong id="dailyTotal">0</strong><span>ккал</span></div>
        </div>

        <div class="date-switcher" id="dateSwitcher">
          <button type="button" id="prevDay" aria-label="Предыдущий день">‹</button>
          <div>
            <span id="dateLabel">Сегодня</span>
            <strong id="dateValue">Сегодня</strong>
          </div>
          <button type="button" id="nextDay" aria-label="Следующий день">›</button>
          <button class="today-button" type="button" id="todayButton">Сегодня</button>
        </div>

        <div class="goal-card">
          <div class="goal-topline">
            <div><span class="metric-label">Цель дня</span><strong><span id="goalValue">1 900</span> ккал</strong></div>
            <output class="goal-output" id="goalOutput" for="goalRange">1900</output>
          </div>
          <div class="remaining-row" id="remainingRow">
            <span id="remainingLabel">Осталось на сегодня</span>
            <strong><span id="remainingCalories">1 900</span> ккал</strong>
          </div>
          <input class="goal-range" id="goalRange" type="range" min="1" max="3000" step="1" value="1900" />
          <div class="goal-presets" aria-label="Быстрый выбор калорий">
            <button type="button" data-goal="1500">1500</button>
            <button type="button" data-goal="1900">1900</button>
            <button type="button" data-goal="2300">2300</button>
            <button type="button" data-goal="3000">3000</button>
          </div>
          <div class="progress-track" aria-hidden="true"><span id="goalProgress"></span></div>
        </div>

        <div class="macro-goals-card" id="macroGoalsCard">
          <div class="macro-goals-header">
            <div>
              <span class="metric-label">Цели БЖУ</span>
              <strong>На день</strong>
            </div>
            <span class="macro-balance-badge" id="macroBalanceBadge">Пока пусто</span>
          </div>

          <div class="macro-goal-list">
            <div class="macro-goal protein">
              <div class="macro-goal-top"><span>Белки</span><strong><span id="macroProteinValue">0</span>/<span id="macroProteinGoal">0</span><span class="macro-unit">г</span></strong></div>
              <div class="macro-goal-track" aria-hidden="true"><span id="macroProteinProgress"></span></div>
              <small id="macroProteinLeft">Осталось 0г</small>
            </div>
            <div class="macro-goal fat">
              <div class="macro-goal-top"><span>Жиры</span><strong><span id="macroFatValue">0</span>/<span id="macroFatGoal">0</span><span class="macro-unit">г</span></strong></div>
              <div class="macro-goal-track" aria-hidden="true"><span id="macroFatProgress"></span></div>
              <small id="macroFatLeft">Осталось 0г</small>
            </div>
            <div class="macro-goal carbs">
              <div class="macro-goal-top"><span>Углеводы</span><strong><span id="macroCarbsValue">0</span>/<span id="macroCarbsGoal">0</span><span class="macro-unit">г</span></strong></div>
              <div class="macro-goal-track" aria-hidden="true"><span id="macroCarbsProgress"></span></div>
              <small id="macroCarbsLeft">Осталось 0г</small>
            </div>
          </div>
        </div>

        <div class="water-card">
          <div class="water-topline">
            <div>
              <span class="metric-label">Вода</span>
              <strong><span id="waterCount">0</span> / <span id="waterGoal">8</span> стаканов</strong>
            </div>
            <div class="water-actions">
              <button type="button" id="waterMinus" aria-label="Убрать стакан">−</button>
              <button type="button" id="waterPlus" aria-label="Добавить стакан">+</button>
            </div>
          </div>
          <div class="water-dots" id="waterDots" aria-hidden="true"></div>
          <p id="waterHint">Начни с первого стакана воды.</p>
        </div>

        <div class="daily-summary">
          <div class="section-header summary-header">
            <div>
              <p class="eyebrow">Итог</p>
              <h2>День</h2>
            </div>
            <span class="summary-badge" id="summaryStatus">Пока пусто</span>
          </div>
          <div class="summary-grid">
            <div><span>Белки</span><strong id="summaryProtein">0г</strong></div>
            <div><span>Жиры</span><strong id="summaryFat">0г</strong></div>
            <div><span>Углеводы</span><strong id="summaryCarbs">0г</strong></div>
            <div><span>Вода</span><strong id="summaryWater">0/8</strong></div>
          </div>
          <div class="summary-advice">
            <span>Совет</span>
            <p id="summaryAdvice">Добавь первый прием пищи, и FoodLens соберет итог дня.</p>
          </div>
        </div>

        <ul class="meal-list" id="mealList"><li class="empty-state">Сохрани первый прием пищи</li></ul>
      </section>
    </main>

    <div class="bottom-actions" aria-label="Быстрые действия">
      <button class="bottom-action notes-launcher" id="notesButton" type="button" aria-label="Блокнот">
        <span class="notebook-icon" aria-hidden="true"></span>
        <span>Блокнот</span>
      </button>
      <button class="bottom-action weight-launcher" id="weightButton" type="button" aria-label="Вес">
        <span class="weight-icon" aria-hidden="true"></span>
        <span>Вес</span>
      </button>
      <button class="bottom-action favorites-launcher" id="favoritesButton" type="button" aria-label="Любимые блюда">
        <span class="favorite-icon" aria-hidden="true">★</span>
        <span>Любимые</span>
      </button>
      <button class="bottom-action ai-launcher" id="aiButton" type="button" aria-label="Общение с ИИ">
        <span class="ai-chat-icon" aria-hidden="true"></span>
        <span>ИИ чат</span>
      </button>
    </div>

    <section class="ai-panel" id="aiPanel" aria-label="Общение с ИИ" hidden>
      <button class="ai-backdrop" id="aiBackdrop" type="button" aria-label="Закрыть чат с ИИ"></button>
      <div class="ai-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">FoodLens</p>
            <h2>ИИ чат</h2>
          </div>
          <button class="close-button" id="aiClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <div class="ai-chat-list" id="aiChatList"></div>

        <div class="ai-quick-actions" aria-label="Быстрые вопросы">
          <button type="button" data-ai-prompt="Разбери мой день по еде">Разбор дня</button>
          <button type="button" data-ai-prompt="Что лучше съесть дальше?">Что съесть?</button>
          <button type="button" data-ai-prompt="Как добрать белок?">Добрать белок</button>
          <button type="button" data-ai-prompt="Помоги не сорваться">Не сорваться</button>
        </div>

        <form class="ai-chat-form" id="aiChatForm">
          <input id="aiInput" type="text" placeholder="Спроси про еду, диету или цель" autocomplete="off" />
          <button type="submit" aria-label="Отправить">➜</button>
        </form>
      </div>
    </section>

    <section class="favorites-panel" id="favoritesPanel" aria-label="Любимые блюда" hidden>
      <button class="favorites-backdrop" id="favoritesBackdrop" type="button" aria-label="Закрыть любимые"></button>
      <div class="favorites-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">Быстро</p>
            <h2>Любимые</h2>
          </div>
          <button class="close-button" id="favoritesClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <ul class="favorites-list" id="favoritesList"><li class="empty-state">Любимых блюд пока нет</li></ul>
      </div>
    </section>

    <section class="manual-panel" id="manualPanel" aria-label="Ручное добавление еды" hidden>
      <button class="manual-backdrop" id="manualBackdrop" type="button" aria-label="Закрыть ручное добавление"></button>
      <div class="manual-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">Добавить</p>
            <h2>Вручную</h2>
          </div>
          <button class="close-button" id="manualClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <textarea class="manual-input" id="manualInput" rows="4" placeholder="Например: гречка 200г, курица 150г, салат"></textarea>

        <div class="profile-block">
          <span class="control-label">Прием пищи</span>
          <div class="segment-control manual-type-segments" role="group" aria-label="Прием пищи вручную">
            <button class="manual-type-button active" type="button" data-manual-type="breakfast">Завтрак</button>
            <button class="manual-type-button" type="button" data-manual-type="lunch">Обед</button>
            <button class="manual-type-button" type="button" data-manual-type="dinner">Ужин</button>
            <button class="manual-type-button" type="button" data-manual-type="snack">Перекус</button>
          </div>
        </div>

        <div class="manual-preview" id="manualPreview">
          <span>Демо-расчет</span>
          <strong>Введите еду</strong>
        </div>

        <button class="save-button" id="manualSave" type="button">Добавить в дневник</button>
      </div>
    </section>

    <section class="notes-panel" id="notesPanel" aria-label="Блокнот питания" hidden>
      <button class="notes-backdrop" id="notesBackdrop" type="button" aria-label="Закрыть блокнот"></button>
      <div class="notes-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">Личное</p>
            <h2>Блокнот</h2>
          </div>
          <button class="close-button" id="notesClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <textarea class="note-input" id="noteInput" rows="6" placeholder="Еда, цели, настроение, самочувствие"></textarea>
        <button class="save-button" id="noteSave" type="button">Сохранить запись</button>
        <ul class="notes-list" id="notesList"><li class="empty-state">Записей пока нет</li></ul>
      </div>
    </section>

    <section class="weight-panel" id="weightPanel" aria-label="Трекер веса" hidden>
      <button class="weight-backdrop" id="weightBackdrop" type="button" aria-label="Закрыть вес"></button>
      <div class="weight-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">Прогресс</p>
            <h2>Вес</h2>
          </div>
          <button class="close-button" id="weightClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <div class="weight-summary">
          <div>
            <span>Текущий вес</span>
            <strong id="currentWeight">82 кг</strong>
          </div>
          <div>
            <span>Динамика</span>
            <strong id="weightTrend">пока нет</strong>
          </div>
        </div>

        <label class="weight-field">
          <span>Новая запись</span>
          <input id="weightInput" type="number" min="30" max="250" step="0.1" inputmode="decimal" value="82" />
          <small>кг</small>
        </label>

        <textarea class="weight-note" id="weightNote" rows="3" placeholder="Самочувствие, сон, тренировка, отеки"></textarea>
        <button class="save-button" id="weightSave" type="button">Сохранить вес</button>

        <div class="ai-insight weight-insight">
          <span>AI-анализ</span>
          <p id="weightInsight">Добавь первую запись, и FoodLens начнет смотреть динамику.</p>
        </div>

        <ul class="weight-list" id="weightList"><li class="empty-state">Записей веса пока нет</li></ul>
      </div>
    </section>

    <section class="profile-panel" id="profilePanel" aria-label="Профиль питания" hidden>
      <button class="profile-backdrop" id="profileBackdrop" type="button" aria-label="Закрыть профиль"></button>
      <div class="profile-sheet">
        <div class="section-header">
          <div>
            <p class="eyebrow">Профиль</p>
            <h2>Твоя цель</h2>
          </div>
          <button class="close-button" id="profileClose" type="button" aria-label="Закрыть">×</button>
        </div>

        <div class="profile-summary-row">
          <span>Норма дня</span>
          <strong id="profileCalories">1 900 ккал</strong>
        </div>

        <div class="profile-grid">
          <label class="profile-field">
            <span>Вес</span>
            <input id="profileWeight" type="number" min="30" max="250" inputmode="decimal" value="82" />
            <small>кг</small>
          </label>
          <label class="profile-field">
            <span>Рост</span>
            <input id="profileHeight" type="number" min="120" max="230" inputmode="numeric" value="178" />
            <small>см</small>
          </label>
          <label class="profile-field">
            <span>Возраст</span>
            <input id="profileAge" type="number" min="12" max="90" inputmode="numeric" value="28" />
            <small>лет</small>
          </label>
        </div>

        <div class="profile-block">
          <span class="control-label">Пол</span>
          <div class="segment-control profile-segments" role="group" aria-label="Пол">
            <button class="profile-choice active" type="button" data-profile-field="sex" data-value="male">Муж</button>
            <button class="profile-choice" type="button" data-profile-field="sex" data-value="female">Жен</button>
          </div>
        </div>

        <label class="profile-block">
          <span class="control-label">Активность</span>
          <select class="profile-select" id="profileActivity">
            <option value="1.2">Мало движения</option>
            <option value="1.375">1-3 тренировки</option>
            <option value="1.55">3-5 тренировок</option>
            <option value="1.725">Активный день</option>
          </select>
        </label>

        <div class="profile-block">
          <span class="control-label">Цель</span>
          <div class="segment-control profile-segments" role="group" aria-label="Цель">
            <button class="profile-choice active" type="button" data-profile-field="goal" data-value="lose">Похудеть</button>
            <button class="profile-choice" type="button" data-profile-field="goal" data-value="maintain">Держать</button>
            <button class="profile-choice" type="button" data-profile-field="goal" data-value="gain">Набрать</button>
          </div>
        </div>

        <label class="profile-block">
          <span class="control-label">Комментарий для AI</span>
          <textarea class="profile-comment" id="profileComment" rows="4" placeholder="Не ем сахар, часто ужинаю поздно, хочу больше белка"></textarea>
        </label>

        <div class="ai-insight">
          <span>Фокус</span>
          <p id="profileInsight">Заполни профиль, и FoodLens подстроит дневную норму.</p>
        </div>

        <button class="save-button" id="profileSave" type="button">Сохранить профиль</button>
      </div>
    </section>

    <script src="https://telegram.org/js/telegram-web-app.js"></script>
    <script src="./app.js"></script>
  </body>
</html>

{
  "name": "foodlens-mini-app",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "start": "node server.mjs",
    "dev": "node server.mjs"
  }
}

# FoodLens

Telegram Mini App prototype for food tracking, calories, macros, water, weight, notes, favorites and an AI chat demo.

## Local run

```bash
npm run dev
```

Open the printed local URL in a browser.

## Deploy

The simplest path is Vercel:

1. Create a GitHub repository and upload this folder.
2. Open Vercel and import the repository.
3. Deploy with default settings.
4. Copy the generated HTTPS URL.

## Telegram setup

1. Open `@BotFather`.
2. Create or select your bot.
3. Open `Bot Settings`.
4. Choose `Configure Mini App`.
5. Enable the Mini App and paste the deployed HTTPS URL.
6. Optional: set the same URL in `Menu Button`.

Telegram requires a public HTTPS URL. `localhost` works only for local testing.

import { createServer } from "node:http";
import { createReadStream } from "node:fs";
import { extname, join, normalize } from "node:path";

const root = new URL(".", import.meta.url).pathname;
const port = Number(process.env.PORT || 4173);
const types = { ".html": "text/html; charset=utf-8", ".css": "text/css; charset=utf-8", ".js": "text/javascript; charset=utf-8" };

createServer((request, response) => {
  const url = new URL(request.url || "/", `http://localhost:${port}`);
  const requestedPath = url.pathname === "/" ? "/index.html" : url.pathname;
  const filePath = normalize(join(root, requestedPath));

  if (!filePath.startsWith(root)) {
    response.writeHead(403);
    response.end("Forbidden");
    return;
  }

  const stream = createReadStream(filePath);
  stream.on("open", () => {
    response.writeHead(200, { "Content-Type": types[extname(filePath)] || "application/octet-stream" });
    stream.pipe(response);
  });
  stream.on("error", () => {
    response.writeHead(404);
    response.end("Not found");
  });
}).listen(port, () => console.log(`FoodLens is running at http://localhost:${port}`));

:root {
  color-scheme: light;
  --ink: #161a1d;
  --muted: #687072;
  --line: rgba(22, 26, 29, 0.1);
  --page-bg: radial-gradient(circle at 15% 0%, rgba(243, 201, 105, 0.24), transparent 28rem), linear-gradient(145deg, #f6f7f2 0%, #eef5f0 48%, #f7f1ea 100%);
  --panel: rgba(255, 255, 255, 0.9);
  --soft-card: #fbfcf8;
  --macro-bg: #f0f4f0;
  --goal-bg: #f7f1e4;
  --segment-bg: #ecefeb;
  --primary-button: #161a1d;
  --primary-button-text: #ffffff;
  --green: #1f8a5b;
  --green-dark: #176743;
  --mint: #dff4e9;
  --coral: #ee6c4d;
  --yellow: #f3c969;
  --blue: #477998;
  --shadow: 0 18px 50px rgba(27, 35, 31, 0.14);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

* { box-sizing: border-box; }
body {
  min-height: 100vh;
  margin: 0;
  background: var(--page-bg);
  color: var(--ink);
}
body[data-theme="dark"] {
  color-scheme: dark;
  --ink: #f4f7f2;
  --muted: #aeb8b3;
  --line: rgba(255, 255, 255, 0.12);
  --page-bg: radial-gradient(circle at 18% 0%, rgba(31, 138, 91, 0.24), transparent 24rem), linear-gradient(145deg, #111816 0%, #17231f 54%, #101214 100%);
  --panel: rgba(24, 31, 28, 0.92);
  --soft-card: #202a25;
  --macro-bg: #18221e;
  --goal-bg: #212819;
  --segment-bg: #101815;
  --green-dark: #75d49d;
  --mint: rgba(31, 138, 91, 0.25);
  --primary-button: #f4f7f2;
  --primary-button-text: #101214;
  --shadow: 0 18px 50px rgba(0, 0, 0, 0.32);
}
button { border: 0; font: inherit; color: inherit; cursor: pointer; }
.app-shell { width: min(100%, 480px); min-height: 100vh; margin: 0 auto; padding: max(18px, env(safe-area-inset-top)) 16px max(20px, env(safe-area-inset-bottom)); }
.camera-section, .result-section, .daily-section { margin-bottom: 14px; }
.topbar, .section-header { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 12px; }
.eyebrow { margin: 0 0 2px; color: var(--green-dark); font-size: 12px; font-weight: 800; letter-spacing: 0; text-transform: uppercase; }
h1, h2 { margin: 0; line-height: 1.05; }
h1 { font-size: 32px; }
h2 { font-size: 22px; }
.top-actions { display: flex; align-items: center; gap: 8px; }
.profile-button {
  position: relative;
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 10px 24px rgba(22, 26, 29, 0.1);
}
.profile-icon {
  position: relative;
  display: block;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  border: 2px solid var(--ink);
}
.profile-icon::after {
  content: "";
  position: absolute;
  left: 50%;
  bottom: -13px;
  width: 24px;
  height: 13px;
  border: 2px solid var(--ink);
  border-bottom: 0;
  border-radius: 999px 999px 0 0;
  transform: translateX(-50%);
}
.theme-button { position: relative; width: 48px; height: 32px; border-radius: 999px; background: var(--ink); box-shadow: 0 10px 24px rgba(22, 26, 29, 0.18); transition: background 180ms ease; }
.theme-icon { position: absolute; top: 4px; left: 4px; width: 24px; height: 24px; border-radius: 50%; background: var(--yellow); box-shadow: inset -7px -5px 0 rgba(255, 255, 255, 0.34); transition: transform 180ms ease, background 180ms ease; }
body[data-theme="dark"] .theme-icon { transform: translateX(16px); background: #f4f7f2; box-shadow: inset -8px -4px 0 #9aa6a0; }

.camera-frame { position: relative; overflow: hidden; min-height: 380px; border: 1px solid rgba(255, 255, 255, 0.72); border-radius: 8px; background: #24312b; box-shadow: var(--shadow); isolation: isolate; }
.camera-feed, .camera-placeholder { position: absolute; inset: 0; width: 100%; height: 100%; }
.camera-feed { object-fit: cover; opacity: 0; transition: opacity 180ms ease; }
.camera-feed.active { opacity: 1; }
.camera-placeholder { display: grid; place-items: center; background: linear-gradient(135deg, rgba(31, 138, 91, 0.36), transparent 50%), linear-gradient(45deg, #26382d, #1a2521); }
.uploaded-photo { width: 100%; height: 100%; object-fit: cover; display: block; }
.plate { position: relative; width: min(72vw, 300px); aspect-ratio: 1; border-radius: 50%; background: #f7faf5; box-shadow: inset 0 0 0 14px #edf0ea, 0 24px 55px rgba(0, 0, 0, 0.28); }
.food { position: absolute; display: block; border-radius: 50%; }
.rice { left: 24%; top: 22%; width: 34%; height: 40%; background: #f2dfb5; }
.chicken { right: 18%; top: 30%; width: 35%; height: 27%; border-radius: 44% 56% 42% 58%; background: #c97b51; }
.greens { left: 32%; bottom: 16%; width: 43%; height: 28%; border-radius: 55% 45% 60% 40%; background: #55a56e; }
.tomato { right: 24%; bottom: 29%; width: 15%; height: 15%; background: var(--coral); }
.scan-guides { position: absolute; inset: 18px; pointer-events: none; }
.scan-guides span { position: absolute; width: 42px; height: 42px; border-color: rgba(255, 255, 255, 0.82); }
.scan-guides span:nth-child(1) { left: 0; top: 0; border-left: 3px solid; border-top: 3px solid; }
.scan-guides span:nth-child(2) { right: 0; top: 0; border-right: 3px solid; border-top: 3px solid; }
.scan-guides span:nth-child(3) { right: 0; bottom: 0; border-right: 3px solid; border-bottom: 3px solid; }
.scan-guides span:nth-child(4) { left: 0; bottom: 0; border-left: 3px solid; border-bottom: 3px solid; }
.camera-status { position: absolute; left: 14px; right: 14px; bottom: 14px; padding: 10px 12px; border-radius: 8px; background: rgba(22, 26, 29, 0.72); color: white; font-size: 14px; font-weight: 700; text-align: center; backdrop-filter: blur(12px); }
.scan-actions { display: grid; grid-template-columns: 82px 1fr 82px; gap: 10px; margin-top: 12px; }
.secondary-button, .scan-button, .save-button { min-height: 50px; border-radius: 8px; font-weight: 850; }
.secondary-button { background: var(--panel); border: 1px solid var(--line); }
.scan-button { display: inline-flex; align-items: center; justify-content: center; gap: 9px; background: var(--green); color: white; box-shadow: 0 14px 28px rgba(31, 138, 91, 0.28); }
.scan-button.loading { background: var(--green-dark); }
.scan-dot { width: 10px; height: 10px; border-radius: 50%; background: var(--yellow); }

.result-section, .daily-section { padding: 16px; border: 1px solid rgba(255, 255, 255, 0.76); border-radius: 8px; background: var(--panel); box-shadow: 0 12px 34px rgba(30, 39, 34, 0.09); backdrop-filter: blur(18px); }
.confidence { flex: 0 0 auto; padding: 8px 10px; border-radius: 999px; background: var(--mint); color: var(--green-dark); font-size: 13px; font-weight: 850; }
.calorie-card { display: grid; grid-template-columns: 0.9fr 1.1fr; gap: 14px; align-items: stretch; padding: 14px; border-radius: 8px; background: var(--soft-card); border: 1px solid var(--line); }
.metric-label, .metric-unit, .macro-grid span, .daily-total span { display: block; color: var(--muted); font-size: 13px; font-weight: 700; }
#calories { display: block; margin-top: 4px; font-size: 44px; line-height: 0.95; }
.macro-grid { display: grid; grid-template-columns: 1fr; gap: 8px; }
.macro-grid div { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 10px 12px; border-radius: 8px; background: var(--macro-bg); }
.portion-control,
.meal-type-control { margin-top: 14px; }
.control-label { display: block; margin-bottom: 8px; color: var(--muted); font-size: 13px; font-weight: 800; }
.segment-control { display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px; padding: 5px; border-radius: 8px; background: var(--segment-bg); }
.portion-button,
.meal-type-button { min-height: 40px; border-radius: 7px; background: transparent; color: var(--muted); font-size: 14px; font-weight: 850; }
.portion-button.active,
.meal-type-button.active { background: var(--soft-card); color: var(--ink); box-shadow: 0 6px 18px rgba(30, 39, 34, 0.1); }
.meal-type-segments { grid-template-columns: repeat(4, 1fr); }
.meal-type-button { font-size: 13px; }
.manual-type-segments { grid-template-columns: repeat(4, 1fr); }
.manual-type-button { min-height: 40px; border-radius: 7px; background: transparent; color: var(--muted); font-size: 13px; font-weight: 850; }
.manual-type-button.active { background: var(--soft-card); color: var(--ink); box-shadow: 0 6px 18px rgba(30, 39, 34, 0.1); }
.save-button { width: 100%; margin-top: 14px; background: var(--primary-button); color: var(--primary-button-text); }
.daily-total { min-width: 76px; text-align: right; }
.daily-total strong { display: block; font-size: 22px; }
.date-switcher {
  display: grid;
  grid-template-columns: 42px 1fr 42px auto;
  align-items: center;
  gap: 8px;
  margin: 2px 0 12px;
  padding: 8px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}
.date-switcher button {
  min-height: 40px;
  border-radius: 8px;
  background: var(--panel);
  border: 1px solid var(--line);
  color: var(--ink);
  font-size: 22px;
  font-weight: 850;
  line-height: 1;
}
.date-switcher div {
  min-width: 0;
  text-align: center;
}
.date-switcher span {
  display: block;
  color: var(--green-dark);
  font-size: 12px;
  font-weight: 850;
  text-transform: uppercase;
}
.date-switcher strong {
  display: block;
  margin-top: 2px;
  overflow: hidden;
  color: var(--ink);
  font-size: 17px;
  line-height: 1.15;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.today-button {
  min-width: 76px;
  padding: 0 12px;
  font-size: 13px !important;
  text-transform: uppercase;
}
.goal-card { padding: 14px; border-radius: 8px; background: var(--goal-bg); border: 1px solid rgba(243, 201, 105, 0.45); }
.goal-topline { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
.goal-card strong { display: block; margin-top: 4px; font-size: 24px; }
.goal-output { min-width: 62px; padding: 8px 10px; border-radius: 8px; background: var(--soft-card); color: var(--green-dark); font-size: 13px; font-weight: 850; text-align: center; }
.remaining-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-top: 12px;
  padding: 12px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}
.remaining-row span {
  color: var(--muted);
  font-size: 13px;
  font-weight: 800;
}
.remaining-row strong {
  margin: 0;
  color: var(--green-dark);
  font-size: 22px;
}
.remaining-row.over strong { color: var(--coral); }
.goal-range { width: 100%; margin: 14px 0 10px; accent-color: var(--green); }
.goal-presets { display: grid; grid-template-columns: repeat(4, 1fr); gap: 7px; margin-bottom: 12px; }
.goal-presets button { min-height: 36px; border-radius: 8px; background: var(--soft-card); border: 1px solid var(--line); color: var(--muted); font-size: 13px; font-weight: 850; }
.goal-presets button.active { background: var(--green); border-color: var(--green); color: white; }
.progress-track { display: block; height: 9px; margin-top: 12px; overflow: hidden; border-radius: 999px; background: rgba(22, 26, 29, 0.1); }
.progress-track span { display: block; width: 0%; height: 100%; border-radius: inherit; background: linear-gradient(90deg, var(--green), var(--blue)); transition: width 240ms ease; }
.macro-goals-card {
  margin-top: 12px;
  padding: 14px;
  border-radius: 8px;
  background: #f4f3ec;
  border: 1px solid rgba(71, 121, 152, 0.16);
}
body[data-theme="dark"] .macro-goals-card { background: rgba(244, 243, 236, 0.06); }
.macro-goals-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}
.macro-goals-header strong {
  display: block;
  margin-top: 4px;
  font-size: 22px;
}
.macro-balance-badge {
  flex: 0 0 auto;
  padding: 8px 10px;
  border-radius: 999px;
  background: var(--mint);
  color: var(--green-dark);
  font-size: 12px;
  font-weight: 850;
}
.macro-balance-badge.over { background: rgba(238, 108, 77, 0.16); color: var(--coral); }
.macro-goal-list { display: grid; gap: 8px; }
.macro-goal {
  padding: 11px 12px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}
.macro-goal-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.macro-goal-top span,
.macro-goal small {
  color: var(--muted);
  font-size: 12px;
  font-weight: 800;
}
.macro-goal-top strong {
  color: var(--ink);
  font-size: 17px;
}
.macro-goal-top .macro-unit {
  display: inline;
  margin-left: 2px;
  color: var(--muted);
  font-size: 11px;
  font-weight: 850;
}
.macro-goal-track {
  height: 8px;
  margin: 9px 0 7px;
  overflow: hidden;
  border-radius: 999px;
  background: rgba(22, 26, 29, 0.1);
}
.macro-goal-track span {
  display: block;
  width: 0%;
  height: 100%;
  border-radius: inherit;
  transition: width 240ms ease;
}
.macro-goal.protein .macro-goal-track span { background: var(--green); }
.macro-goal.fat .macro-goal-track span { background: var(--yellow); }
.macro-goal.carbs .macro-goal-track span { background: var(--blue); }
.macro-goal.over small { color: var(--coral); }

.water-card {
  margin-top: 12px;
  padding: 14px;
  border-radius: 8px;
  background: #e8f4f7;
  border: 1px solid rgba(71, 121, 152, 0.22);
}
body[data-theme="dark"] .water-card { background: rgba(71, 121, 152, 0.15); }
.water-topline { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.water-topline strong { display: block; margin-top: 4px; font-size: 22px; }
.water-actions { display: flex; gap: 8px; }
.water-actions button {
  width: 38px;
  height: 38px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
  color: var(--ink);
  font-size: 24px;
  font-weight: 850;
  line-height: 1;
}
.water-actions button:disabled { opacity: 0.45; cursor: default; }
.water-dots { display: grid; grid-template-columns: repeat(8, 1fr); gap: 6px; margin-top: 12px; }
.water-dots span { height: 10px; border-radius: 999px; background: rgba(71, 121, 152, 0.2); }
.water-dots span.filled { background: var(--blue); }
.water-card p { margin: 10px 0 0; color: var(--muted); font-size: 13px; font-weight: 750; }
.daily-summary {
  margin-top: 12px;
  padding: 14px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}
.summary-header { margin-bottom: 10px; }
.summary-badge { flex: 0 0 auto; padding: 8px 10px; border-radius: 999px; background: var(--mint); color: var(--green-dark); font-size: 13px; font-weight: 850; }
.summary-badge.over { background: rgba(238, 108, 77, 0.16); color: var(--coral); }
.summary-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
.summary-grid div { padding: 10px; border-radius: 8px; background: var(--macro-bg); }
.summary-grid span,
.summary-advice span { display: block; color: var(--muted); font-size: 12px; font-weight: 800; }
.summary-grid strong { display: block; margin-top: 4px; font-size: 18px; }
.summary-advice { margin-top: 10px; padding: 12px; border-radius: 8px; background: var(--goal-bg); border: 1px solid rgba(243, 201, 105, 0.28); }
.summary-advice p { margin: 5px 0 0; color: var(--ink); font-size: 14px; line-height: 1.35; font-weight: 750; }
.meal-list { display: grid; gap: 10px; margin: 12px 0 0; padding: 0; list-style: none; }
.meal-group { display: grid; gap: 8px; padding: 0; }
.meal-group-title { display: flex; align-items: center; justify-content: space-between; gap: 12px; color: var(--muted); font-size: 13px; font-weight: 850; }
.meal-group-title strong { color: var(--green-dark); }
.meal-group-list { display: grid; gap: 8px; margin: 0; padding: 0; list-style: none; }
.meal-item, .empty-state { padding: 12px; border-radius: 8px; background: var(--soft-card); border: 1px solid var(--line); }
.meal-item { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.meal-actions { display: flex; align-items: center; gap: 8px; }
.meal-delete {
  display: grid;
  place-items: center;
  width: 30px;
  height: 30px;
  border-radius: 8px;
  background: transparent;
  border: 1px solid var(--line);
  color: var(--muted);
  font-size: 20px;
  line-height: 1;
  font-weight: 800;
}
.meal-item strong { display: block; margin-bottom: 2px; }
.meal-item span, .empty-state { color: var(--muted); font-size: 13px; font-weight: 700; }

@media (max-width: 380px) {
  .app-shell { padding-left: 12px; padding-right: 12px; }
  .date-switcher { grid-template-columns: 38px 1fr 38px; }
  .today-button { grid-column: 1 / -1; }
  h1 { font-size: 28px; }
  .camera-frame { min-height: 330px; }
  .scan-actions { grid-template-columns: 68px 1fr 68px; gap: 8px; }
  .secondary-button, .scan-button, .save-button { min-height: 48px; font-size: 14px; }
  .calorie-card { grid-template-columns: 1fr; }
  .summary-grid { grid-template-columns: repeat(2, 1fr); }
}


.bottom-actions {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 7px;
  width: min(100%, 480px);
  margin: 0 auto max(20px, env(safe-area-inset-bottom));
  padding: 0 12px;
}

.bottom-action {
  display: grid;
  grid-template-rows: 24px auto;
  align-content: center;
  justify-items: center;
  gap: 5px;
  min-width: 0;
  min-height: 64px;
  overflow: hidden;
  padding: 7px 4px 6px;
  border-radius: 8px;
  background: var(--primary-button);
  color: var(--primary-button-text);
  font-size: 11px;
  font-weight: 850;
  line-height: 1.05;
  text-align: center;
  box-shadow: 0 16px 38px rgba(22, 26, 29, 0.18);
}

.bottom-action > span:last-child {
  display: block;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}


.ai-chat-icon {
  position: relative;
  display: block;
  width: 22px;
  height: 18px;
  margin-top: 2px;
  border: 2px solid currentColor;
  border-radius: 7px;
}

.ai-chat-icon::before {
  content: "";
  position: absolute;
  left: 4px;
  bottom: -5px;
  width: 7px;
  height: 7px;
  border-left: 2px solid currentColor;
  border-bottom: 2px solid currentColor;
  transform: rotate(-30deg);
}

.ai-chat-icon::after {
  content: "";
  position: absolute;
  left: 5px;
  top: 7px;
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: currentColor;
  box-shadow: 5px 0 0 currentColor, 10px 0 0 currentColor;
}

.notebook-icon {
  position: relative;
  display: block;
  width: 20px;
  height: 23px;
  border: 2px solid currentColor;
  border-left-width: 4px;
  border-radius: 5px;
}

.notebook-icon::before,
.notebook-icon::after {
  content: "";
  position: absolute;
  left: 6px;
  right: 3px;
  height: 2px;
  border-radius: 999px;
  background: currentColor;
}

.notebook-icon::before { top: 7px; }
.notebook-icon::after { top: 13px; }
.ai-panel[hidden] { display: none; }
.ai-panel { position: fixed; inset: 0; z-index: 31; }
.ai-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.ai-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  display: flex;
  flex-direction: column;
  width: min(100%, 480px);
  height: min(82vh, 720px);
  padding: 16px 16px max(18px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.ai-chat-list {
  display: grid;
  align-content: start;
  gap: 10px;
  min-height: 260px;
  overflow: auto;
  padding: 12px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}

.ai-message {
  max-width: 88%;
  padding: 10px 12px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.38;
}

.ai-message span {
  display: block;
  margin-bottom: 4px;
  font-size: 11px;
  font-weight: 850;
  text-transform: uppercase;
}

.ai-message p {
  margin: 0;
  white-space: pre-wrap;
}

.ai-message.assistant {
  justify-self: start;
  background: var(--mint);
  color: var(--ink);
}

.ai-message.assistant span { color: var(--green-dark); }
.ai-message.user {
  justify-self: end;
  background: var(--primary-button);
  color: var(--primary-button-text);
}

.ai-message.user span { color: currentColor; opacity: 0.72; }
.ai-quick-actions {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin: 10px 0;
}

.ai-quick-actions button {
  min-height: 38px;
  padding: 0 10px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
  color: var(--muted);
  font-size: 13px;
  font-weight: 850;
}

.ai-chat-form {
  display: grid;
  grid-template-columns: 1fr 46px;
  gap: 8px;
}

.ai-chat-form input {
  width: 100%;
  min-height: 46px;
  padding: 0 12px;
  border: 1px solid var(--line);
  border-radius: 8px;
  outline: none;
  background: var(--soft-card);
  color: var(--ink);
  font: inherit;
}

.ai-chat-form input:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(31, 138, 91, 0.14); }
.ai-chat-form button { border-radius: 8px; background: var(--green); color: white; font-size: 21px; font-weight: 850; }

.notes-panel[hidden] { display: none; }
.notes-panel { position: fixed; inset: 0; z-index: 30; }
.notes-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.notes-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: min(100%, 480px);
  max-height: min(82vh, 720px);
  overflow: auto;
  padding: 16px 16px max(22px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.close-button {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
  color: var(--muted);
  font-size: 24px;
  line-height: 1;
  font-weight: 700;
}

.note-input {
  width: 100%;
  min-height: 150px;
  resize: vertical;
  padding: 13px 14px;
  border: 1px solid var(--line);
  border-radius: 8px;
  outline: none;
  background: var(--soft-card);
  color: var(--ink);
  font: inherit;
  line-height: 1.45;
}

.note-input:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(31, 138, 91, 0.14); }
.notes-list { display: grid; gap: 8px; margin: 12px 0 0; padding: 0; list-style: none; }
.note-item { padding: 12px; border-radius: 8px; background: var(--soft-card); border: 1px solid var(--line); }
.note-item p { margin: 0; white-space: pre-wrap; line-height: 1.4; }
.note-meta { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-bottom: 8px; color: var(--muted); font-size: 12px; font-weight: 800; }
.note-delete { min-height: 30px; padding: 0 10px; border-radius: 8px; background: transparent; border: 1px solid var(--line); color: var(--muted); font-size: 12px; font-weight: 850; }


.profile-badge {
  flex: 0 0 auto;
  padding: 8px 10px;
  border-radius: 999px;
  background: var(--mint);
  color: var(--green-dark);
  font-size: 13px;
  font-weight: 850;
}

.profile-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.profile-field {
  position: relative;
  display: block;
  padding: 10px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--soft-card);
}

.profile-field span,
.ai-insight span {
  display: block;
  color: var(--muted);
  font-size: 12px;
  font-weight: 800;
}

.profile-field input {
  width: 100%;
  margin-top: 6px;
  padding: 0 22px 0 0;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--ink);
  font-size: 22px;
  font-weight: 850;
}

.profile-field small {
  position: absolute;
  right: 10px;
  bottom: 13px;
  color: var(--muted);
  font-size: 12px;
  font-weight: 800;
}

.profile-block { display: block; margin-top: 14px; }
.profile-segments { grid-template-columns: repeat(auto-fit, minmax(82px, 1fr)); }
.profile-choice { min-height: 40px; border-radius: 7px; background: transparent; color: var(--muted); font-size: 14px; font-weight: 850; }
.profile-choice.active { background: var(--soft-card); color: var(--ink); box-shadow: 0 6px 18px rgba(30, 39, 34, 0.1); }
.profile-select,
.profile-comment {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 8px;
  outline: none;
  background: var(--soft-card);
  color: var(--ink);
  font: inherit;
}

.profile-select { min-height: 44px; padding: 0 12px; font-weight: 800; }
.profile-comment { min-height: 104px; resize: vertical; padding: 12px; line-height: 1.45; }
.profile-select:focus,
.profile-comment:focus,
.profile-field:focus-within { border-color: var(--green); box-shadow: 0 0 0 3px rgba(31, 138, 91, 0.14); }
.ai-insight { margin-top: 12px; padding: 12px; border: 1px solid rgba(31, 138, 91, 0.18); border-radius: 8px; background: var(--mint); }
.ai-insight p { margin: 5px 0 0; line-height: 1.35; font-size: 14px; font-weight: 750; }

@media (max-width: 380px) {
  .profile-grid { grid-template-columns: 1fr; }
}


.profile-panel[hidden] { display: none; }
.profile-panel { position: fixed; inset: 0; z-index: 32; }
.profile-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.profile-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: min(100%, 480px);
  max-height: min(88vh, 760px);
  overflow: auto;
  padding: 16px 16px max(22px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.profile-summary-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
  padding: 12px;
  border-radius: 8px;
  background: var(--mint);
  color: var(--green-dark);
  font-weight: 850;
}

.profile-summary-row span { color: var(--green-dark); font-size: 13px; }
.profile-summary-row strong { font-size: 20px; }


.weight-icon {
  position: relative;
  display: block;
  width: 22px;
  height: 17px;
  margin-top: 5px;
  border: 2px solid currentColor;
  border-top: 0;
  border-radius: 0 0 7px 7px;
}

.weight-icon::before {
  content: "";
  position: absolute;
  left: 50%;
  top: -6px;
  width: 12px;
  height: 12px;
  border: 2px solid currentColor;
  border-radius: 50%;
  background: transparent;
  transform: translateX(-50%);
}

.weight-icon::after {
  content: "";
  position: absolute;
  left: 50%;
  top: -1px;
  width: 6px;
  height: 2px;
  border-radius: 999px;
  background: currentColor;
  transform: translateX(-50%) rotate(-25deg);
}

.weight-panel[hidden] { display: none; }
.weight-panel { position: fixed; inset: 0; z-index: 31; }
.weight-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.weight-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: min(100%, 480px);
  max-height: min(86vh, 740px);
  overflow: auto;
  padding: 16px 16px max(22px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.weight-summary {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin-bottom: 12px;
}

.weight-summary div,
.weight-field,
.weight-item {
  padding: 12px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}

.weight-summary span,
.weight-field span,
.weight-item span {
  display: block;
  color: var(--muted);
  font-size: 12px;
  font-weight: 800;
}

.weight-summary strong {
  display: block;
  margin-top: 5px;
  font-size: 22px;
}

.weight-field {
  position: relative;
  display: block;
}

.weight-field input {
  width: 100%;
  margin-top: 6px;
  padding: 0 28px 0 0;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--ink);
  font-size: 32px;
  font-weight: 850;
}

.weight-field small {
  position: absolute;
  right: 12px;
  bottom: 17px;
  color: var(--muted);
  font-size: 13px;
  font-weight: 800;
}

.weight-note {
  width: 100%;
  min-height: 88px;
  margin-top: 10px;
  resize: vertical;
  padding: 12px;
  border: 1px solid var(--line);
  border-radius: 8px;
  outline: none;
  background: var(--soft-card);
  color: var(--ink);
  font: inherit;
  line-height: 1.45;
}

.weight-note:focus,
.weight-field:focus-within { border-color: var(--green); box-shadow: 0 0 0 3px rgba(31, 138, 91, 0.14); }
.weight-insight { margin-top: 12px; }
.weight-list { display: grid; gap: 8px; margin: 12px 0 0; padding: 0; list-style: none; }
.weight-item { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
.weight-item strong { display: block; font-size: 20px; }
.weight-item p { margin: 6px 0 0; color: var(--muted); font-size: 13px; line-height: 1.35; }
.weight-delete { min-height: 30px; padding: 0 10px; border-radius: 8px; background: transparent; border: 1px solid var(--line); color: var(--muted); font-size: 12px; font-weight: 850; }

@media (max-width: 380px) {
  .bottom-actions { grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 6px; padding: 0 10px; }
  .bottom-action { min-height: 60px; font-size: 10px; }
  .ai-quick-actions { grid-template-columns: 1fr; }
  .weight-summary { grid-template-columns: 1fr; }
}


.manual-panel[hidden] { display: none; }
.manual-panel { position: fixed; inset: 0; z-index: 31; }
.manual-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.manual-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: min(100%, 480px);
  max-height: min(82vh, 720px);
  overflow: auto;
  padding: 16px 16px max(22px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.manual-input {
  width: 100%;
  min-height: 118px;
  resize: vertical;
  padding: 13px 14px;
  border: 1px solid var(--line);
  border-radius: 8px;
  outline: none;
  background: var(--soft-card);
  color: var(--ink);
  font: inherit;
  line-height: 1.45;
}

.manual-input:focus { border-color: var(--green); box-shadow: 0 0 0 3px rgba(31, 138, 91, 0.14); }
.manual-preview {
  display: grid;
  gap: 4px;
  margin-top: 12px;
  padding: 12px;
  border-radius: 8px;
  background: var(--mint);
  border: 1px solid rgba(31, 138, 91, 0.18);
}
.manual-preview span,
.manual-preview small { color: var(--muted); font-size: 12px; font-weight: 800; }
.manual-preview strong { color: var(--green-dark); font-size: 24px; }


.favorite-icon {
  display: grid;
  place-items: center;
  width: 22px;
  height: 24px;
  color: var(--yellow);
  font-size: 20px;
  line-height: 1;
}

.favorites-panel[hidden] { display: none; }
.favorites-panel { position: fixed; inset: 0; z-index: 31; }
.favorites-backdrop { position: absolute; inset: 0; width: 100%; height: 100%; background: rgba(10, 14, 12, 0.42); backdrop-filter: blur(5px); }
.favorites-sheet {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: min(100%, 480px);
  max-height: min(82vh, 720px);
  overflow: auto;
  padding: 16px 16px max(22px, env(safe-area-inset-bottom));
  border-radius: 8px 8px 0 0;
  background: var(--panel);
  border: 1px solid var(--line);
  box-shadow: 0 -18px 45px rgba(22, 26, 29, 0.2);
  transform: translateX(-50%);
}

.favorites-list { display: grid; gap: 8px; margin: 0; padding: 0; list-style: none; }
.favorite-item {
  display: grid;
  gap: 10px;
  padding: 12px;
  border-radius: 8px;
  background: var(--soft-card);
  border: 1px solid var(--line);
}
.favorite-item-main { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
.favorite-item strong { display: block; margin-bottom: 3px; }
.favorite-item span { color: var(--muted); font-size: 13px; font-weight: 700; }
.favorite-item-actions { display: grid; grid-template-columns: 1fr auto; gap: 8px; }
.favorite-add,
.favorite-remove {
  min-height: 38px;
  border-radius: 8px;
  font-weight: 850;
}
.favorite-add { background: var(--green); color: white; }
.favorite-remove { padding: 0 12px; background: transparent; border: 1px solid var(--line); color: var(--muted); }
.meal-favorite {
  display: grid;
  place-items: center;
  width: 30px;
  height: 30px;
  border-radius: 8px;
  background: transparent;
  border: 1px solid var(--line);
  color: var(--muted);
  font-size: 18px;
  line-height: 1;
  font-weight: 850;
}
.meal-favorite.active { color: var(--yellow); background: rgba(243, 201, 105, 0.15); border-color: rgba(243, 201, 105, 0.38); }

{
  "cleanUrls": true,
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "ALLOWALL"
        }
      ]
    }
  ]
}
