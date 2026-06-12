# News App - Clean Architecture & BLoC

[![Flutter](https://img.shields.io/badge/Flutter-v3.38.5-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-v3.10.4-0175C2?logo=dart)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State_Management-BLoC-blue)](https://bloclibrary.dev/)

A professional news application built with Flutter, demonstrating industry-standard best practices, including Clean Architecture, SOLID principles, and comprehensive unit testing. The project consumes the [NewsAPI](https://newsapi.org/) to provide real-time news updates.

## Screenshots

| News Search & Feed | News Details & Web View |
|:---:|:---:|
| <img src="Screenshot_1780648172.png" width="300"> | <img src="news_details_page.png" width="300"> |

## Features

### News Module (`feature_home`)
- **Live News Search**: Query news articles based on keywords.
- **Dynamic News Feed**: Display headlines with images, descriptions, and source information.
- **Graceful Error Handling**: Specialized UI states for network issues and server errors.

### News Details Module (`feature_news_details`)
- **Collapsing Sliver Header**: Display the article's cover photo with smooth parallax scaling and gradient shading.
- **Pinch-to-Zoom Fullscreen Viewer**: Tapping on the cover image opens an interactive fullscreen page with pinch-to-zoom and double-tap zoom capabilities.
- **Native Share Integration**: Instantly share the article URL and headline using system-native share sheets.
- **In-App Web View**: View full-text original articles in a dedicated Web View featuring loading progress and custom browser navigation controls.

### Bookmarked News Module (`feature_bookmarked_news`)
- **Offline Bookmarks**: Save favorite news articles for offline access using fast, synchronous local storage (`GetStorage`).
- **Bookmark Management**: Add or remove articles from the bookmark list seamlessly from the news details page.
- **Dedicated Bookmark Page**: View all saved articles in a dedicated, easily accessible page.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: BLoC
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
- **Entities**: Simple POJs using `Equatable` (e.g., `GetNewsEntity`, `NewsDetailEntity`).
- **UseCases**: Specific business actions (e.g., `GetNewsUseCase`, `ShareNewsUseCase`).
- **Repositories**: Abstract contracts defining the interface for data operations.

### 2. Data Layer
Responsible for data retrieval and mapping.
- **Models**: Data transfer objects (DTOs) with `fromJson` and `toJson` logic, extending Entities.
- **DataSources**: Remote (API) and Local (currently not implemented) data providers.
- **Repositories Implementation**: Concrete implementation of Domain Repository contracts (e.g., `GetNewsRepositoryImpl`, `NewsDetailsRepositoryImpl`).

### 3. Presentation Layer
Handles the UI and user interactions.
- **BLoCs**: Manages UI state based on events (e.g., `HomeBloc`, `NewsDetailsBloc`).
- **Pages/Widgets**: Pure UI components that react to BLoC states (e.g., `HomePage`, `NewsDetailsPage`, `FullscreenImageViewer`, `NewsWebViewPage`).

## Clean Architecture Structure

```
lib/
├── core/
│   ├── error/          # Failure abstractions
│   ├── router/         # GoRouter path definitions
│   └── utils/          # Constants and Base UseCase
├── features/
│   ├── feature_bookmarked_news/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
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
│   └── feature_news_details/
│       ├── data/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
├── di.dart             # Dependency Injection Setup
└── main.dart           # Entry point
```

## State Management

The application uses **BLoC** to maintain a strict separation between UI and business logic. 

**Event Flow Example (Sharing):**
1. UI adds `ShareArticleEvent(url, title)` to `NewsDetailsBloc`.
2. `NewsDetailsBloc` emits `ShareLoadingStatus`.
3. `NewsDetailsBloc` calls `ShareNewsUseCase`.
4. Usecase triggers `NewsDetailsRepository` implementation, which interacts with `SharePlus` platform.
5. `NewsDetailsBloc` receives `Either<Failure, void>`.
6. `NewsDetailsBloc` emits `ShareSuccessStatus` or `ShareErrorStatus` to update SnackBar notifications in the UI.

## Dependency Injection

Dependencies are managed using **GetIt**. This ensures that the codebase remains decoupled and highly testable.

```dart
// Example from di.dart
final di = GetIt.instance;

Future<void> setup() async {
  // Home
  di.registerSingleton<GetNewsRequest>(GetNewsRequest(dio: Dio()));
  di.registerSingleton<GetNewsRepository>(GetNewsRepositoryImpl(getNewsRequest: di()));
  di.registerFactory<HomeBloc>(() => HomeBloc(getNewsUseCase: di()));

  // News Details
  di.registerSingleton<NewsDetailsRepository>(NewsDetailsRepositoryImpl());
  di.registerSingleton<ShareNewsUseCase>(ShareNewsUseCase(repository: di()));
  di.registerFactory<NewsDetailsBloc>(() => NewsDetailsBloc(shareNewsUseCase: di()));
}
```

## Error Handling Strategy

The app uses a functional approach to error handling with the `Dartz` package. Instead of throwing exceptions that can crash the app or be missed, methods return an `Either<Failure, Success>` type.

- **Failure Classes**: `ServerFailure`, `NetworkFailure`, `UnknownFailure`.
- **UI Propagation**: Failures are mapped to specific user-friendly messages in the BLoC layer and displayed via the UI.

## Testing

The project emphasizes testability with a healthy suite of unit tests across **every layer** of **every feature**.

- **Unit Tests**: Logic testing for UseCases and Entities.
- **Repository Tests**: Verifies data mapping, error conversion, and platform-channel abstraction tests using custom platform overrides.
- **DataSource Tests**: Validates API request construction and `Dio` integration.
- **BLoC Tests**: Uses `bloc_test` to verify state emission sequences.
- **Mocking**: Utilizes `Mockito` and platform mocks for isolating dependencies.

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
| `share_plus` | Platform-native content sharing |
| `webview_flutter` | Embedded browser view support |
| `get_storage` | Lightweight, fast local storage for offline bookmarks |
| `bloc_test` | BLoC Unit Testing |
| `mockito` | Mocking framework |

## Getting Started

### Prerequisites
- Flutter SDK: `^3.38.5` (or compatible versions matching sdk constraint)
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
