import 'package:calender/features/price/data/models/price_model.dart';

abstract class PriceRepo {
  Future<PriceResponse> getPrices();
  Future<void> addPrice(PriceModel model);
  Future<void> updatePrice(PriceModel model);
  Future<void> deletePrice(String id);
}
