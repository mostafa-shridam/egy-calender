import 'dart:convert';

import 'package:calender/core/local_services/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../features/news/data/models/news_category.dart';
import '../../../features/news/data/models/news_model.dart';
import '../../enums/constants_enums.dart';
import '../../exceptions/firestore_exceptions.dart';
import 'news_repo.dart';

class NewsRepoImpl implements NewsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _newsCollection =>
      _firestore.collection(Constants.news.name);
  CollectionReference<Map<String, dynamic>> get _newsCategoryCollection =>
      _firestore.collection(Constants.newsCategories.name);
  final LocalStorage _storage = LocalStorage.instance;
  String get uuId => Uuid().v4();
  @override
  Future<NewsResponse> getNews() async {
    try {
      final querySnapshot = await _newsCollection.get();
      final List<NewsModel> newsList =
          querySnapshot.docs
              .map((doc) => NewsModel.fromJson(doc.data()))
              .toList();
      if (newsList.isNotEmpty) {
        _storage.add(
          Constants.news.name,
          jsonEncode(newsList.map((e) => e.toJson()).toList()),
        );
      }
      return NewsResponse(data: newsList);
    } catch (e) {
      return NewsResponse(data: []);
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) async {
    try {
      final doc = await _newsCollection.doc(id).get();
      final news = NewsModel.fromJson(doc.data() ?? {});
      return news;
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> addNews(NewsModel news) async {
    news.id ??= uuId;
    try {
      await _newsCollection.doc(news.id).set(news.toJson());
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> updateNews(NewsModel news) async {
    try {
      await _newsCollection.doc(news.id).update(news.toJson());
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNews(String id) async {
    try {
      await _newsCollection.doc(id).delete();
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<NewsCategoryResponse> getNewsCategories() async {
    try {
      final querySnapshot = await _newsCategoryCollection.get();
      final List<NewsCategoryModel> newsCategoryList =
          querySnapshot.docs
              .map((doc) => NewsCategoryModel.fromJson(doc.data()))
              .toList();
      if (newsCategoryList.isNotEmpty) {
        _storage.add(
          Constants.newsCategories.name,
          jsonEncode(newsCategoryList.map((e) => e.toJson()).toList()),
        );
      }
      return NewsCategoryResponse(data: newsCategoryList);
    } catch (e) {
      return NewsCategoryResponse(data: []);
    }
  }

  @override
  Future<void> addNewsCategory(NewsCategoryModel newsCategory) async {
    newsCategory.id ??= uuId;
    try {
      await _newsCategoryCollection
          .doc(newsCategory.id)
          .set(newsCategory.toJson());
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> updateNewsCategory(NewsCategoryModel newsCategory) async {
    try {
      await _newsCategoryCollection
          .doc(newsCategory.id)
          .update(newsCategory.toJson());
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNewsCategory(String id) async {
    try {
      await _newsCategoryCollection.doc(id).delete();
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }
}
