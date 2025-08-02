# coderx

A lightweight and reactive state management system for Flutter.
Easily manage global or local state, handle async states, computed values, and react to changes with builders, consumers, listeners, and observers — all with simple Dart classes.

## 🚀 Features
> ✅ Simple and lightweight
> 🔄 Reactive updates with ChangeNotifier
> 💥 Built-in builder, listener, observer, and consumer widgets
> 📦 Global or local state
> 🌍 App config (theme, locale) management
> 🧮 Computed values (CoderComputed)
> 🔁 Async state (CoderAsync)

## 📦 Installation
Add this to your pubspec.yaml:
```yaml
dependencies:
  coderx: ^latest_version
```

## 🛠️ Basic Usage
#### 🔹 Import
```dart
import 'package:coderx/coderx.dart';
```

#### 🔹 Create a State
```dart
final counter = CoderState<int>(0);
```

#### 🔹 Use CoderConsumer to rebuild on state change
```dart
CoderConsumer<int>(
  state: counter,
  builder: (context, count) => Text('Count: $count'),
);
```

#### 🔹 Update State
```dart
counter.value++;
```

## 🧱 Multi-State Consumption
Use CoderMultiConsumer to listen to multiple states.
```dart
CoderMultiConsumer(
  states: [themeMode, locale],
  builder: (context) {
  return MaterialApp(
      themeMode: themeMode.value,
      locale: locale.value,
      home: const HomeScreen(),
    );
  },
);
```

#### 🎧 Listen for State Changes (Side Effects)
```dart
CoderListener<String?>(
  state: errorState,
  listener: (context, value) {
    if (value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $value")),
      );
    }
  },
  child: const HomeScreen(),
);
```

#### 🧮 Computed State
```dart
final username = CoderState<String>("Guest");

final welcomeMessage = CoderComputed<String>(
  compute: () => "👋 Welcome, ${username.value}!",
  dependencies: [username],
);
```

#### 🔄 Async State
```dart
final userAsync = CoderAsync<List<String>>();

Future<void> loadUsers() async {
  await userAsync.run(() async {
    await Future.delayed(Duration(seconds: 2));
    return ['Alice', 'Bob', 'Charlie'];
  });
}

// Display UI based on async state
CoderConsumer<CoderAsyncState<List<String>>>(
  state: userAsync.state,
  builder: (context, async) {
    if (async.isLoading) return CircularProgressIndicator();
    if (async.hasError) return Text("Error: ${async.error}");
    if (async.hasData) return Column(
      children: async.data!.map((e) => Text(e)).toList(),
    );
    return SizedBox();
  },
);

#### ⚙️ AppConfig (Global States)
```dart
class AppConfig {
  final themeMode = CoderState<ThemeMode>(ThemeMode.light);
  final locale = CoderState<Locale>(const Locale('en'));
  final counter = CoderState<int>(0);
  final username = CoderState<String>('Guest');
  final loading = CoderState<bool>(false);
  final error = CoderState<String?>(null);
  final userList = CoderState<List<String>>([]);
  
  late final welcomeMessage = CoderComputed<String>(
    compute: () => "👋 Welcome, ${username.value}!",
    dependencies: [username],
  );
  
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
}

final config = AppConfig();
```

### 🚀 About Me

👨‍💻 Senior Flutter Developer <br />
💡 One principle I always code by: <br />
*"Don’t just develop — Develop Innovative"*

### 📝 Author Profile

[![coderspacedev](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/coderspacedev) <br />
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/thoriya-prahalad-1b6a82137) <br />
[![Stack_Overflow](https://img.shields.io/badge/Stack_Overflow-FE7A16?style=for-the-badge&logo=stack-overflow&logoColor=white)](https://stackoverflow.com/users/9917404/thoriya-prahalad)

## Support
Feel free to contribute or raise issues.
For support, email thoriyaprahalad@gmail.com
