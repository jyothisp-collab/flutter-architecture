# Flutter Architecture Showcase

A reference implementation demonstrating Feature-Based Clean Architecture in Flutter with MVVM in the presentation layer.

## Overview

This repository demonstrates how to structure a Flutter project using Feature-Based Clean Architecture with MVVM. It is not a complete application — the example feature (task management) exists only to make architectural boundaries concrete.

The architecture emphasizes testability, separation of concerns, and dependency inversion over framework-specific patterns.

## Architecture

### Data Flow

```
View
  ↓
ViewModel
  ↓
Use Case
  ↓
Repository Interface (domain)
  ↓
Repository Implementation (data)
  ↓
Data Source
```

### Layer Responsibilities

**Presentation** — Views render UI and forward user interactions. ViewModels hold presentation state and coordinate use cases. Views do not contain business logic.

**Domain** — Contains entities, repository contracts, and use cases. Has no dependency on Flutter UI, data sources, or framework implementations.

**Data** — Contains models, data source implementations, and repository implementations that satisfy domain contracts.

**Core** — Shared types used across layers: error types and a Result wrapper for explicit error handling.

### Project Structure

```
lib/
├── main.dart                              — Composition root
├── core/
│   └── error/
│       ├── app_error.dart                  — AppError type
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

## Design Decisions

### Why Clean Architecture?

The domain layer depends only on Dart primitives and its own types. This means business rules can be tested without Flutter, and data sources can be swapped without touching presentation or domain code.

### Why MVVM?

ViewModel extends `ChangeNotifier` to expose state changes. Views listen via `AnimatedBuilder`, keeping the View passive and the ViewModel testable without a widget tree.

### Why a custom Result type?

`Result<T>` (Success/Failure) makes error handling explicit in the type signature. The ViewModel maps errors to user-facing messages, and the UI reacts to state changes rather than catching exceptions.

### Why in-memory data?

A `TaskLocalDataSource` with artificial latency simulates async operations without network dependencies. This keeps the repository self-contained and safe for a public repository.

### Dependency injection

Dependencies are composed explicitly in `main.dart` and passed through constructors. There is no service locator and no DI framework — the dependency graph is visible in one place:

```
TaskLocalDataSource
  → TaskRepositoryImpl
    → GetTasks / ToggleTask
      → TaskViewModel
        → TaskListView
```

### Dependency direction

The ViewModel does not depend on the repository directly. It depends on use cases (`GetTasks`, `ToggleTask`), which in turn depend on the `TaskRepository` abstraction defined in the domain layer. This means the ViewModel never needs to change when the data source changes.

## SOLID Principles

**Single Responsibility** — Each class has one reason to change. `TaskViewModel` manages state. `GetTasks` coordinates one operation. `TaskRepositoryImpl` bridges the data source to the domain contract.

**Open/Closed** — New data sources (REST, database) can be added by implementing `TaskRepository` without modifying the ViewModel or use case.

**Liskov Substitution** — Any `TaskRepository` implementation can replace another because they share the same contract.

**Interface Segregation** — The repository interface exposes only the operations the feature needs (`getTasks`, `toggleTask`), not a broad data-access API.

**Dependency Inversion** — The ViewModel depends on use case classes (`GetTasks`, `ToggleTask`), which depend on the `TaskRepository` abstraction. The concrete `TaskRepositoryImpl` in the data layer satisfies that interface. Dependencies flow inward toward the domain.

## State Management

`ChangeNotifier` is used because it is part of Flutter's foundation, requires no external packages, and clearly demonstrates the ViewModel pattern. The choice keeps focus on architecture rather than state-management mechanics.

## Testing

Tests are placed alongside the code they verify:

```
test/features/example_feature/
├── domain/usecases/get_tasks_test.dart
├── data/datasources/task_local_data_source_test.dart
└── presentation/viewmodels/task_viewmodel_test.dart
```

- **Use case test** — Verifies `GetTasks` delegates to the repository and returns the correct data.
- **Data source test** — Verifies in-memory CRUD behavior.
- **ViewModel test** — Verifies state transitions (loading → loaded, loading → error) and toggle behavior without a widget tree.

The architecture creates clear testing boundaries: each layer can be tested by providing a fake implementation of its direct dependency.

## Scope

This is a focused architectural reference. It deliberately omits:

- Authentication, payments, networking, caching, offline support
- Complex state-management comparisons
- Large UI implementations
- Production integrations

These topics are addressed in separate showcase repositories.

## Running

```bash
flutter pub get
flutter run
```

## Validation

```bash
dart format .
flutter analyze
flutter test
```
