import 'dart:developer';

import 'package:calender/core/repositories/price/price_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../features/price/data/models/price_model.dart';
import '../../enums/constants_enums.dart';
import '../../exceptions/firestore_exceptions.dart';

class PriceRepoImpl extends PriceRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _priceCollection =>
      _firestore.collection(Constants.prices.name);

  String get uuId => Uuid().v4();

  @override
  Future<void> addPrice(PriceModel price) async {
    price.id ??= uuId;
    try {
      await _priceCollection.doc(price.id).set(price.toJson());
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<PriceResponse> getPrices() async {
    try {
      
      final querySnapshot = await _priceCollection.get();
      final List<PriceModel> priceList =
          querySnapshot.docs
              .map((doc) => PriceModel.fromJson(doc.data()))
              .toList();
      log('pricess list ${priceList.length}');
      return PriceResponse(data: priceList);
    } catch (e) {
      return PriceResponse(data: []);
    }
  }

  @override
  Future<void> updatePrice(PriceModel price) async {
    await _priceCollection.doc(price.id).update(price.toJson());
  }

  @override
  Future<void> deletePrice(String id) async {
    await _priceCollection.doc(id).delete();
  }
}
