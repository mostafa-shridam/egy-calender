import '../../../features/news/data/models/news_category.dart';
import '../../../features/news/data/models/news_model.dart';

abstract class NewsRepo {
  // News
  Future<NewsResponse> getNews();
  Future<NewsModel> getNewsById(String id);
  Future<void> addNews(NewsModel news);
  Future<void> updateNews(NewsModel news);
  Future<void> deleteNews(String id);

  // News Category
  Future<NewsCategoryResponse> getNewsCategories();
  Future<void> addNewsCategory(NewsCategoryModel newsCategory);
  Future<void> updateNewsCategory(NewsCategoryModel newsCategory);
  Future<void> deleteNewsCategory(String id);
}
