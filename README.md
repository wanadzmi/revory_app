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

## Photo processing

New profile and vehicle images pass through `PhotoProcessingService` before
being used. Profile photos are limited to a 512-pixel longest edge and 100 KiB;
vehicle photos to 1280 pixels and 250 KiB. Processing preserves aspect ratio,
does not upscale, and tries lower JPEG quality and smaller dimensions when
needed. Images that cannot meet the byte limit are rejected with an error.

Gallery selection and guided vehicle-camera capture both use this pipeline.
Processed JPEGs are saved under the app Documents directory rather than the
picker/camera cache. Existing temporary image paths are not migrated; reselect
older missing images. Local photos are not a cloud backup and can be lost when
the app is uninstalled.

`PhotoProcessingService.toBase64()` converts a processed file for future backend
upload. Base64 adds approximately one-third to the JPEG size. Supabase upload
and server persistence are not connected yet. Receipts are not processed by this
photo pipeline.

After adding the native compression/storage plugins, stop and rebuild the app;
hot reload alone cannot load new plugins. Verify JPEG/HEIC orientation, gallery
selection, camera capture, and restart persistence on a physical device. Pipeline
tests substitute the native encoder; they do not validate device codec behavior.
