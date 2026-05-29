# FitMe — Supabase Backend Setup

## 1. Create a Supabase Project

1. Go to https://supabase.com and create a new project.
2. Note your **Project URL** and **anon (public) key** from Project Settings > API.

## 2. Run the Schema

In the Supabase dashboard, open the **SQL Editor** and paste the contents of
`supabase/schema.sql`, then click **Run**.

Alternatively, with the Supabase CLI:

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

This creates the `profiles`, `weight_logs`, `food_logs`, and `ai_config` tables
with Row Level Security enabled.

## 3. Set Edge Function Secrets

Set whichever AI provider key(s) you use:

```bash
supabase secrets set OPENROUTER_API_KEY=sk-or-...
supabase secrets set OPENAI_API_KEY=sk-...
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
```

Only the secrets for the providers you actually call are required.

## 4. Deploy the Edge Function

```bash
supabase functions deploy ai-proxy
```

The function will be available at:
`https://<project-ref>.supabase.co/functions/v1/ai-proxy`

## 5. Build the Flutter App with Credentials

Pass the Supabase URL and anon key as Dart compile-time defines.
The app runs fully offline/locally when these are omitted.

**Development:**
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

**Release build (Android):**
```bash
flutter build apk \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

**Release build (iOS):**
```bash
flutter build ipa \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key>
```

> The anon key is safe to embed in the client binary — it is public by design.
> Never embed the service role key in the app.

## 6. Offline / No-Backend Mode

If `--dart-define=SUPABASE_URL` is not passed, `SupabaseConfig.isConfigured`
returns `false` and `SupabaseService.init()` is a no-op. The app operates
entirely with local storage and no network calls to Supabase.

## Architecture Summary

```
Flutter app
  └─ SupabaseService.init()       # called once in main()
       ├─ offline: no-op
       └─ configured: initialises supabase_flutter SDK

Feature repos (auth / profile / logs)
  └─ gate on SupabaseService.isReady
       ├─ false → local Hive/SQLite storage
       └─ true  → Supabase tables via supabase_flutter client

AI calls
  └─ POST /functions/v1/ai-proxy  # API keys never leave the server
```
