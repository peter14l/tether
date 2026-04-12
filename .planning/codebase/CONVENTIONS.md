# Coding Conventions

**Analysis Date:** 2026-04-12

## Naming Patterns

**Files:**
- Dart source files: `snake_case.dart` (e.g., `main.dart`, `user_service.dart`)
- Test files: `snake_case_test.dart` (e.g., `widget_test.dart`)

**Classes:**
- PascalCase (e.g., `MyApp`, `MyHomePage`, `UserService`)
- Widget classes append `Widget` suffix when ambiguous (e.g., `LoginFormWidget`)

**Methods/Functions:**
- camelCase (e.g., `_incrementCounter`, `build`, `initState`)
- Private methods/functions: Prefix with underscore (e.g., `_fetchData`)

**Variables:**
- camelCase (e.g., `_counter`, `userName`, `isValid`)
- Private variables: Prefix with underscore (e.g., `_counter`)

**Constants:**
- PascalCase for compile-time constants (e.g., `maxRetries`)
- SCREAMING_SCREAMING_SNAKE_CASE for enum-like constants (e.g., `API_BASE_URL`)

**Types:**
- PascalCase (e.g., `User`, `AuthResult`, `ApiResponse`)
- Interface-like abstract classes: Prefix with `I` (e.g., `IUserRepository`)

---

## Code Style

**Formatting Tool:**
- `dart format` (built-in Dart formatter)
- Run before commits: `dart format .`

**Linting Tool:**
- `flutter_lints` package version ^6.0.0
- Configured in `analysis_options.yaml`
- Strict mode ready - add custom rules as needed

**Key Lint Rules (from flutter_lints):**
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true
    avoid_print: false  # Enable for production
```

**Indentation:**
- 2 spaces (Dart default)
- No tabs

**Line Length:**
- Soft limit: 80 characters
- Hard limit: 100 characters

---

## Import Organization

**Order (top of file):**
1. Dart SDK imports (`dart:async`, `dart:io`)
2. Flutter SDK imports (`package:flutter/...`)
3. External package imports (`package:xxx/...`)
4. Project imports (`package:app/...`)

**Path Aliases:**
- Primary package: `package:app/` (configured in pubspec.yaml)
- Example: `import 'package:app/services/user_service.dart';`

**Grouping:**
```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:app/models/user.dart';
import 'package:app/services/auth_service.dart';
```

**Avoid Relative Imports:**
- Use absolute package imports: `import 'package:app/...';`

---

## Widget Pattern

**StatelessWidget:**
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

**StatefulWidget:**
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$_counter'),
      ),
    );
  }
}
```

**Pattern Rules:**
- Widgets should be `const` constructors when possible
- State classes prefixed with underscore (private)
- Use `setState()` for reactive state updates only

---

## Function Design

**Size:**
- Maximum ~50 lines per function
- Extract complex logic into named private methods

**Parameters:**
- Use named parameters for public APIs
- Use positional parameters for private/internal functions
- Prefer explicit types over `dynamic`

```dart
// Public API - Named parameters
void createUser({required String name, String? email}) { }

// Private - Positional
void _processData(String input) { }
```

**Return Values:**
- Explicit return types required
- Use `void` when no return value
- Nullable returns when appropriate: `String?`

---

## Error Handling

**Try-Catch:**
```dart
try {
  final result = await service.fetch();
} on NetworkException catch (e) {
  // Handle specific exception
  print('Network error: ${e.message}');
} catch (e) {
  // Catch-all for unexpected errors
  rethrow;
}
```

**Result Type Pattern:**
```dart
// Using Either or custom Result type
Result<User> getUser() {
  try {
    return Result.success(user);
  } catch (e) {
    return Result.failure(e.toString());
  }
}
```

**Async Errors:**
- Always await async functions in try-catch
- Use `Future<T>.catchError()` for edge cases

---

## Logging

**Framework:** `dart:developer` `log()` or `print()`

**Patterns:**
```dart
import 'dart:developer' as developer;

void log(String message) {
  developer.log(message, name: 'App');
}

// Debug logging (development only)
void debugLog(String message) {
  assert(() {
    developer.log(message, name: 'Debug');
    return true;
  }());
}
```

**When to Log:**
- API requests/responses
- State transitions
- Error conditions
- Performance markers

---

## Comments

**When to Comment:**
- Complex business logic
- Fixmes and todos: `// TODO:`, `// FIXME:`
- Public API documentation

**JSDoc/TSDoc:**
- Use `///` for public API documentation
- Document parameters and return values

```dart
/// Creates a new user with the given [name].
///
/// Throws [ValidationException] if [name] is empty.
Future<User> createUser(String name) async { ... }
```

**Avoid:**
- Obvious comments (e.g., `// Increment counter`)
- Commented-out code (use version control)

---

## Module Design

**Exports:**
```dart
// lib/src/services/auth_service.dart
export 'auth_service.dart';  // Barrel file pattern
```

**Barrel Files:**
```dart
// lib/src/services/services.dart
export 'auth_service.dart';
export 'user_service.dart';
export 'api_service.dart';
```

**Pattern:**
- One class per file (recommended)
- Group related functionality in directories
- Use barrel files for clean imports

---

## Constants & Configuration

**App Constants:**
```dart
class AppConstants {
  static const String appName = 'Tether';
  static const int apiTimeout = 30;
  static const String apiBaseUrl = 'https://api.tether.com';
}
```

**Environment-Based Config:**
```dart
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.tether.com',
);
```

---

## Recommended Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── models/
├── services/
├── repositories/
├── screens/
├── widgets/
└── providers/
```

---

*Convention analysis: 2026-04-12*