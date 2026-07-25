# Todo

A cross-platform todo app, built on my own [design system](https://github.com/rodrigogaleano/rg-design-system-flutter).

![CI](https://github.com/rodrigogaleano/todo-flutter/actions/workflows/ci.yml/badge.svg)

**[Live demo](https://rodrigogaleano.github.io/todo-flutter/)** · **[Download APK](https://github.com/rodrigogaleano/todo-flutter/releases/latest)**

<!-- TODO: hero shot (desktop home, task list). Screenshot or short GIF. -->
<img width="900" alt="Todo app home" src="" />

## Features

- Email/password and Google sign-in, with account deletion (reauth-protected)
- Create, complete, and delete tasks, persisted live to Cloud Firestore
- Runtime theme (light/dark) and language switching, persisted across launches
- Localized in English, Português, Español, Deutsch
- Responsive: bottom sheets and back navigation on mobile, sidebar on desktop

## Screens

<!-- TODO: GIF of a core flow (create + complete a task). Keep it 5-10s. -->
<img width="700" alt="Managing tasks" src="" />

<!-- TODO: mobile + desktop side by side to show the responsive layout -->
<img width="250" alt="Mobile" src="" />
<img width="700" alt="Desktop" src="" />

## Tech stack

- **Flutter** / **Dart**
- **Firebase** — Authentication + Cloud Firestore
- **go_router** routing, **provider** state, **shared_preferences** storage
- **google_sign_in** + firebase_auth popup on web
- My own **[rg_design_system](https://github.com/rodrigogaleano/rg-design-system-flutter)**
- **GitHub Actions** — CI, web deploy to Pages, signed APK releases

## Architecture

It follows the official [Flutter app-architecture guidelines](https://docs.flutter.dev/app-architecture).

```
lib/
├── config/          # Dependency injection
├── routing/         # go_router config + route paths
├── utils/           # Result, Command, shared helpers
├── domain/
│   └── models/      # App-wide models
├── data/
│   ├── repositories/
│   ├── services/
│   └── model/       # Data-source DTOs
├── ui/
│   ├── core/        # Shared widgets + theme glue
│   └── <feature>/   # view_models/ + widgets/
└── main.dart
```

## Running locally

```
flutter pub get
flutter run
```
