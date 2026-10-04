// Copy this file to `lib/core/config/secrets.dart` (that file is gitignored).
// Use the Supabase **anon / publishable** key only. Never put the service_role key in the app.

class Secrets {
  static const String baseUrl = 'https://YOUR_API_HOST/api';

  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
