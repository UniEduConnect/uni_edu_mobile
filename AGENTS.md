# AGENTS.md

Guidance for AI coding agents working in `uni_edu_mobile`. (Claude Code reads this via `@AGENTS.md` from `CLAUDE.md`.)

## What this is

`uni_edu_mobile` is the **Flutter mobile client** for the UNI-EDU tutoring platform. The platform connects students/parents with tutors; the .NET backend and React web frontend are sibling projects:

- `../UNI-EDU-Backend` — ASP.NET Core (.NET 10) REST API. See its `CLAUDE.md` for the full domain model, endpoints, and response conventions.
- `../UNI-EDU-Frontend-V2` — web frontend. The mobile design tokens (colors, type scale) are ported from its `src/index.css`, so keep the two visually in sync.

> **Current state:** the app is a **presentation-only landing/home screen** — a faithful mobile port of the web landing page (hero, features, "how it works", subjects, footer). There is **no networking, persistence, routing, or real state management yet**: auth buttons (`Đăng nhập` / `Đăng ký`) are stubs with empty `onPressed`, screen content comes from static seed data in [lib/data/](lib/data/), and the only "state" is local `setState` (a section toggle and a `ScrollController`). The sections below document what exists today and the conventions to keep as the app grows — don't document features that don't exist.

## Toolchain

- **Flutter** stable 3.41.x, **Dart** 3.12 (`environment.sdk: ^3.12.0` in [pubspec.yaml](pubspec.yaml)).
- Lints: `flutter_lints` ^6.0.0 via [analysis_options.yaml](analysis_options.yaml) (`package:flutter_lints/flutter.yaml`).
- Only dependency beyond the SDK so far is `cupertino_icons`. Add packages deliberately and record any non-obvious choice in this file.
- Android: `namespace`/`applicationId` are still the scaffold default `com.example.uni_edu_mobile` (Java/JVM 17). Set a real application ID before any release build — see [android/app/build.gradle.kts](android/app/build.gradle.kts).
- Targets present: Android + iOS (no web/desktop configured).

## Common commands

Run from the project root (`uni_edu_mobile/`). The shell here is **PowerShell on Windows**.

```powershell
flutter pub get              # fetch dependencies (after editing pubspec.yaml)
flutter run                  # run on the selected device/emulator (hot reload: r, hot restart: R)
flutter devices              # list available devices/emulators
flutter analyze              # static analysis — must be clean before committing
dart format .                # format all Dart sources
flutter test                 # run the unit/widget tests in test/
flutter test test/widget_test.dart   # run a single test file
flutter build apk            # release Android build
flutter build ios            # release iOS build (run on macOS)
flutter clean                # nuke build/ and .dart_tool/ when builds get weird
```

## Project layout (`lib/`)

The code follows a **layer-by-responsibility** structure. Mirror it when adding code:

```
lib/
  main.dart                  # entry point — runApp(UniEduApp())
  app.dart                   # UniEduApp: the root MaterialApp (theme + home)
  core/
    theme/                   # design tokens — the single source of styling truth
      app_colors.dart        #   palette (ported from the web frontend)
      app_text_styles.dart   #   named TextStyles (display, sectionTitle, cardBody…)
      app_dimens.dart        #   spacing / radius / layout constants
      app_theme.dart         #   builds the global ThemeData from the tokens
    utils/
      responsive.dart        # breakpoints + Responsive.columns(width)
  models/                    # plain immutable data classes (FeatureItem, Subject…)
  data/                      # static seed content (HomeContent) — placeholder for the API
  widgets/                   # app-wide reusable widgets (SoftCard, GradientText, *Card)
  screens/
    home/
      home_screen.dart       # the screen Scaffold + its private drawer
      home_section.dart      # enum of nav-target sections for this screen
      widgets/               # section widgets used only by this screen
```

**Where new code goes:**
- A new screen → `screens/<feature>/<feature>_screen.dart`, with screen-only pieces in `screens/<feature>/widgets/`.
- A widget reused across screens → `widgets/`. A widget used by one screen only → that screen's `widgets/`.
- A data shape → `models/`. Hard-coded content that will later come from the API → `data/`.

## Conventions

These are followed consistently in the existing code — match them. Three are called out by name in source doc-comments:

