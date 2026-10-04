import 'package:calender/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/helper/icon_helper.dart';
import '../../../core/widgets/color_selection.dart';
import '../../../core/widgets/my_text_filed.dart';
import '../../../generated/locale_keys.g.dart';
import '../../my_events/data/models/my_category.dart';
import '../../my_events/data/providers/my_events.dart';

class AddEditCategoryPage extends ConsumerStatefulWidget {
  const AddEditCategoryPage({super.key, this.category});
  final MyCategory? category;
  static const routeName = '/add_edit_category';

  @override
  ConsumerState<AddEditCategoryPage> createState() =>
      _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends ConsumerState<AddEditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final ValueNotifier<Color> _selectedColorNotifier;
  late final ValueNotifier<IconData> _selectedIconNotifier;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _selectedColorNotifier = ValueNotifier(
      Color(widget.category?.color ?? AppColors.primaryColor.toARGB32()),
    );
    _selectedIconNotifier = ValueNotifier(
      IconHelper.getIcon(widget.category?.icon),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selectedColorNotifier.dispose();
    _selectedIconNotifier.dispose();
    super.dispose();
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = MyCategory(
        id: widget.category?.id,
        name: _nameController.text,
        color: _selectedColorNotifier.value.toARGB32(),
        icon: IconHelper.getIconName(_selectedIconNotifier.value),
        createdAt:
            widget.category?.createdAt ?? DateTime.now().toIso8601String(),
      );
      if (widget.category != null) {
        await ref.read(myEventsProvider.notifier).updateCategory(category);
      } else {
        await ref.read(myEventsProvider.notifier).addCategory(category);
      }
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add_category.tr()),
        actions: [
          TextButton(
            onPressed: _saveCategory,
            child: Text(LocaleKeys.save.tr()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Name Input
              Text(
                LocaleKeys.category_name.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              MyTextField(
                controller: _nameController,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.category_name_required.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Color Selection using ValueListenableBuilder
              Text(
                LocaleKeys.pick_a_color.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<Color>(
                valueListenable: _selectedColorNotifier,
                builder: (context, selectedColor, child) {
                  return ColorSelectionWidget(
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      _selectedColorNotifier.value = color;
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Icon Selection using ValueListenableBuilder
              Text('Icon', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ValueListenableBuilder<Color>(
                valueListenable: _selectedColorNotifier,
                builder: (context, selectedColor, _) {
                  return ValueListenableBuilder<IconData>(
                    valueListenable: _selectedIconNotifier,
                    builder: (context, selectedIcon, child) {
                      return _IconSelectionWidget(
                        availableIcons: IconHelper.getAllIcons(),
                        selectedIcon: selectedIcon,
                        selectedColor: selectedColor,
                        onIconSelected: (icon) {
                          _selectedIconNotifier.value = icon;
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconSelectionWidget extends StatelessWidget {
  final List<IconData> availableIcons;
  final IconData selectedIcon;
  final Color selectedColor;
  final ValueChanged<IconData> onIconSelected;

  const _IconSelectionWidget({
    required this.availableIcons,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: availableIcons.length,
      itemBuilder: (context, index) {
        final icon = availableIcons[index];
        final isSelected = selectedIcon == icon;
        return InkWell(
          onTap: () => onIconSelected(icon),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? selectedColor.withValues(alpha: 0.1)
                      : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border:
                  isSelected
                      ? Border.all(color: selectedColor, width: 2)
                      : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: isSelected ? selectedColor : Colors.grey),
          ),
        );
      },
    );
  }
}
