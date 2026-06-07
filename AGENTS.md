# AGENTS.md

Guidance for AI coding agents working in `uni_edu_mobile`. (Claude Code reads this via `@AGENTS.md` from `CLAUDE.md`.)

## What this is

`uni_edu_mobile` is the **Flutter mobile client** for the UNI-EDU tutoring platform. The platform connects students/parents with tutors; the .NET backend and React web frontend are sibling projects:

- `../UNI-EDU-Backend` — ASP.NET Core (.NET 10) REST API. See its `CLAUDE.md` for the full domain model, endpoints, and response conventions.
- `../UNI-EDU-Frontend-V2` — web frontend.

> **Current state:** this is still the **default Flutter scaffold** (the counter demo in [lib/main.dart](lib/main.dart) and its smoke test in [test/widget_test.dart](test/widget_test.dart)). There is no app-specific architecture, networking, state management, or routing yet. The sections below describe the toolchain that exists today and the conventions to follow as the app is built out — don't document features that don't exist.

## Toolchain

- **Flutter** stable 3.41.x, **Dart** 3.12 (`environment.sdk: ^3.12.0` in [pubspec.yaml](pubspec.yaml)).
- Lints: `flutter_lints` ^6.0.0 via [analysis_options.yaml](analysis_options.yaml) (`package:flutter_lints/flutter.yaml`).
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
flutter build apk            # release Android build
flutter build ios            # release iOS build (run on macOS)
flutter clean                # nuke build/ and .dart_tool/ when builds get weird
```

## Conventions to follow as the app grows

- **Keep `flutter analyze` and `dart format` clean.** Fix lint warnings rather than suppressing them; if a rule genuinely doesn't fit, disable it in [analysis_options.yaml](analysis_options.yaml) with a comment, not per-line ignores scattered through the code.
- **Add a test alongside new logic.** The scaffold ships one widget smoke test; keep `test/` meaningful as real screens land (update/remove the counter test once `MyApp` is replaced).
- **Pick patterns once, write them here.** When you introduce state management, routing, networking, or a folder layout under `lib/`, record the choice in this file so it stays consistent. Until then, there is no "the way we do it" to copy.
- **Don't commit generated/build output.** `build/`, `.dart_tool/`, and `.idea/` are local artifacts (`build/` is already populated on disk).

## Talking to the backend

When wiring up networking, target the UNI-EDU backend and match its contract exactly:

- **Base URL (local dev):** `http://localhost:5115` (http profile) or `https://localhost:7271` (https). From the **Android emulator**, `localhost` is the emulator itself — use `http://10.0.2.2:5115` to reach the host machine. Make the base URL configurable (e.g. `--dart-define=API_BASE_URL=...`) rather than hard-coding it.
- **Response envelope:** successful responses are wrapped in `ApiResponse<T>` → `{ statusCode, message, data }`. Paged endpoints put a `PagedResult<T>` in `data` → `{ items, total, page, pageSize, totalPages }`. Parse the envelope, then `data`.
- **Errors:** non-2xx responses return an `ErrorResponse` (camelCase) with field-level `errors[]` on validation failures. Surface `message`/`errors` to the user rather than a raw status code.
- **Auth:** JWT bearer. `POST /api/login` returns an access token (1h lifetime) and sets an `HttpOnly` `refreshToken` cookie; `POST /api/refresh-token` rotates it. Send the access token as `Authorization: Bearer <token>`; persist it securely (e.g. `flutter_secure_storage`) — never in plain `SharedPreferences`. Roles are `Admin` / `Tutor` / `Student` / `Parent`.
- **Time on the wire:** the API accepts `HH:mm` or `HH:mm:ss` for time-of-day fields and always emits `HH:mm:ss`.
- For the authoritative endpoint list and query params (e.g. `GET /api/tutors` search), read `../UNI-EDU-Backend/CLAUDE.md` — keep this file in sync with it rather than duplicating the whole table.

## Notes

- This is the source-of-truth agent doc; `CLAUDE.md` imports it. Edit **this** file and the change reaches both.
- The backend's PR base branch is `dev`. Confirm this repo's branching with the team before opening PRs (this project is not yet a git repo locally).
