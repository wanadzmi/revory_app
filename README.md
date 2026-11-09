# Revory

Every Service. Every Part. Remembered.

A Flutter vehicle maintenance app for Android and iOS.

## Project structure

```text
lib/
  main.dart                    # Platform initialization and ProviderScope
  app.dart                     # Root app, startup restoration, and theme wiring
  features/
    home/                      # Selected vehicle overview and recent maintenance
    garage/                    # Vehicles, forms, photos, and guided camera
    maintenance/               # History, maintenance records, and entry form
    profile/                   # Profile display, editing, and profile model
    settings/                  # Appearance and notification preferences
    reminders/                 # Service target form and notification coordination
    navigation/                # Primary tab page, controller, and bottom bar
  core/
    repositories/              # Local persistence boundary
    services/                  # Platform attachment and notification APIs
  shared/
    widgets/                   # Reusable section headings and swipe actions
    theme/                     # Shared light and dark appearance
    utils/                     # Shared display formatting
test/                          # Controller, form, and page interaction tests
tool/check.sh                  # Formatting, strict lint, and test gate
```

Each feature contains only the subfolders it needs: `pages/`, `controllers/`,
`widgets/`, `models/`, or `constants/`. Keep feature-specific components beside
their owning feature; place code in `shared/` only when multiple features use it.

Pages own layout, navigation, and dialogs. Controllers own feature state and
business rules. Form controllers validate and normalize input. Core repositories
and services own persistence and platform operations. Controllers must not import
pages/widgets or accept BuildContext. Reuse existing provider state across modules
instead of maintaining duplicate copies. Use `package:revory/` imports.

## Development

```bash
flutter pub get
flutter run
```

Run the quality gate before submitting changes:

```bash
bash tool/check.sh
```

The gate checks formatting, runs Very Good Analysis with warnings and information
treated as failures, and runs all tests. Keep documentation for public APIs and
fix diagnostics without disabling the strict preset. Platform camera and
notification behavior also require verification on a device.
