# News App - Clean Architecture & BLoC

[![Flutter](https://img.shields.io/badge/Flutter-v3.38.5-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-v3.10.4-0175C2?logo=dart)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State_Management-BLoC-blue)](https://bloclibrary.dev/)

A professional news application built with Flutter, demonstrating industry-standard best practices, including Clean Architecture, SOLID principles, and comprehensive unit testing. The project consumes the [NewsAPI](https://newsapi.org/) to provide real-time news updates.

## Screenshots

| News Search & Feed 
|:---:|
| <img src="Screenshot_1780648172.png" width="300">

## Features

### News Module (`feature_home`)
- **Live News Search**: Query news articles based on keywords.
- **Dynamic News Feed**: Display headlines with images, descriptions, and source information.
- **Infinite Scrolling**: (Internal logic supports extension, current implementation focuses on fetch-by-query).
- **Graceful Error Handling**: Specialized UI states for network issues and server errors.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: BLoC / Cubit
- **Networking**: Dio (Interceptor-ready)
- **Dependency Injection**: GetIt
- **Functional Programming**: Dartz (Either type for error handling)
- **Navigation**: GoRouter
- **Testing**: Flutter Test, Mockito, Bloc Test
- **Utilities**: Equatable (Value equality), CachedNetworkImage

## Architecture Overview

The project is divided into three main layers, following the Clean Architecture pattern:

### 1. Domain Layer
The core of the application, containing business logic and high-level abstractions. It is independent of any other layer.
- **Entities**: Simple POJOs (Plain Old Java Objects) using `Equatable`.
- **UseCases**: Specific business actions (e.g., `GetNewsUseCase`).
- **Repositories**: Abstract contracts defining the interface for data operations.

### 2. Data Layer
Responsible for data retrieval and mapping.
- **Models**: Data transfer objects (DTOs) with `fromJson` and `toJson` logic, extending Entities.
- **DataSources**: Remote (API) and Local (currently not implemented) data providers.
- **Repositories Implementation**: Concrete implementation of Domain Repository contracts.

### 3. Presentation Layer
Handles the UI and user interactions.
- **BLoCs**: Manages UI state based on events.
- **Pages/Widgets**: Pure UI components that react to BLoC states.

## Clean Architecture Structure

```
lib/
├── core/
│   ├── error/          # Failure abstractions
│   └── utils/          # Constants and Base UseCase
├── features/
│   ├── feature_home/
│   │   ├── data/
│   │   │   ├── data_source/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
├── di.dart             # Dependency Injection Setup
└── main.dart           # Entry point
```

## State Management

The application uses **BLoC** to maintain a strict separation between UI and business logic. 

**Event Flow Example:**
1. UI adds `LoadNewsEvent("flutter")` to `HomeBloc`.
2. `HomeBloc` emits `LoadingNewsStatus`.
3. `HomeBloc` calls `GetNewsUseCase`.
4. `HomeBloc` receives `Either<Failure, GetNewsEntity>`.
5. `HomeBloc` emits `GetNewsCompletedStatus` (Success) or `ErrorOnGettingNewsStatus` (Failure).

## Dependency Injection

Dependencies are managed using **GetIt**. This ensures that the codebase remains decoupled and highly testable.

```dart
// Example from di.dart
final di = GetIt.instance;

Future<void> setup() async {
  di.registerSingleton<GetNewsRequest>(GetNewsRequest(dio: Dio()));
  di.registerSingleton<GetNewsRepository>(GetNewsRepositoryImpl(getNewsRequest: di()));
  di.registerFactory<HomeBloc>(() => HomeBloc(getNewsUseCase: di()));
}
```

## Error Handling Strategy

The app uses a functional approach to error handling with the `Dartz` package. Instead of throwing exceptions that can crash the app or be missed, methods return an `Either<Failure, Success>` type.

- **Failure Classes**: `ServerFailure`, `NetworkFailure`, `UnknownFailure`.
- **UI Propagation**: Failures are mapped to specific user-friendly messages in the BLoC layer and displayed via the UI.

## Testing

The project emphasizes testability with a healthy suite of unit tests.

- **Unit Tests**: Logic testing for UseCases and Entities.
- **Repository Tests**: Verifies data mapping and error conversion.
- **DataSource Tests**: Validates API request construction and `Dio` integration.
- **BLoC Tests**: Uses `bloc_test` to verify state emission sequences.
- **Mocking**: Utilizes `Mockito` for isolating dependencies.

To run tests:
```bash
flutter test
```

## Packages Used

| Package | Purpose |
|:--- |:--- |
| `flutter_bloc` | State Management |
| `dio` | HTTP Client |
| `get_it` | Service Locator / DI |
| `dartz` | Functional Programming (Error Handling) |
| `equatable` | Value Equality Comparison |
| `go_router` | Declarative Routing |
| `bloc_test` | BLoC Unit Testing |
| `mockito` | Mocking framework |

## Getting Started

### Prerequisites
- Flutter SDK: `^3.38.5`
- An API Key from [NewsAPI.org](https://newsapi.org/)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/oraclematrix/news_app_4_clean_architecture_bloc.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add your API key in `lib/core/utils/constants.dart`.

### Run Project
```bash
flutter run
```

## Project Highlights

- **SOLID Principles**: Each class has a single responsibility and dependencies are inverted.
- **Scalable Structure**: New features can be added in isolation within the `features/` directory.
- **Maintainability**: Clear separation between UI and Data ensures changes in the API won't break the UI.
- **Portfolio Ready**: Demonstrates advanced Flutter concepts used in production-grade applications.

---

**Author**: [Ehsan Mohammadipour]
*Senior Flutter Engineer specialized in Clean Architecture and Scalable Systems.*
