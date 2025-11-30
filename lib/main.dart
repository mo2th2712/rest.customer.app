import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/app/app_state.dart';
import 'package:restaurant_customer_app/features/auth/presentation/login_screen.dart';
import 'package:restaurant_customer_app/features/branch/data/local_branches_repository.dart';
import 'package:restaurant_customer_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:restaurant_customer_app/features/shell/presentation/shell_screen.dart';
import 'package:restaurant_customer_app/l10n/app_localizations.dart';
import 'package:restaurant_customer_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final initialBranch = LocalBranchesRepository().getBranches().first;
  final appState = AppState(initialBranch: initialBranch);

  runApp(
    AppStateScope(
      state: appState,
      child: const MyRootApp(),
    ),
  );
}

class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Customer App',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        '/onboarding': (context) => OnboardingScreen(
              onFinish: () =>
                  Navigator.of(context).pushReplacementNamed('/login'),
            ),
        '/login': (_) => const LoginScreen(),
        '/shell': (_) => const ShellScreen(),
      },
      initialRoute: '/onboarding',
    );
  }
}
