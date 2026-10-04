import 'dart:convert';
import 'dart:developer';

import 'package:calender/core/enums/constants_enums.dart';
import 'package:calender/core/local_services/local_storage.dart';
import 'package:calender/features/price/data/models/price_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/repositories/price/price_repo.dart';
import '../../../../core/repositories/price/price_repo_impl.dart';

part 'generated/price.g.dart';

@riverpod
class PricesNotifier extends _$PricesNotifier {
  final PriceRepo _priceRepo = PriceRepoImpl();
  late LocalStorage _storage;

  @override
  Future<PriceResponse> build() async {
    _storage = LocalStorage.instance;
    return await _getFromLocal();
  }

  Future<PriceResponse> getPriceRemote() async {
    state = const AsyncValue.loading();
    final isOnline =
        await NetworkService.instance.checkStatus() == NetworkStatus.online;

    if (!isOnline) {
      log('☁️ Offline: Skipping remote price fetch');
      return state.value ?? PriceResponse(data: []);
    }
    state = await AsyncValue.guard(() async {
      final response = await _priceRepo.getPrices();

      if (response.data != null) {
        await _storage.add(
          Constants.prices.name,
          jsonEncode(response.data?.map((e) => e.toJson()).toSet().toList()),
        );
      }
      return response;
    });

    return state.value ?? PriceResponse(data: []);
  }

  Future<PriceResponse> _getFromLocal() async {
    final String? priceList = await _storage.get(Constants.prices.name) ?? '';

    if (priceList != null && priceList.isNotEmpty) {
      try {
        log('Parsing local prices');
        final prices =
            (jsonDecode(priceList) as List)
                .map((e) => PriceModel.fromJson(e))
                .toList();
        return PriceResponse(data: prices);
      } catch (e) {
        log('Error parsing local prices: $e');
        return await getPriceRemote();
      }
    } else {
      return await getPriceRemote();
    }
  }
}
