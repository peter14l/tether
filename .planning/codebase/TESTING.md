# Testing Patterns

**Analysis Date:** 2026-04-12

---

## Test Framework

**Runner:**
- `flutter_test` - Built-in Flutter testing package
- Pub package: `flutter_test` (sdk dependency in pubspec.yaml)

**Runner Command:**
```bash
flutter test                  # Run all tests
flutter test --watch       # Watch mode (requires flutter_test)
flutter test --coverage   # With coverage report
dart test                 # Pure Dart tests (no Flutter)
```

**Assertion Library:**
- `flutter_test` (built-in `expect`, `faker`, `test`)

---

## Test File Organization

**Location:**
- Co-located with source: `test/widget_test.dart`
- Alternative: Separate `test/` directory structure mirrors `lib/`

**Naming Pattern:**
```
test/
├── main_test.dart
├── widget_test.dart
└── services/
    └── auth_service_test.dart
```

**Directory Structure:**
```
test/
├── unit/
│   ├── models/
│   ├── services/
│   └── repositories/
├── widget/
│   ├── screens/
│   └── widgets/
└── integration/
    └── e2e/
```

---

## Test Structure

**Basic Widget Test (Current):**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 1. Build widget
    await tester.pumpWidget(const MyApp());

    // 2. Verify initial state
    expect(find.text('0'), findsOneWidget);

    // 3. Trigger action
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 4. Verify result
    expect(find.text('1'), findsOneWidget);
  });
}
```

**Widget Test Best Practices:**
- Use `testWidgets` for UI tests
- Use `pumpWidget` to build widget tree
- Use `pump()` or `pumpAndSettle()` to trigger rebuilds
- Use `find` to locate widgets by key, text, icon, or type

---

## Mocking

**Mocking Framework:**
- `mocktail` - Pure Dart mocking (recommended)
- Add to pubspec.yaml: `mocktail: ^1.0.0`

**Setup:**
```dart
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
  });
}
```

**Stubbing:**
```dart
when(() => mockUserService.getUser(any()))
    .thenAnswer((_) async => User(id: '1', name: 'Test'));
```

**Verification:**
```dart
verify(() => mockUserService.getUser('1')).called(1);
verifyNever(() => mockUserService.deleteUser(any()));
```

---

## Fixtures and Factories

**Test Data:
```dart
import 'package:app/models/user.dart';

class TestFixtures {
  static User user({String? id, String? name}) {
    return User(
      id: id ?? 'test-id',
      name: name ?? 'Test User',
    );
  }

  static List<User> users({int count = 3}) {
    return List.generate(
      count,
      (i) => user(id: 'user-$i', name: 'User $i'),
    );
  }
}
```

**Factory Pattern:**
```dart
class UserFactory {
  String _id = '0';
  String _name = 'Test';

  UserFactory withId(String id) {
    _id = id;
    return this;
  }

  UserFactory withName(String name) {
    _name = name;
    return this;
  }

  User build() {
    return User(id: _id, name: _name);
  }
}

// Usage
final user = UserFactory().withName('Alice').build();
```

---

## Coverage

**Requirements:** None enforced currently

**View Coverage:**
```bash
# Flutter coverage
flutter test --coverage

# View HTML report
coverage/html/index.html
```

**Coverage Target (Recommended):**
- Unit tests: 80%+ coverage
- Widget tests: 60%+ coverage
- Overall: 70%+ coverage

**Exclude from Coverage:**
```yaml
# analysis_options.yaml
analyzer:
  exclude:
    - test/*.g.dart
    - "**/*.g.dart"
```

---

## Test Types

**Unit Tests:**
- Test pure Dart code (models, services, repositories)
- No Flutter dependencies
- Fast execution

```dart
void main() {
  group('User Model', () {
    test('creates user with required fields', () {
      final user = User(id: '1', name: 'Test');
      expect(user.id, '1');
      expect(user.name, 'Test');
    });

    test('toJson serializes correctly', () {
      final user = User(id: '1', name: 'Test');
      final json = user.toJson();
      expect(json['id'], '1');
    });
  });
}
```

**Widget Tests:**
- Test Flutter widgets in isolation
- Use `WidgetTester` for interactions

```dart
testWidgets('LoginForm submits on button tap', (tester) async {
  await tester.pumpWidget(const LoginForm());
  
  await tester.enterText(find.byType(TextField), 'test@example.com');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  expect(find.text('Success'), findsOneWidget);
});
```

**Integration Tests:**
- Full app integration testing
- Use `integration_test` package

```bash
# Run on physical device/emulator
flutter test integration_test/app_test.dart
```

**E2E Tests:**
- Not currently configured
- Consider: `flutter_goldens` for visual regression

---

## Common Patterns

**Async Testing:**
```dart
test('fetches user asynchronously', () async {
  final service = MockUserService();
  when(() => service.getUser('1'))
      .thenAnswer((_) async => User(id: '1', name: 'Test'));

  final user = await service.getUser('1');
  
  expect(user.name, 'Test');
  verify(() => service.getUser('1')).called(1);
});
```

**Error Testing:**
```dart
test('throws on network error', () async {
  final service = MockUserService();
  when(() => service.getUser(any()))
      .thenThrow(NetworkException('No connection'));

  expect(
    () => service.getUser('1'),
    throwsA(isA<NetworkException>()),
  );
});
```

**Widget State Testing:**
```dart
testWidgets('loading state shows spinner', (tester) async {
  when(() => mockService.fetch())
      .thenAnswer((_) async {
    await Future.delayed(const Duration(seconds: 1));
    return data;
  });

  await tester.pumpWidget(MyWidget(service: mockService));
  
  // Initial state
 expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // Wait for async
  await tester.pumpAndSettle();
  
  // Loaded state
  expect(find.byType(CircularProgressIndicator), findsNothing);
});
```

---

## Testing Recommendations

**Add to `pubspec.yaml`:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
```

**Test Commands:**
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests in watch mode
flutter test --watch

# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widget/
```

---

## CI/CD Integration

**GitHub Actions (Example):**
```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter test --coverage
```

---

*Testing analysis: 2026-04-12*