# Refactor TODO

- [x] Extract domain models (`Vehicle`, `MaintenanceRecord`).
- [x] Extract notification service.
- [x] Extract the Settings page.
- [x] Extract shared widgets (`SlideActions`, `RecordTile`, `Section`).
- [x] Extract `VehicleCard`.
- [x] Extract active Home page (`HomePage`).
- [x] Extract active Maintenance History page (`HistoryPage`).
- [x] Remove the now-inactive legacy `Home` block from `main.dart`.
- [x] Move application state and mutations out of the root app widget.
- [x] Extract the shared light/dark theme into `theme/app_theme.dart`.
- [x] Centralize shared UI constants in `constants/app_constants.dart`.
- [x] Extract `ServiceReminderSheet` to `widgets/service_reminder_sheet.dart`.
- [x] Extract `AddMaintenance` to `widgets/add_maintenance_sheet.dart`.
- [x] Extract the three-tab native bottom navigation into
  `widgets/app_bottom_navigation_bar.dart`.
- [x] Remove duplicate legacy `Empty`; the active empty-state widget is in
  `widgets/list_widgets.dart`.
- [x] Extract the maintenance form.
- [x] Extract Profile page and profile editor.
- [x] Extract Garage vehicle forms and camera guide.
- [x] Reduce `main.dart` to startup only; move app configuration to `app.dart`
  and tab navigation to `pages/main_page.dart`.
- [x] Replace `AppController` with Main, Home, History, Profile, Settings,
  Garage, and Reminder controllers.
- [x] Extract SharedPreferences/JSON persistence into `LocalAppRepository`.
- [x] Connect pages directly to their providers and remove app-state callback
  plumbing between MainPage, ProfilePage, and SettingsPage.
- [x] Test vehicle filtering, odometer updates, and restored persisted state.
- [x] Audit pages and form sheets: extract form validation, input normalization,
  model creation/mutation, attachment picking, and camera operations.
- [x] Add form controllers for vehicle, maintenance, reminder, and profile details.
- [x] Move camera lifecycle/capture into `CarCameraController` and platform
  file/photo picking into `AttachmentService`.
- [x] Move Home greeting/reminder derivation into its controller state.

## Current status

- `main.dart`: startup only (10 lines); no page, form, or widget declarations.
- `app.dart`: root app configuration and theme/provider composition.
- Dedicated controllers live in `controllers/`; the old `app_controller.dart`
  is removed. Home derives its view state from Garage, History, and Profile.
- `repositories/local_app_repository.dart` owns local storage access and JSON
  serialization. Each controller persists only its own data keys.
- Active extracted files: `pages/home_page.dart`, `pages/history_page.dart`,
  `pages/settings_page.dart`, `widgets/vehicle_card.dart`,
  `widgets/list_widgets.dart`, and `widgets/slide_actions.dart`.
- Remaining UI extracted to `pages/main_page.dart`, `pages/profile_page.dart`,
  `pages/profile_details_page.dart`, `pages/car_camera_guide.dart`,
  `widgets/add_vehicle_sheet.dart`, and `widgets/edit_vehicle_sheet.dart`.
- `ProfileDetails` is a data model in `models/profile_details.dart`.
- UI retains layout, text-field lifecycle, navigation, dialogs, and temporary
  form selection state. Data rules and platform operations live outside the UI.
- Verified: `flutter analyze` and controller/form/widget regression tests pass.
