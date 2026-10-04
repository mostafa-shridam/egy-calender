import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key, required this.child, required this.isLoading});

  final Widget child;
  final bool isLoading;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool _dialogShown = false;

  @override
  void didUpdateWidget(covariant AppLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When loading starts
    if (widget.isLoading && !_dialogShown) {
      _dialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      });
    }

    // When loading stops
    if (!widget.isLoading && _dialogShown) {
      _dialogShown = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) {
          context.pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
