import 'package:calender/features/dashboard/presentation/widgets/forms/price_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:collection/collection.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/my_text_filed.dart';
import '../../events/data/models/event_model.dart';
import '../../news/data/models/news_model.dart';
import '../../price/data/models/price_model.dart';
import '../data/providers/events.dart';
import '../data/providers/news.dart';
import '../data/providers/price.dart';
import 'widgets/universal_card.dart';
import 'widgets/dashboard_dropdown.dart';
import 'widgets/forms/event_form.dart';
import 'widgets/forms/news_form.dart';

enum AIType { news, prices, events }

class UniversalAIProcessor extends ConsumerStatefulWidget {
  static const String routeName = '/universal-ai-processor';
  final AIType type;
  final List<dynamic>? categories;
  final List<dynamic>? sections;
  const UniversalAIProcessor({
    super.key,
    required this.type,
    this.categories,
    this.sections,
  });

  @override
  ConsumerState<UniversalAIProcessor> createState() =>
      _UniversalAIProcessorState();
}

class _UniversalAIProcessorState extends ConsumerState<UniversalAIProcessor> {
  final TextEditingController _itemsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _categoryId;
  String? _sectionId;
  List<dynamic> _items = [];
  final List<dynamic> _selectedItems = [];
  bool _isLoading = false;
  final Set<String> _processingIds = {};