- **Tách UI thành các widget nhỏ** (split UI into small widgets). Screens compose small section/card widgets rather than one giant `build`. Keep widgets focused; extract a private `_Foo` widget in the same file for screen-local pieces (see `_HomeDrawer`, `_AudienceTab`).
- **Thiết kế UI nhất quán** (consistent UI). Never hard-code styling in widgets — pull from the theme layer: colors from [AppColors](lib/core/theme/app_colors.dart), spacing/radius from [AppDimens](lib/core/theme/app_dimens.dart), typography from [AppTextStyles](lib/core/theme/app_text_styles.dart). No raw `Color(0x…)` or magic padding numbers in widget code. (Raw colors live only in `data/` content lists, e.g. per-subject gradients.)
- **Thiết kế layout responsive** (responsive layout). Grids size their column count via `Responsive.columns(constraints.maxWidth)` inside a `LayoutBuilder`, with phone/tablet/desktop overrides where needed.

Other patterns in use:

- **Stateless by default; `StatefulWidget` only for genuine local UI state** (a toggle, a `ScrollController`). Guard `setState` (e.g. only call it when the value actually changes).
- **Immutable models:** `const` constructors, `required` named params, `final` fields (see [models/](lib/models/)).
- **Grids inside a scroll view:** use `shrinkWrap: true` + `physics: NeverScrollableScrollPhysics()` and a fixed `mainAxisExtent` to avoid `RenderFlex` overflow (the home page scrolls via one outer `SingleChildScrollView`).
- **Use current Flutter APIs:** `Color.withValues(alpha:)`, not the deprecated `withOpacity`.
- **Language:** user-facing strings are **Vietnamese**; code, identifiers, and doc-comments are **English**. Add a `///` doc-comment to every public class explaining its role.

## Testing

- [test/widget_test.dart](test/widget_test.dart) — widget tests for the home screen (section headings render, the audience toggle switches flows, the drawer exposes nav links, the footer renders). Anchor assertions on unique Vietnamese strings.
- [test/home_content_test.dart](test/home_content_test.dart) — unit tests for the seed-content invariants (counts of features/subjects/steps, `stepsFor` mapping).
- **Add a test alongside new logic** and keep `flutter test` + `flutter analyze` green before committing. When you replace seed data with API calls, update these tests rather than deleting the coverage.

## Talking to the backend (when networking is added)

Nothing here talks to the backend yet. When wiring it up, target the UNI-EDU backend and match its contract exactly:

- **Base URL (local dev):** `http://localhost:5115` (http profile) or `https://localhost:7271` (https). From the **Android emulator**, `localhost` is the emulator itself — use `http://10.0.2.2:5115` to reach the host machine. Make the base URL configurable (e.g. `--dart-define=API_BASE_URL=...`) rather than hard-coding it.
- **Response envelope:** successful responses are wrapped in `ApiResponse<T>` → `{ statusCode, message, data }`. Paged endpoints put a `PagedResult<T>` in `data` → `{ items, total, page, pageSize, totalPages }`. Parse the envelope, then `data`.
- **Errors:** non-2xx responses return an `ErrorResponse` (camelCase) with field-level `errors[]` on validation failures. Surface `message`/`errors` to the user rather than a raw status code.
- **Auth:** JWT bearer. `POST /api/login` returns an access token (1h lifetime) and sets an `HttpOnly` `refreshToken` cookie; `POST /api/refresh-token` rotates it. Send the access token as `Authorization: Bearer <token>`; persist it securely (e.g. `flutter_secure_storage`) — never in plain `SharedPreferences`. Roles are `Admin` / `Tutor` / `Student` / `Parent`.
- **Time on the wire:** the API accepts `HH:mm` or `HH:mm:ss` for time-of-day fields and always emits `HH:mm:ss`.
- The `data/` seed lists (e.g. [HomeContent](lib/data/home_content.dart)) are placeholders chosen so the UI has one obvious source of truth until the API lands — swap them for API-backed data, keeping the same `models/` shapes where possible.
- For the authoritative endpoint list and query params (e.g. `GET /api/tutors` search), read `../UNI-EDU-Backend/CLAUDE.md` — keep this file in sync with it rather than duplicating the whole table.
- **Pick state-management/networking patterns once, then record them here** (no choice has been made yet — there is no "the way we do it" to copy until you write it down).

## Notes

- This is the source-of-truth agent doc; `CLAUDE.md` imports it via `@AGENTS.md`. Edit **this** file and the change reaches both — don't duplicate guidance into `CLAUDE.md`.
- **Don't commit generated/build output:** `build/`, `.dart_tool/`, and `.idea/` are local artifacts (`build/` is already populated on disk).
- The backend's PR base branch is `dev`. Confirm this repo's branching with the team before opening PRs (this project is not yet a git repo locally).
