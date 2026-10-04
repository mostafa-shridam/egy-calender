import 'dart:convert';

import 'package:calender/core/repositories/news/news_repo.dart';
import 'package:calender/core/repositories/news/news_repo_impl.dart';
import 'package:calender/features/news/data/models/news_category.dart';
import 'package:calender/features/news/data/models/news_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
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
    state = await AsyncValue.guard(() => _remoteNews());
  }

  Future<NewsStates> _remoteNews() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final news = await _newsRepo.getNews();
      final categories = await _newsRepo.getNewsCategories();
      return NewsStates(news: news, categories: categories);
    });
    return state.value ?? NewsStates();
  }

  Future<NewsStates> _localNews() async {
    final localNews = await _storage.get(Constants.news.name);
    final localCategories = await _storage.get(Constants.newsCategories.name);
    if (localNews != null && localCategories != null) {
      final newsList =
          (jsonDecode(localNews) as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
      final categoriesList =
          (jsonDecode(localCategories) as List)
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

  Future<void> addNews(NewsModel news) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _newsRepo.addNews(news);
      return _remoteNews();
    });
  }

  Future<void> updateNews(NewsModel news) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _newsRepo.updateNews(news);
      return _remoteNews();
    });
  }

  Future<void> deleteNews(String id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() {
      _newsRepo.deleteNews(id);
      return _remoteNews();
    });
  }

  Future<void> addNewsCategory(NewsCategoryModel category) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() {
      _newsRepo.addNewsCategory(category);
      return _remoteNews();
    });
  }

  Future<void> updateNewsCategory(NewsCategoryModel category) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _newsRepo.updateNewsCategory(category);
      return _remoteNews();
    });
  }

  Future<void> deleteNewsCategory(String id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() {
      _newsRepo.deleteNewsCategory(id);
      return _remoteNews();
    });
  }

  void filterNews(String id) {
    state = state.whenData((s) => s.copyWith(selectedCategoryId: id));
  }
}

class NewsStates {
  final NewsResponse? news;
  final NewsCategoryResponse? categories;
  final bool? isLoading;
  final String selectedCategoryId;
  final bool? hasError;

  NewsStates({
    this.news,
    this.categories,
    this.isLoading,
    this.selectedCategoryId = '0',
    this.hasError,
  });

  List<NewsModel>? get filteredNews {
    if (selectedCategoryId == '0') {
      return news?.data;
    } else {
      return news?.data
          ?.where((element) => element.categoryId == selectedCategoryId)
          .toSet()
          .toList();
    }
  }

  List<NewsCategoryModel> get getAllCategories {
    final List<NewsCategoryModel> allCategories = [
      NewsCategoryModel(id: '0', nameAr: 'الكل', nameEn: 'All'),
      ...categories?.data ?? [],
    ];
    return allCategories;
  }

  NewsStates copyWith({
    NewsResponse? news,
    NewsCategoryResponse? categories,
    bool? isLoading,
    String? selectedCategoryId,
    bool? hasError,
  }) {
    return NewsStates(
      news: news ?? this.news,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      hasError: hasError ?? this.hasError,
    );
  }
}
