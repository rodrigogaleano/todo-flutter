# Todo

A cross-platform todo app, built on my own [design system](https://github.com/rodrigogaleano/rg-design-system-flutter).

![CI](https://github.com/rodrigogaleano/todo-flutter/actions/workflows/ci.yml/badge.svg)

**[Live demo](https://rodrigogaleano.github.io/todo-flutter/)** · **[Download APK](https://github.com/rodrigogaleano/todo-flutter/releases/latest)**

<img width="250" src="https://github.com/user-attachments/assets/a248f82a-d55b-4f75-9681-00b82ae759b8" />

## Features

- Email/password and Google sign-in, with account deletion (reauth-protected)
- Create, complete, and delete tasks, persisted live to Cloud Firestore
- Runtime theme (light/dark) and language switching, persisted across launches
- Localized in English, Português, Español, Deutsch
- Responsive: bottom sheets and back navigation on mobile, sidebar on desktop

## Screens


<img width="250" src="https://github.com/user-attachments/assets/85234032-2cfb-4869-8ef6-165b03869bf4" />
<img width="250" src="https://github.com/user-attachments/assets/93478863-fc86-4b79-a8d4-1d7a2858cdfe" />
<img width="250" src="https://github.com/user-attachments/assets/ed54e92d-79b1-4bec-82e1-3d2a45eac3b6" />
<img width="250" src="https://github.com/user-attachments/assets/530d085d-43ca-4bad-9fe0-e7050be9c004" />
<img width="250" src="https://github.com/user-attachments/assets/6056d1ec-f8cf-4ace-9050-0d4203233779" />
<img width="1000" src="https://github.com/user-attachments/assets/ba4fd9a9-dad6-4859-b91e-fc6d07657ee8" />
<img width="1000" src="https://github.com/user-attachments/assets/6a86928b-7f13-46b4-9ec5-0d9e0d30a61c" />
<img width="1000" src="https://github.com/user-attachments/assets/59a37533-caee-4c49-8fda-a4fea8240eef" />

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
