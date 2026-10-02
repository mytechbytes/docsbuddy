# DocsBuddy widget catalog

A [Widgetbook](https://docs.widgetbook.io) of everything the app draws: design
tokens, core widgets, every feature widget, and every screen. Look at any of
them in light and dark, on any screen size, at any font scale.

It lives outside `lib/` on purpose: `widgetbook` is a dev dependency, so none of
this ships in the app.

## Run it

```bash
flutter run -d chrome -t widgetbook/main.dart
```

or build a static copy you can host anywhere:

```bash
flutter build web -t widgetbook/main.dart --output build/widgetbook --no-tree-shake-icons
```

In VS Code pick **DocsBuddy (widget catalog)** from `.vscode/launch.json`.

## Checking a widget

Pick a use case in the tree, then use the panel on the right.

| Panel | Control | What it does |
|---|---|---|
| Addons | **Theme** | Light or dark, using the app's own `AppTheme` |
| Addons | **Text scale** | 0.8× to 3.0× font scaling (Android's "Large" is 1.3, "Largest" 2.0; iOS accessibility sizes reach about 3.1) |
| Addons | **Viewport** | Phone and tablet sizes, portrait and landscape, with safe areas. "Compact 320×568" is also what a phone becomes at Android's largest display size |
| Addons | **Zoom** | Magnifies the preview to inspect detail; changes no layout |
| Addons | **Inspector** | Tap a widget to see its size and padding |
| Knobs | per widget | Live controls (text, numbers, switches, enums) |

**Worst case:** Theme *Dark*, Text scale *2.0*, Viewport *Phone · compact*. That
is a small phone with the largest font setting, which real users configure.

## What's in the tree

- **Foundations**: colour palette (light and dark side by side), type ramp.
- **Core widgets**: buttons, text field, logo, settings list, step flow, startup screen, snackbars.
- **Feature widgets**: by feature. Most have a *Playground* (knobs) and a
  *gallery* that stacks every state with a caption.
- **Screens**: the real page widgets. Data-backed ones come in **Populated**,
  **Empty**, **Loading** and **Error**.

## How screens run

`support/harness.dart` gives every use case what it has in the app, minus the app:

- a `ProviderScope` bound to an in-memory backend (`support/scenario.dart`). The
  populated data is the same set the Play Store screenshots use
  (`lib/bootstrap/backends/demo_backend.dart`); *Loading* and *Error* wrap the
  real repositories so the real controllers handle them (`support/unreachable_backend.dart`);
- a stub go_router (`support/stub_go_router.dart`): `context.push('/asset/…')`
  lands on a placeholder that names the route instead of leaving the screen;
- its own `Navigator`, so dialogs and sheets stay inside the device frame. A
  screen that closes itself (e.g. after Save) shows "This screen closed itself"
  with a **Reopen** button.

This is the catalog's own composition root, kept separate from
`lib/bootstrap/dependencies.dart`. No plugins or network are touched.

Not covered: anything that needs a real photo, because photos load from a
network URL and the catalog is offline (the fallback shows instead).

## Adding to it

1. Add a use case in the matching file under `catalog/`. Helpers in
   `support/use_cases.dart`:
   - `component(name, builder)`: one widget, centred. `builder` runs in
     Widgetbook's build, so `context.knobs` works there.
   - `filling(name, builder)`: a widget that fills the preview (list, sheet).
   - `gallery(name, [Labeled(...), ...])`: every variant stacked and labelled.
   - `screen(name, builder, {scenario, root})`: a full page. Pass `root: true`
     for a tab or other bottom-of-stack screen so it gets no back button.
   - `screenStates(builder)`: the page in all four scenarios.
2. Use case names become URLs, so keep them plain, and unique within their
   component (a test checks this).
3. Run the smoke test.

## Tests

```bash
flutter test test/widgetbook
```

mounts every use case through the real Widgetbook route and fails on any
exception or overflow. A second, opt-in pass renders everything at once in the
worst case above and writes a worklist to `build/widgetbook_stress_report.txt`:

```bash
flutter test test/widgetbook --dart-define=WIDGETBOOK_STRESS=true --plain-name stress
```

It reports rather than fails: it is a list of places where the app itself does
not cope with large text on a small screen.
