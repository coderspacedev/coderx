import 'package:flutter/material.dart';
import 'package:coderx/coderx.dart';

void main() {
  runApp(const LauncherApp());
}

/// Global AppConfig Singleton
class AppConfig {
  final themeMode = CoderState<ThemeMode>(ThemeMode.light);
  final locale = CoderState<Locale>(const Locale('en'));
  final counter = CoderState<int>(0);
  final username = CoderState<String>('Guest');
  final loading = CoderState<bool>(false);
  final error = CoderState<String?>(null);
  final userList = CoderState<List<String>>([]);

  /// Async state example
  final posts = CoderAsync<List<String>>();

  /// Computed state example
  late final CoderComputed<String> welcomeMessage = CoderComputed<String>(
    compute: () => "👋 Welcome, ${username.value}!",
    dependencies: [username],
  );

  AppConfig._internal();
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
}

final config = AppConfig();

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CoderMultiConsumer(
      states: [config.themeMode, config.locale],
      builder: (context) {
        return MaterialApp(
          title: 'CoderX State Management',
          themeMode: config.themeMode.value,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          locale: config.locale.value,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void toggleTheme() {
    config.themeMode.value = config.themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void fetchUsers() async {
    config.loading.value = true;
    config.error.value = null;

    await Future.delayed(const Duration(seconds: 2));
    try {
      config.userList.value = ['Alice', 'Bob', 'Charlie'];
    } catch (e) {
      config.error.value = 'Failed to fetch users';
    } finally {
      config.loading.value = false;
    }
  }

  void fetchPosts() async {
    await config.posts.run(() async {
      await Future.delayed(const Duration(seconds: 2));
      return ['Post A', 'Post B', 'Post C'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CoderListener<String?>(
      state: config.error,
      listener: (context, error) {
        if (error?.isNotEmpty ?? false) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('❌ $error')));
        }
      },
      child: CoderMultiConsumer(
        states: [
          config.counter,
          config.loading,
          config.userList,
          config.welcomeMessage,
          config.posts.state,
        ],
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("CoderX State Management"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: toggleTheme,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: config.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(config.welcomeMessage.value),
                          const SizedBox(height: 16),

                          /// Fetch Users
                          ElevatedButton(
                            onPressed: fetchUsers,
                            child: const Text("Fetch Users"),
                          ),
                          const SizedBox(height: 16),
                          if (config.userList.value.isNotEmpty)
                            ...config.userList.value.map(
                              (user) => Text("👤 $user"),
                            ),

                          const Divider(),

                          /// Counter
                          Text("Counter: ${config.counter.value}"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => config.counter.value++,
                            child: const Text("Increment Counter"),
                          ),

                          const Divider(),

                          /// Fetch Posts (Async State)
                          ElevatedButton(
                            onPressed: fetchPosts,
                            child: const Text("Fetch Posts (Async)"),
                          ),
                          const SizedBox(height: 16),
                          CoderConsumer<CoderAsyncState<List<String>>>(
                            state: config.posts.state,
                            builder: (context, asyncState) {
                              if (asyncState.isLoading) {
                                return const CircularProgressIndicator();
                              } else if (asyncState.hasError) {
                                return Text("❌ ${asyncState.error}");
                              } else if (asyncState.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("📬 Posts:"),
                                    ...asyncState.data!.map(
                                      (e) => Text("📄 $e"),
                                    ),
                                  ],
                                );
                              }
                              return const Text("📭 No posts loaded");
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
