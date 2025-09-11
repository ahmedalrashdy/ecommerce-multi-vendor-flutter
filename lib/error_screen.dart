import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.retryButtonText = "Try Again",
  });

  final String error;
  final VoidCallback? onRetry;
  final String retryButtonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Oops!'),
        centerTitle: true,
        backgroundColor: colorScheme
            .errorContainer, // Or colorScheme.error for a stronger indication
        foregroundColor: colorScheme.onErrorContainer, // Or colorScheme.onError
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline_rounded, // A nice, clear error icon
                color: colorScheme.error,
                size: 80.0,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Something Went Wrong',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                error, // The specific error message
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              if (onRetry !=
                  null) // Only show the button if a retry action is provided
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh_rounded, color: colorScheme.onError),
                  label: Text(
                    retryButtonText,
                    style: TextStyle(color: colorScheme.onError),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    textStyle: textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: onRetry,
                ),
              const SizedBox(height: 16.0),
              // Optionally, add a "Go Back" or "Go Home" button
              TextButton(
                onPressed: () {
                  // Navigate back if possible, or to a known safe route like home
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Example: Replace with your home screen route
                    // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    print("Cannot pop, consider navigating to home screen.");
                  }
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
