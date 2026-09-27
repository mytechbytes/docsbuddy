# Backends

The app talks to its backend only through repository interfaces
(`features/*/domain/*_repository.dart`). Which implementation is used is
decided in one place: `lib/bootstrap/`.

| Piece | Role |
|---|---|
| `bootstrap/backend_module.dart` | `BackendModule` — abstract factory with one `createXRepository()` per repository, plus `backendOverrides()` which binds any module to the providers (and applies shared rules such as rebuilding family-scoped repos). |
| `bootstrap/backends/supabase_backend.dart` | Supabase implementation. All SDK setup (keys, secure session storage) lives here. |
| `bootstrap/backends/fake_backend.dart` | In-memory implementation for local dev, tests and screenshots. |
| `bootstrap/dependencies.dart` | `createBackend(BackendKind)` — the only `switch` over backends. |
| `core/config/env.dart` | `BackendKind` enum; `--dart-define=BACKEND=fake|supabase` (defaults to Supabase when its keys are set). |

Backend-neutral building blocks: `core/data/file_storage.dart` (`FileStorage`),
`core/data/json.dart`, `core/error/app_failure.dart`. Supabase-only helpers live
in `core/data/supabase/`.

## Adding your own API

1. **HTTP plumbing (once):** `core/data/api/api_client.dart` (base URL, auth
   header + token refresh, JSON decode) and `guardApi()` mapping HTTP status /
   network errors to `AppFailure` (401 → `AuthFailure`, 422 → `ValidationFailure`,
   5xx → `ServerFailure`, offline → `NetworkFailure`). If files go through the
   API, add `ApiFileStorage implements FileStorage`.
2. **Per feature:** `features/<f>/data/api_<f>_repository.dart` implementing the
   domain interface, with its own DTO mapping. Don't adapt the Supabase data
   sources — they're shaped around Supabase rows/joins; with your own API the
   server owns rules like family resolution and find-or-create, so the API
   repository is usually one call per method.
3. **Wire it:** add `api` to `BackendKind`, write
   `bootstrap/backends/api_backend.dart implements BackendModule` (the compiler
   lists any repository you missed), and add one case to `createBackend()`.
4. **Run:** `flutter run --dart-define=BACKEND=api --dart-define=API_BASE_URL=…`.

Nothing in `domain/`, `application/` or `presentation/` changes. Reuse each
feature's repository tests against the API implementation (mock the HTTP layer).
