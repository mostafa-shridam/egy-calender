import 'dart:developer';

import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/features/dashboard/data/providers/price.dart';
import 'package:calender/features/dashboard/presentation/universal_ai_proccessor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../price/data/models/price_model.dart';
import 'widgets/forms/price_form.dart';
import 'widgets/universal_card.dart';

class PricesView extends ConsumerWidget with AlertMixin {
  const PricesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesAsync = ref.watch(pricesProvider);

    return pricesAsync.when(
      data: (pricesList) {
        return Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: CustomButton(
                    text: 'Add Price',
                    onPressed: () => _showForm(context, ref),
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  width: 200,
                  text: 'Add Prices With AI',
                  onPressed: () {
                    context.pushNamed(
                      UniversalAIProcessor.routeName,
                      extra: {
                        'type': AIType.prices,
                      },
                    );
                  },
                ),
              ],
            ),
            if (dataIsNotEmpty(list: pricesList.data))
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: List.generate(pricesList.data!.length, (index) {
                        final priceData = pricesList.data![index];
                        return UniversalCard(
                          showSelection: false,
                          index: index,
                          price: priceData,
                          isSelected: false,
                          isLoading: false,
                          onSelect: null,
                          onDelete:
                              () => _confirmDelete(
                                context,
                                ref,
                                priceData.id ?? '',
                              ),
                          onUpload: null,
                          onEdit:
                              () => _showForm(context, ref, price: priceData),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // إظهار فورم الإضافة أو التعديل
  void _showForm(BuildContext context, WidgetRef ref, {PriceModel? price}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: PriceForm(
                price: price,
                onSave: (updatedPrice) {
                  if (price == null) {
                    ref.read(pricesProvider.notifier).addPrice(updatedPrice);
                  } else {
                    ref.read(pricesProvider.notifier).updatePrice(updatedPrice);
                  }
                },
              ),
            ),
          ),
    );
  }

  // تنبيه الحذف
  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    log('Confirm delete price with id: $id');
    showDangerAlert(
      context: context,
      title: 'Delete Price Item',
      message: 'Are you sure you want to remove this price record?',
      onConfirm: () {
        ref.read(pricesProvider.notifier).deletePrice(id);
      },
    );
  }
}
