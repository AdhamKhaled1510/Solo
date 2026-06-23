class AppStrings {
  static const appName = 'دراستي';
  static const appNameEn = 'MyStudy';

  // Navigation
  static const home = 'الرئيسية';
  static const tasks = 'المهام';
  static const habits = 'العادات';
  static const timer = 'المؤقت';
  static const garden = 'الحديقة';
  static const quests = 'المهام';
  static const shop = 'المتجر';
  static const stats = 'الإحصائيات';
  static const settings = 'الإعدادات';
  static const studyRooms = 'غرف المذاكرة';

  // Timer
  static const focus = 'تركيز';
  static const break_ = 'راحة';
  static const start = 'ابدأ';
  static const pause = 'إيقاف';
  static const resume = 'استمرار';
  static const cancel = 'إلغاء';
  static const plantTree = 'ازرع شجرة!';
  static const treeDied = 'الشجرة ماتت 💔';
  static const focusComplete = 'أحسنت! 🌳';

  // Garden
  static const myGarden = 'حديقتي';
  static const trees = 'أشجار';
  static const noTrees = 'لا يوجد أشجار بعد، ابدأ جلسة تركيز!';
  static const totalTrees = 'إجمالي الأشجار';

  // XP & Levels
  static const level = 'المستوى';
  static const xp = 'XP';
  static const coins = 'عملات';
  static const streak = 'أيام متتالية';
  static const nextLevel = 'المستوى التالي';

  // Quests
  static const dailyQuests = 'المهام اليومية';
  static const weeklyQuests = 'المهام الأسبوعية';
  static const storyQuests = 'قصة الرحلة';

  // Prayers
  static const fajr = 'الفجر';
  static const dhuhr = 'الظهر';
  static const asr = 'العصر';
  static const maghrib = 'المغرب';
  static const isha = 'العشاء';
  static const azkar = 'الأذكار';
  static const quran = 'القرآن';
  static const tasbeeh = 'التسبيح';

  // Subjects
  static const arabic = 'العربية';
  static const english = 'English';
  static const physics = 'الفيزياء';
  static const chemistry = 'الكيمياء';
  static const biology = 'الأحياء';
  static const history = 'التاريخ';
  static const geography = 'الجغرافيا';
  static const math = 'الرياضيات';
}

class AppConstants {
  static const defaultFocusMinutes = 25;
  static const defaultBreakMinutes = 5;
  static const xpPerFocusMinute = 2;
  static const xpPerCompleteTask = 20;
  static const xpPerPrayer = 30;
  static const xpPerDailyQuest = 40;
  static const maxLevel = 60;
  static const xpPerLevel = 200;

  static const List<String> treeTypes = [
    '🌳', '🌲', '🌴', '🌺', '🌸', '🌻', '🌵', '🎋', '🍀', '🌿'
  ];

  static const List<String> rareTreeTypes = [
    '✨🌟', '🌴✨', '🌸🌟', '🎋💫', '🌳👑'
  ];

  static const List<String> landmarks = [
    '🕌', '⛲', '🏛', '🌊', '🏝', '🌋'
  ];

  static const Map<String, String> prayerNames = {
    'Fajr': 'الفجر',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };
}
