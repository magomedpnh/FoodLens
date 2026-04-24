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