  Future<void> _generateData(
    String items, {
    String? section,
    String? secId,
    String? category,
    String? catId,
  }) async {
    setState(() => _isLoading = true);
    try {
      if (widget.type == AIType.events) {
        _items = await GeminiService.instance.generateMultipleEvents(
          category ?? '',
          catId ?? '',
          section ?? '',
          secId ?? '',
          items,
        );
      } else if (widget.type == AIType.news) {
        _items = await GeminiService.instance.generateMultipleNews(
          category ?? '',
          catId ?? '',
          items,
        );
      } else {
        _items = await GeminiService.instance.generateMultiplePrices(items);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _uploadItem(dynamic item) async {
    if (widget.type == AIType.news) {
      await ref.read(newsProvider.notifier).addNews(item);
    } else if (widget.type == AIType.events) {
      await ref.read(eventsProvider.notifier).addEvent(item);
    } else if (widget.type == AIType.prices) {
      await ref.read(pricesProvider.notifier).addPrice(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = widget.categories?.firstWhereOrNull(
      (e) => e.id == _categoryId,
    );

    final filteredSections =
        widget.sections?.where((section) {
          return section.categoryId == _categoryId;
        }).toList() ??
        [];

    final selectedSection = filteredSections.firstWhereOrNull(
      (e) => e.id == _sectionId,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('AI ${widget.type.name.toUpperCase()} Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTopBar(
              selectedCategory,
              selectedSection,
              widget.categories ?? [],
              filteredSections,
            ),
            const Divider(height: 32),
            if (_items.isNotEmpty) _buildToolbar(),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    dynamic selectedCategory,
    dynamic selectedSection,
    List categories,
    List? sections,
  ) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 8,
              children: [
                if (categories.isNotEmpty)
                  DashboardDropdown(
                    value: selectedCategory?.name(context),
                    items:
                        categories
                            .map((e) => e.name(context))
                            .whereType<String>()
                            .toList(),
                    onChanged: (name) {
                      final cat = categories.firstWhereOrNull(
                        (e) => e.name(context) == name,
                      );
                      setState(() => _categoryId = cat?.id);
                    },
                  ),
                if (widget.sections != null &&
                    widget.type == AIType.events &&
                    sections != null &&
                    sections.isNotEmpty)
                  DashboardDropdown(
                    value: selectedSection?.title(context),
                    items:
                        sections
                            .map((e) => e.title(context))
                            .whereType<String>()
                            .toList(),
                    onChanged: (name) {
                      final sec = sections.firstWhereOrNull(
                        (e) => e.title(context) == name,
                      );
                      setState(() => _sectionId = sec?.id);
                    },
                  ),
                MyTextField(
                  controller: _itemsController,
                  labelText: 'Number of Items',
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter number of items'
                              : null,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CustomButton(
            width: 200,
            height: 110,
            text: _isLoading ? 'Generating...' : 'Start AI',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final itemCount = int.tryParse(_itemsController.text) ?? 0;
                if (itemCount > 0) {
                  _generateData(
                    _itemsController.text,
                    category: selectedCategory?.nameEn ?? '',
                    catId: _categoryId ?? '',
                    section:
                        widget.type == AIType.events
                            ? selectedSection?.titleEn ?? ''
                            : null,
                    secId:
                        widget.type == AIType.events ? _sectionId ?? '' : null,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) {
      return const Center(child: Text("No items generated yet."));
    }

    return SingleChildScrollView(
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(
          _items.length,
          (index) => _buildCardForItem(_items[index], index),
        ),
      ),
    );
  }

  Widget _buildCardForItem(dynamic item, int index) {
    final isLoading = _processingIds.contains(item.id);
    final isSelected = _selectedItems.any((e) => e.id == item.id);

    void onSelect() {
      setState(() {
        if (isSelected) {
          _selectedItems.removeWhere((e) => e.id == item.id);
        } else {
          _selectedItems.add(item);
        }
      });
    }

    void onDelete() {
      setState(() {
        _items.removeAt(index);
        _selectedItems.removeWhere((e) => e.id == item.id);
      });
    }

    void onUpload() {
      if (isLoading) return;
      setState(() => _processingIds.add(item.id));
      _uploadItem(item)
          .then((_) {
            setState(() {
              _items.remove(item);
              _selectedItems.removeWhere((e) => e.id == item.id);
            });
          })
          .catchError((e) {
            debugPrint('Upload error: $e');
          })
          .whenComplete(() {
            setState(() => _processingIds.remove(item.id));
          });
    }

    void onEdit() {
      if (isLoading) return;
      _openEditForm(item, index);
    }

    return UniversalCard(
      index: index,
      isSelected: isSelected,
      isLoading: isLoading,
      onSelect: onSelect,
      onDelete: onDelete,
      onUpload: onUpload,
      onEdit: onEdit,
      price: widget.type == AIType.prices ? item as PriceModel : null,
      news: widget.type == AIType.news ? item as NewsModel : null,
      event: widget.type == AIType.events ? item as EventModel : null,
    );
  }

  void _openEditForm(dynamic item, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 500,
              child:
                  widget.type == AIType.news
                      ? NewsForm(
                        news: item,
                        onSave:
                            (updated) =>
                                setState(() => _items[index] = updated),
                      )
                      : widget.type == AIType.prices
                      ? PriceForm(
                        price: item,
                        onSave: (updated) {
                          setState(() => _items[index] = updated);
                        },
                      )
                      : EventForm(
                        event: item,
                        onSave:
                            (updated) =>
                                setState(() => _items[index] = updated),
                      ),
            ),
          ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        Text("Total: ${_items.length} | Selected: ${_selectedItems.length}"),
        const Spacer(),
        TextButton(
          onPressed:
              () => setState(
                () =>
                    _selectedItems.isEmpty
                        ? _selectedItems.addAll(_items)
                        : _selectedItems.clear(),
              ),
          child: Text(_selectedItems.isEmpty ? "Select All" : "Deselect All"),
        ),
        if (_selectedItems.isNotEmpty)
          CustomButton(
            width: 220,
            text: "Upload Selected (${_selectedItems.length})",
            onPressed: () {
              final itemsToUpload = List.from(_selectedItems);
              _uploadItemsSequentially(itemsToUpload);
            },
          ),
      ],
    );
  }

  void _uploadItemsSequentially(List<dynamic> itemsToUpload) {
    if (itemsToUpload.isEmpty) return;

    Future<void> currentUpload = Future.value();

    for (var item in itemsToUpload) {
      currentUpload = currentUpload.then((_) {
        setState(() => _processingIds.add(item.id));
        return _uploadItem(item)
            .then((_) {
              setState(() {
                _items.removeWhere((e) => e.id == item.id);
                _selectedItems.removeWhere((e) => e.id == item.id);
              });
            })
            .catchError((e) {
              debugPrint('Upload error for ${item.id}: $e');
            })
            .whenComplete(() {
              setState(() => _processingIds.remove(item.id));
            });
      });
    }
  }
}
