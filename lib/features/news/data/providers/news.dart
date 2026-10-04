import 'dart:convert';
import 'dart:developer';

import 'package:calender/core/repositories/news/news_repo.dart';
import 'package:calender/core/repositories/news/news_repo_impl.dart';
import 'package:calender/features/news/data/models/news_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../../../core/network/network_service.dart';
import '../models/news_category.dart';
part 'generated/news.g.dart';

@riverpod
class NewsNotifier extends _$NewsNotifier {
  late NewsRepo _newsRepo;
  late LocalStorage _storage;
  @override
  FutureOr<NewsStates> build() async {
    _newsRepo = NewsRepoImpl();
    _storage = LocalStorage.instance;
    return await _localNews();
  }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _remoteNews());
  }

  Future<NewsStates> _remoteNews() async {
    state = AsyncValue.loading();
    final isOnline =
        await NetworkService.instance.checkStatus() == NetworkStatus.online;

    if (!isOnline) {
      log('☁️ Offline: Skipping remote price fetch');
      return state.value ?? NewsStates();
    }
    state = await AsyncValue.guard(() async {
      final news = await _newsRepo.getNews();
      final categories = await _newsRepo.getNewsCategories();
      return NewsStates(news: news, categories: categories);
    });
    return state.value ?? NewsStates();
  }

  Future<NewsStates> _localNews() async {
    final localNews = await _storage.get(Constants.news.name);
    final localNewsCategories = await _storage.get(
      Constants.newsCategories.name,
    );
    if (localNews != null && localNewsCategories != null) {
      final newsList =
          (jsonDecode(localNews) as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
      final categoriesList =
          (jsonDecode(localNewsCategories) as List)
              .map((e) => NewsCategoryModel.fromJson(e))
              .toList();
      return NewsStates(
        news: NewsResponse(data: newsList),
        categories: NewsCategoryResponse(data: categoriesList),
      );
    } else {
      return await _remoteNews();
    }
  }

  void filterByCategory(String? id) {
    state = state.whenData((value) => value.copyWith(selectedCategoryId: id));
  }
}

class NewsStates {
  final NewsResponse? news;
  final NewsCategoryResponse? categories;
  final String selectedCategoryId;
  final String? hasError;
  NewsStates({
    this.news,
    this.categories,
    this.hasError,
    this.selectedCategoryId = '0',
  });

  List<NewsModel>? get filterNews {
    if (selectedCategoryId == '0') {
      return news?.data;
    }

    return news?.data
        ?.where((element) => element.categoryId == selectedCategoryId)
        .toList();
  }

  List<NewsCategoryModel>? get getAllCategories {
    final List<NewsCategoryModel> allCategories = [
      NewsCategoryModel(nameAr: 'الكل', nameEn: 'All', id: '0'),
      ...categories?.data ?? [],
    ];
    return allCategories;
  }

  NewsStates copyWith({
    NewsResponse? news,
    NewsCategoryResponse? categories,
    String? hasError,
    String? selectedCategoryId,
  }) {
    return NewsStates(
      news: news ?? this.news,
      categories: categories ?? this.categories,
      hasError: hasError ?? this.hasError,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}
