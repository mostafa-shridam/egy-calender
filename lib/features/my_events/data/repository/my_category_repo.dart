import '../models/my_category.dart';

abstract class MyCategoryRepo {
  Future<List<MyCategory>> getCategories();
  Future<void> addCategory(MyCategory category);
  Future<void> updateCategory(MyCategory category);
  Future<void> deleteCategory(String categoryId);
  Future<void> migrateGuestData();
}
