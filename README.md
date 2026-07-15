# Todo

A cross-platform todo app and the first product built on my [Design System](https://github.com/rodrigogaleano/rg-design-system-flutter).

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
