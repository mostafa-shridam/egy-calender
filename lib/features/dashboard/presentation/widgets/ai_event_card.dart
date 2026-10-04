import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../events/data/models/event_model.dart';

class AIEventCard extends ConsumerWidget {
  final EventModel event;
  final int index;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onSelect;
  final VoidCallback onDelete;
  final VoidCallback onUpload;
  final VoidCallback onEdit;

  const AIEventCard({
    super.key,
    required this.event,
    required this.index,
    required this.isSelected,
    required this.isLoading,
    required this.onSelect,
    required this.onDelete,
    required this.onUpload,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.successGreen : AppColors.accentColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActionButtons(),
            if (dataIsNotEmpty(data: event.image)) _buildImageWithDate(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onSelect,
          icon: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isSelected ? AppColors.successGreen : AppColors.accentColor,
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete, color: AppColors.dangerRed),
        ),
      ],
    );
  }

  Widget _buildImageWithDate(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: CachedImage(imageUrl: event.image ?? ''),
        ),
        Positioned.directional(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              formatDateTime(event.date ?? '', context, format: dateOnlyFormat),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titles (Arabic & English)
          Text(
            event.titleAr ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          Text(
            event.titleEn ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(height: 20),

          // Description (Arabic)
          const Text("الوصف:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(event.descriptionAr ?? '', textDirection: TextDirection.rtl),
          const SizedBox(height: 10),

          // Description (English)
          const Text(
            "Description:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(event.descriptionEn ?? ''),
          const SizedBox(height: 10),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 5),
              Expanded(
                child: Text("${event.locationAr} | ${event.locationEn}"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons (Upload & Edit)
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Upload',
                  isLoading: isLoading,
                  onPressed: () {
                    if (isLoading) return;
                    onUpload();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Edit',
                  grideantColor: AppColors.warningYellow,
                  onPressed: () {
                    if (isLoading) return;
                    onEdit();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
