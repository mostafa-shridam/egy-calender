import 'package:flutter/material.dart';

/// Widget for displaying priority badge with color coding
/// 0 = Low (green), 1 = Medium (orange), 2 = High (red)
/// Defaults to Low if priority is null
/// Includes subtle scale animation on appear
class PriorityBadge extends StatefulWidget {
  const PriorityBadge({
    super.key,
    this.priority,
    this.animationDelay = Duration.zero,
  });

  final int? priority;
  final Duration animationDelay;

  @override
  State<PriorityBadge> createState() => _PriorityBadgeState();
}

class _PriorityBadgeState extends State<PriorityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Start animation after delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get priority label based on priority value
  String get _priorityLabel {
    switch (widget.priority ?? 0) {
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Low';
    }
  }

  /// Get priority color based on priority value
  /// Uses theme-aware colors for dark/light mode compatibility
  Color _getPriorityColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (widget.priority ?? 0) {
      case 1:
        // Medium - Orange
        return isDark ? Colors.orange.shade300 : Colors.orange.shade700;
      case 2:
        // High - Red
        return isDark ? Colors.red.shade300 : Colors.red.shade700;
      default:
        // Low - Green
        return isDark ? Colors.green.shade300 : Colors.green.shade700;
    }
  }

  /// Get background color for badge
  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (widget.priority ?? 0) {
      case 1:
        return isDark
            ? Colors.orange.shade900.withValues(alpha: 0.3)
            : Colors.orange.shade50;
      case 2:
        return isDark
            ? Colors.red.shade900.withValues(alpha: 0.3)
            : Colors.red.shade50;
      default:
        return isDark
            ? Colors.green.shade900.withValues(alpha: 0.3)
            : Colors.green.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getPriorityColor(context).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag_rounded,
              size: 16,
              color: _getPriorityColor(context),
            ),
            const SizedBox(width: 6),
            Text(
              _priorityLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _getPriorityColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
