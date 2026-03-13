import 'package:flutter/material.dart';
import '../config/index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// App icon/logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.card_giftcard,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: Constants.paddingLarge),
            Text(
              'Don & Troc',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: Constants.paddingSmall),
            Text(
              'Share, Give, Exchange',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
