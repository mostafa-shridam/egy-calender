import 'dart:convert';
import 'dart:developer';
import 'package:calender/core/enums/constants_enums.dart';
import 'package:calender/features/events/data/models/event_model.dart';
import 'package:calender/features/news/data/models/news_model.dart';
import 'package:calender/features/price/data/models/price_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._();
  GeminiService._();
  static GeminiService get instance => _instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _gemini = Gemini.instance;

  Future<void> _init() async {
    String apiKey = '';
    await firestore.collection(Constants.gemini.name).get().then((value) {
      apiKey = value.docs.map((e) => e.data()['apiKey']).first;
    });
    Gemini.init(apiKey: apiKey);
  }

  Future<List<EventModel>> generateMultipleEvents(
    String category,
    String catId,
    String section,
    String secId,
    String items,
  ) async {
    String currentIsoDate = DateTime.now().toIso8601String();
    String finalPrompt = """
You are a professional data researcher specialized in OFFICIALLY ANNOUNCED Egyptian events and tourism.

Your task is to generate VERIFIED, PUBLICLY ANNOUNCED future events in Egypt only.

Current date: ${currentIsoDate.toString()}
Number of requested events: $items

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CRITICAL DATA INTEGRITY RULES (STRICT – NO EXCEPTIONS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1️⃣ LOCATION RULE
- Every event MUST take place physically inside Egypt.
- Allowed cities include (but are not limited to):
  Cairo, Giza, Alexandria, New Alamein, Sharm El Sheikh, Hurghada, Luxor, Aswan.
- If the location is not clearly inside Egypt → SKIP the event.

2️⃣ DATE VALIDATION RULE
- All events MUST have a future date AFTER January 7, 2026.
- Date format MUST be exactly:
  YYYY-MM-DDTHH:MM:SS.SSS
- If the event date is tentative, unconfirmed, seasonal, or estimated → SKIP.

3️⃣ OFFICIAL CONFIRMATION RULE (MOST IMPORTANT)
- ONLY generate events that are:
  • Officially announced
  • Recurrent well-known annual events (festivals, exhibitions, conferences)
  • Or events hosted by official entities (Ministry, Expo centers, major venues)
- If you are NOT 100% certain the event is real and officially scheduled → DO NOT GENERATE IT.
- NEVER invent events, names, dates, or locations.

4️⃣ IMAGE VALIDATION RULE
- Provide an image URL ONLY if:
  • It is clearly relevant to the event type
  • It is high-quality and commonly used (official venue, festival, or expo image)
- If unsure about the image authenticity or URL validity:
  → Set "image": null
  → Do NOT guess or fabricate URLs.

5️⃣ NO EMPTY OR WEAK CONTENT
- All text fields must be:
  • Professional
  • Informative
  • Realistic
  • Suitable for a public events application
- No generic filler descriptions.

6️⃣ LANGUAGE RULE
- Arabic (Egyptian Modern Standard) + English are REQUIRED.
- Arabic must be natural and culturally appropriate.
- English must be professional and tourism-friendly.

7️⃣ ACCURACY OVER QUANTITY
- If fewer than $items VERIFIED events exist → return fewer items.
- Quality and correctness are more important than count.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DYNAMIC CONTEXT (DO NOT CHANGE)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Category: $category (ID: $catId)
Section: $section (ID: $secId)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT (STRICT)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Return ONLY a valid JSON ARRAY.
- NO explanations.
- NO comments.
- NO markdown.
- NO extra text.

Each object MUST follow this EXACT structure and KEYS:

{
  "id": "unique-string-id",
  "categoryId": $catId,
  "sectionId": $secId,
  "title_Ar": "اسم الحدث الرسمي بالعربي",
  "title_En": "Official event name in English",
  "description_Ar": "وصف رسمي وجذاب للفعالية كما هو متداول أو معلن",
  "description_En": "Official and attractive description based on public announcements",
  "location_Ar": "العنوان التفصيلي داخل مصر",
  "location_En": "Detailed address inside Egypt",
  "image": "direct verified image URL OR null",
  "date": "2026-05-15T19:00:00.000",
  "createdAt": "$currentIsoDate",
  "UpdatedAt": "$currentIsoDate"
}
""";

    try {
      await _init();
      log('Start Gemini', name: 'GeminiService');
      final response = await _gemini.prompt(
        parts: [Part.text(finalPrompt)],
        model: 'gemini-2.5-flash',
      );
      String rawJson = response?.output ?? "[]";

      rawJson = rawJson.replaceAll('```json', '').replaceAll('```', '').trim();
      final convertedJson = jsonDecode(rawJson) as List<dynamic>;
      final events = convertedJson.map((e) => EventModel.fromJson(e)).toList();
      log('End Gemini', name: 'GeminiService', error: events);
      return events;
    } catch (e) {
      log('Error Gemini $e', name: 'GeminiService', error: e);
      return [];
    }
  }

  Future<List<NewsModel>> generateMultipleNews(
    String category,
    String catId,
    String items,
  ) async {
    String currentIsoDate = DateTime.now().toIso8601String();
    String finalPrompt = """
You are a professional News Researcher and Journalist specialized in Egyptian Current Affairs, Economics, and Industry.

Your task is to generate VERIFIED, FACTUAL, and RECENT news articles related specifically to Egypt.

Current date: ${currentIsoDate.toString()}
Number of requested news items: $items

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CRITICAL DATA INTEGRITY RULES (STRICT – NO EXCEPTIONS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1️⃣ SOURCE & AUTHENTICITY RULE
- Every news item MUST be based on real-world events or official announcements in Egypt.
- Sources must be reputable (e.g., State Information Service, Central Bank of Egypt, official ministries, or major verified news agencies).
- Provide the "sourceName" and "sourceLogo" ONLY if they are globally or locally recognized.
- If the news is a rumor, unverified, or speculative → SKIP.

2️⃣ DATE VALIDATION RULE
- "publishedAt" MUST be the actual or estimated date of the news announcement.
- Date format MUST be exactly: YYYY-MM-DDTHH:MM:SS.SSS
- News must be relevant to the current period (2025-2026).

3️⃣ CONTENT QUALITY RULE
- "contentAr" and "contentEn" must be the FULL detailed article, not just a summary.
- "descriptionAr" and "descriptionEn" should be a concise, catchy "lead" paragraph (Snippet).
- NO generic or AI-hallucinated filler text. All data must be professional and journalistic.

4️⃣ IMAGE & LOGO VALIDATION
- "imageUrl": Provide a direct link to a high-quality, relevant image for the news.
- "sourceLogo": Provide a direct link to the official logo of the news source (e.g., Al-Ahram, Egypt Today, etc.).
- If unsure about the URL validity → Set the field to: null.

5️⃣ LANGUAGE & LOCALIZATION
- Full support for Arabic (Modern Standard) and English is MANDATORY.
- Arabic must be grammatically perfect and follow professional Egyptian journalistic standards.
- English must be professional and formal.

6️⃣ NULLABILITY RULE
- If any piece of information is missing or unverified (like the author or a specific news URL), set it to: null.
- Do NOT fabricate IDs; generate a unique UUID-style string for "id".

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DYNAMIC CONTEXT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Category: $category (ID: $catId)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT (STRICT JSON)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Return ONLY a valid JSON ARRAY.
- NO markdown code blocks (no ```json).
- NO conversational text or explanations.
- ESCAPE all double quotes inside text fields using backslashes (e.g., "News").
- DO NOT use Newlines (\n) inside JSON strings; use a single space instead.
- ENSURE the JSON is perfectly minified or properly formatted to avoid truncated output.
- If the content is too long, prioritize clarity and stop before exceeding the token limit to ensure the JSON remains valid and closed (]).
Each object MUST follow this EXACT structure (matching the NewsModel):

{
  "id": "unique-uuid-string",
  "title_ar": "عنوان الخبر باللغة العربية",
  "description_ar": "وصف مختصر وجذاب للخبر بالعربي",
  "content_ar": "المحتوى الكامل والتفصيلي للخبر باللغة العربية",
  "source_name_ar": "اسم المصدر بالعربي (مثل: وزارة التجارة والصناعة)",
  "title_en": "Official news headline in English",
  "description_en": "A concise and engaging summary in English",
  "content_en": "The full detailed content of the news article in English",
  "source_name_en": "Official source name in English (e.g., Ministry of Trade and Industry)",
  "image_url": "verified_image_url_or_null",
  "source_logo": "verified_source_logo_url_or_null",
  "author": "Author Name or null",
  "category": "$category",
  "published_at": "2026-01-08T10:30:00.000",
  "news_url": "original_source_link_or_null"
}
""";

    try {
      await _init();
      log('Start Gemini News', name: 'GeminiService');
      final response = await _gemini.prompt(
        parts: [Part.text(finalPrompt)],
        model: 'gemini-2.5-flash',
      );
      String rawJson = response?.output ?? "[]";

      rawJson = rawJson.replaceAll('```json', '').replaceAll('```', '').trim();
      final convertedJson = jsonDecode(rawJson) as List<dynamic>;
      final news = convertedJson.map((e) => NewsModel.fromJson(e)).toList();
      log('End Gemini', name: 'GeminiService', error: news);
      return news;
    } catch (e) {
      log('Error Gemini $e', name: 'GeminiService', error: e);
      return [];
    }
  }

  Future<List<PriceModel>> generateMultiplePrices(String items) async {
    String currentIsoDate = DateTime.now().toIso8601String();
    String finalPrompt = """
You are a Senior Economic Researcher and Financial Analyst specializing in the Egyptian Market and Commodities Exchange.

Your task is to generate VERIFIED, REAL-TIME, and ACCURATE price data for essential Egyptian commodities (Gold, Steel, Cement, Currency, and Strategic Food Commodities).

Current date: $currentIsoDate
Number of items: $items

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CRITICAL DATA INTEGRITY RULES (STRICT – NO EXCEPTIONS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1️⃣ DATA SOURCE & AUTHENTICITY
- Data MUST be based on real-time market prices in Egypt (e.g., Central Bank of Egypt, Federation of Egyptian Chambers of Commerce, Cairo Gold Division, or official commodity exchanges).
- "sourceName" must reflect the actual entity providing the price.
- Provide "sourceLogo" ONLY if it is a verified official logo. If unsure, set to null.

2️⃣ NUMERIC PRECISION & LOGIC
- "current_price": Must be the latest official trading price.
- "old_price": Must be the previous recorded price to show historical context.
- "change_percentage": MUST be mathematically correct: ((current - old) / old) * 100.
- "change_status": MUST be logically consistent:
    - 'up' if current_price > old_price.
    - 'down' if current_price < old_price.
    - 'stable' if current_price == old_price.

3️⃣ DATE & UPDATE VALIDATION
- "last_update" MUST reflect the most recent market update (Today or the last trading session).
- Use a clear, human-readable format for the user (e.g., "2026-01-10 10:00 AM").

4️⃣ CONTENT QUALITY (LOCALIZATION)
- Title/Description: Must be professional, financial, and concise.
- Arabic (Modern Standard): Must use Egyptian financial terminology (e.g., "عيار 21", "سعر المصنع").
- English: Formal financial English.

5️⃣ IMAGE VALIDATION
- "image_url": A direct link to a high-quality, professional image representing the commodity (e.g., gold bars, construction steel).
- If no valid URL is found, set to: null.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OUTPUT FORMAT (STRICT JSON)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- Return ONLY a valid JSON ARRAY.
- NO markdown code blocks, NO conversational text.
- DO NOT use Newlines (\n) inside JSON strings; use a single space instead.
- Generate a unique UUID-style string for "id".

Each object MUST follow this EXACT structure (matching the PriceModel):

{
  "id": "unique-uuid-string",
  "title_ar": "اسم السلعة بالعربي (مثلاً: الذهب عيار 21)",
  "description_ar": "تفاصيل مختصرة عن حالة السوق (مثلاً: استقرار في الأسعار بعد تراجع عالمي)",
  "source_name_ar": "المصدر بالعربي (مثل: شعبة الذهب والمجوهرات)",
  "title_en": "Commodity name in English (e.g., Gold 21K)",
  "description_en": "Brief market status (e.g., Prices stabilized after a global decline)",
  "source_name_en": "Official source name in English (e.g., Gold Division - FEDCOC)",
  "current_price": 3550.0,
  "old_price": 3600.0,
  "image_url": "verified_image_url_or_null",
  "source_logo": "verified_source_logo_url_or_null",
  "last_update": "2026-01-08T10:30:00.000",
  "change_status": "down",
  "change_percentage": 1.38
}
""";

    try {
      await _init();
      log('Start Gemini prices', name: 'GeminiService');
      final response = await _gemini.prompt(
        parts: [Part.text(finalPrompt)],
        model: 'gemini-2.5-flash',
      );
      String rawJson = response?.output ?? "[]";

      rawJson = rawJson.replaceAll('```json', '').replaceAll('```', '').trim();
      final convertedJson = jsonDecode(rawJson) as List<dynamic>;
      final prices = convertedJson.map((e) => PriceModel.fromJson(e)).toList();
      log('End Gemini', name: 'GeminiService', error: prices);
      return prices;
    } catch (e) {
      log('Error Gemini $e', name: 'GeminiService', error: e);
      return [];
    }
  }
}
