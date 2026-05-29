# FitMe

AI-powered, highly customizable health & fitness coaching for **iOS, Android & Web** — one Flutter codebase. Practical like WHOOP: not just an exercise list, but a coach that reads your real health data, your meals, and your goals.

![brand](assets/brand/logo_a.png)

## Vision

- **AI coaching** — body-area analysis from photos, calorie/macro estimation from a food photo, adaptive workouts. Providers are **pluggable**: configure any number of vendors (Claude, OpenAI, Gemini, Groq, OpenRouter, custom) in the admin panel and route each AI task to whichever model you want.
- **Animated avatars** — gender-aware visual exercise guidance.
- **Health integration** — Apple Health / Google Fit / Samsung Health & wearables.
- **Proactive** — continuous stat monitoring with push-notification nudges.
- **Personalized nutrition** — calorie targets & macros computed from your body and goals.

## Tech stack

| Concern | Choice |
|---|---|
| UI / cross-platform | Flutter 3.44 (Dart 3.12) — iOS, Android, Web |
| State | Riverpod (`Notifier`) |
| Routing | go_router (gated by onboarding completion) |
| Backend (phase 2) | Supabase — auth, Postgres, storage, edge functions (hold AI keys server-side) |
| AI | Pluggable multi-vendor, admin-routed per task |
| Charts / type | fl_chart · Sora + Inter |

## Architecture

```
lib/
├── core/
│   ├── theme/        # design tokens: colors (+ FitColors ThemeExtension),
│   │                 # gradients, spacing, shadows, typography, theme
│   ├── widgets/      # PrimaryButton, FitCard, MetricRing, SelectionTile,
│   │                 # BlobBackground, FitMe logo (vector + image)
│   ├── router/       # app_router.dart (GoRouter + onboarding gate)
│   └── services/     # LocalStore (SharedPreferences wrapper)
└── features/
    ├── onboarding/   # domain/UserProfile (BMR/TDEE/macros) · profile_controller
    │                 # presentation: welcome → 7-step flow → plan-ready summary
    ├── dashboard/    # AppShell (bottom nav) + HomeScreen (calorie ring, macros)
    ├── admin/        # domain/AiConfig · ai_config_controller
    │                 # presentation/AiSettingsScreen (providers + task routing)
    └── settings/     # SettingsScreen (entry to admin AI panel)
```

### Design system

`context.fit` exposes brightness-aware semantic tokens (`surface`, `textPrimary`…)
via a `ThemeExtension`. Brand colors are constant; surfaces adapt for light/dark.
Both themes are implemented.

### AI provider model (the "dynamic admin setting")

`AiConfig` holds a list of `AiProvider`s (vendor + key + model + base URL) and a
`taskBindings` map routing each `AiTask` (foodVision, bodyAnalysis,
workoutSuggestion, mealPlanning, chatCoach, nutritionLookup) to a provider.
Vision-only tasks are restricted to vision-capable vendors in the UI.

> **Security:** API keys are stored locally only for admin preview. In
> production they live in Supabase edge-function secrets and are never shipped
> to the client. See the note on `AiProvider.toMap`.

## Run

```bash
flutter pub get
flutter run                 # device/emulator
flutter run -d chrome       # web
flutter test                # unit + widget tests
dart run flutter_launcher_icons   # regenerate icons from assets/brand/logo_a.png
```

## Status — Phase 1 (Foundation) — done

Project scaffold · design system (light + dark) · AI-generated logo + launcher
icons · onboarding (gender, goal, problem areas, body stats, target, activity,
diet) with live BMR/TDEE/macro math · plan-ready summary · home dashboard with
calorie ring · pluggable AI admin panel · routing & local persistence. Compiles
for web; tests green.

## Roadmap

- **Phase 2 — Backend & auth:** Supabase init, auth, profile sync, AI keys in edge functions.
- **Phase 3 — AI food scan:** camera → vision provider → calorie/macro logging against targets.
- **Phase 4 — Workouts & avatars:** exercise library, gender-aware animated avatar guidance.
- **Phase 5 — Health sync:** `health` plugin (Apple Health / Google Fit / Samsung), background reads.
- **Phase 6 — Proactive coaching:** stat monitoring + push notifications (FCM/APNs).
- **Phase 7 — Progress & body analysis:** weight/measurement charts, progress-photo AI analysis.
