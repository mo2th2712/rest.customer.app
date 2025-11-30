import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.fastfood_rounded, size: 120, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              isAr ? 'مرحباً بك!' : 'Welcome!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              isAr ? 'أفضل تجربة طلب طعام' : 'The best food ordering experience',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: onFinish,
                  child: Text(
                    isAr ? 'ابدأ الآن' : 'Get Started',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
