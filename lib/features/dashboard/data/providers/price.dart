import 'package:calender/features/price/data/models/price_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/repositories/price/price_repo.dart';
import '../../../../core/repositories/price/price_repo_impl.dart';

part 'generated/price.g.dart';

@riverpod
class PricesNotifier extends _$PricesNotifier {
  final PriceRepo _priceRepo = PriceRepoImpl();

  @override
  Future<PriceResponse> build() async {
    try {
      final response = await _priceRepo.getPrices();
      return response;
    } catch (e) {
      return PriceResponse(data: []);
    }
  }

  // إضافة سعر جديد (بيستخدمه الـ AI Processor)
  Future<void> addPrice(PriceModel price) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _priceRepo.addPrice(price);
      final response = await _priceRepo.getPrices();
      return response;
    });
  }

  // تحديث سعر موجود
  Future<void> updatePrice(PriceModel price) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _priceRepo.updatePrice(price);
      final response = await _priceRepo.getPrices();
      return response;
    });
  }

  // حذف سعر
  Future<void> deletePrice(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _priceRepo.deletePrice(id);
      final response = await _priceRepo.getPrices();
      return response;
    });
  }
}
