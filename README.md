# Flutter Architecture Showcase

A reference implementation demonstrating Feature-Based Clean Architecture in Flutter with MVVM in the presentation layer. Built for client review to show how architectural boundaries improve testability and maintainability.

## What It Demonstrates

- **Feature-Based Clean Architecture** — Each feature owns its data, domain, and presentation layers in self-contained directories.
- **Dependency direction** — Presentation depends on domain, data depends on domain, domain depends on nothing Flutter-specific.
- **MVVM presentation layer** — `ChangeNotifier` ViewModels with `AnimatedBuilder` for reactive UI without `setState`.
- **Use case classes** — Single-responsibility classes that coordinate one operation between the ViewModel and repository.
- **Sealed `Result<T>`** — Explicit `Success`/`Failure` types that make error handling part of the method signature.
- **Sealed UI states** — `TaskState` with `Loading`, `Loaded`, and `Error` variants for exhaustive UI rendering.
- **Repository pattern** — Abstract interface in domain, implementation in data, enabling test doubles and data-source swaps.
- **Equatable entities** — Value-based equality for reliable state comparison.
- **Immutable models** — `copyWith` on entities and models, no mutable shared state.

## Architecture Overview

```
lib/
├── main.dart                              — Composition root
├── core/
│   └── error/
│       ├── app_error.dart                  — AppError sealed class
│       └── result.dart                     — Result<T> (Success / Failure)
└── features/
    └── example_feature/
        ├── data/
        │   ├── datasources/
        │   │   └── task_local_data_source.dart
        │   ├── models/
        │   │   └── task_model.dart
        │   └── repositories/
        │       └── task_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── task.dart
        │   ├── repositories/
        │   │   └── task_repository.dart
        │   └── usecases/
        │       ├── get_tasks.dart
        │       └── toggle_task.dart
        └── presentation/
            ├── views/
            │   └── task_list_view.dart
            ├── viewmodels/
            │   └── task_viewmodel.dart
            └── widgets/
                ├── task_item.dart
                └── status_widget.dart
```

### Data Flow

```
View
  ↓
ViewModel (ChangeNotifier)
  ↓
UseCase (GetTasks, ToggleTask)
  ↓
Repository interface (domain)
  ↓
Repository implementation (data)
  ↓
DataSource
```

The ViewModel never depends on the repository directly — it depends on use case classes, which depend on the repository abstraction. The concrete `TaskRepositoryImpl` satisfies that interface in the data layer.

## Design Decisions

### Why Clean Architecture?

The domain layer depends only on Dart primitives and its own types. Business rules can be tested without Flutter, and data sources can be swapped without touching presentation or domain code.

### Why MVVM?

`ChangeNotifier` exposes state changes that Views listen to via `AnimatedBuilder`. The View stays passive and the ViewModel is testable without a widget tree.

### Why a custom Result type?

`Result<T>` (Success/Failure) makes error handling explicit in every method signature. The ViewModel maps errors to user-facing messages, and the UI reacts to state changes rather than catching exceptions.

### Why in-memory data?

A `TaskLocalDataSource` with artificial latency simulates async operations without network dependencies. This keeps the repository self-contained and safe for a public repository.

### Why no DI framework?

Dependencies are composed explicitly in `main.dart` and passed through constructors. The dependency graph is visible in one place:

```
TaskLocalDataSource
  → TaskRepositoryImpl
    → GetTasks / ToggleTask
      → TaskViewModel
        → TaskListView
```

## SOLID Principles

| Principle | Application |
|---|---|
| **Single Responsibility** | Each class has one reason to change. `TaskViewModel` manages state. `GetTasks` coordinates one operation. |
| **Open/Closed** | New data sources (REST, database) can be added by implementing `TaskRepository` without modifying the ViewModel. |
| **Liskov Substitution** | Any `TaskRepository` implementation can replace another because they share the same contract. |
| **Interface Segregation** | The repository exposes only operations the feature needs, not a broad data-access API. |
| **Dependency Inversion** | The ViewModel depends on use cases, which depend on the `TaskRepository` abstraction. Dependencies flow inward. |

## Testing

Tests are placed alongside the code they verify:

- **Use case test** — Verifies `GetTasks` delegates to the repository and returns the correct data.
- **Data source test** — Verifies in-memory CRUD behavior.
- **ViewModel test** — Verifies state transitions (loading → loaded, loading → error) and toggle behavior without a widget tree.

The architecture creates clear testing boundaries: each layer can be tested by providing a fake implementation of its direct dependency.

Run:

```bash
flutter pub get
flutter test
flutter analyze
```

## Out Of Scope

- Persistent storage (in-memory only).
- Networking or API calls.
- Authentication flows.
- Complex UI, animations, or deep navigation.
- Dependency injection frameworks.
- Code generation.
- Comparison with other state management libraries.
