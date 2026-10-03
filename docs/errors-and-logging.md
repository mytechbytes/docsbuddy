# Errors and logging

Both are centralized — one place decides, everything else calls it.

## Errors

```
SDK exception ──translateBackendError──▶ AppFailure ──localizeFailure──▶ text in the user's language
                (core/data/supabase)     (core/error)   (core/l10n)
                                             │
                                             └──FailureReporter──▶ AppLogger (only the ones worth logging)
```

| Piece | Where | Job |
|---|---|---|
| `AppFailure` (+ `FailureReason`) | `core/error/app_failure.dart` | The one error type that crosses layers. A `reason` is a stable code the UI translates; without one, `message` is shown as-is |
| `guardBackend` / `translateBackendError` | `core/data/supabase/supabase_guard.dart` | The only translation from SDK exceptions. GoTrue error **codes** become reasons (`invalid_credentials`, `email_not_confirmed`, `over_request_rate_limit`, …); transport errors become `NetworkFailure`; an unknown message passes through |
| `localizeFailure` / `context.failureText` | `core/l10n/failure_text.dart` | Reason → text in the current language. Pure, so safe in `build` |
| `FailureReporter` | `core/error/failure_reporter.dart` | Decides what is logged (below); logs each failure once |
| `FailureObserver` | same file | A Riverpod observer — reports every provider that ends in an error (a screen's data failing to load) without each screen remembering to |

**What gets logged:** unexpected failures (`UnknownFailure`, or an exception
nobody translated) → *error*, with the real cause; the server refusing a request
(`ServerFailure`) → *warning*; what users cause and the app expects (offline,
wrong password, a blank form) → not logged.

**Showing an error from the UI**

- `runAction(context, action, loading: …)` — the usual route: loader, run, close
  loader, snackbar. Reports for you.
- `context.showFailure(error, stack)` — a snackbar; reports.
- `context.failureMessage(error, stack)` — text for an *inline* error (a form
  field); reports. Call it from a `catch`, never from `build`.
- `context.failureText(error)` — text only, no reporting; for `build`.

**Adding an error**: add a `FailureReason`, a string in every language
(`error*` key — the translation test enforces it), and the case in
`failure_text.dart`. If it comes from the server, map its code in
`_authReason` (or the equivalent) so it is translated.

## Logging

Everything logs through `AppLogger` (`core/logging/app_logger.dart`), injected via
`appLoggerProvider` — nothing calls `print`/`debugPrint`/`developer.log` directly
(the debug-only startup timings aside).

- `createLogger` (`core/logging/logging_setup.dart`) picks Crashlytics in release
  builds when Firebase is up, the debug console otherwise.
- `reportUncaughtErrors` routes uncaught Flutter and async errors to it as fatal.
- `info` leaves a Crashlytics breadcrumb, `warning` is a non-fatal "the app
  recovered" (best-effort steps: push, notifications, secure storage), `error` is
  an unexpected failure.

Firebase initialisation itself is in `bootstrap/firebase_init.dart`; it runs before
a logger exists and swallows its own failure.
