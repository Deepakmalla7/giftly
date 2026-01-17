class HiveTableConstant {
  HiveTableConstant._();

  // Database Name
  static const String dbName = 'giflty_db';

  // ================= USER =================
  static const int userTypeId = 0;
  static const String userTable = 'user_table';

  // ================= EVENT =================
  static const int eventTypeId = 1;
  static const String eventTable = 'event_table';
  // Example: Birthday, Anniversary, Wedding, Valentine, Festival

  // ================= AGE GROUP =================
  static const int ageGroupTypeId = 2;
  static const String ageGroupTable = 'age_group_table';
  // Example: Kids, Teen, Adult, Senior

  // ================= GENDER =================
  static const int genderTypeId = 3;
  static const String genderTable = 'gender_table';
  // Example: Male, Female, Other

  // ================= GIFT ITEM =================
  static const int giftTypeId = 4;
  static const String giftTable = 'gift_table';
  // Example: Watch, Wallet, Flowers, Perfume, Gadgets

  // ================= AI GIFT SUGGESTION =================
  static const int aiSuggestionTypeId = 5;
  static const String aiSuggestionTable = 'ai_suggestion_table';
  // Stores AI-generated gift recommendations

  // ================= FAVORITE GIFTS =================
  static const int favoriteTypeId = 6;
  static const String favoriteTable = 'favorite_table';
  // User saved/favorite gifts

  // ================= SEARCH HISTORY =================
  static const int searchHistoryTypeId = 7;
  static const String searchHistoryTable = 'search_history_table';
  // Stores previous gift searches

  // ================= FEEDBACK / RATING =================
  static const int feedbackTypeId = 8;
  static const String feedbackTable = 'feedback_table';
  // User ratings & feedback for suggestions
}
