class PrayerDay {
  final DateTime date;
  bool fajr;
  bool dhuhr;
  bool asr;
  bool maghrib;
  bool isha;
  bool morningAzkar;
  bool eveningAzkar;
  int quranPages;
  int tasbeehCount;

  PrayerDay({
    required this.date,
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
    this.morningAzkar = false,
    this.eveningAzkar = false,
    this.quranPages = 0,
    this.tasbeehCount = 0,
  });

  int get completedPrayers => [fajr, dhuhr, asr, maghrib, isha].where((p) => p).length;
  bool get allPrayersDone => completedPrayers == 5;
  double get prayerProgress => completedPrayers / 5;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'fajr': fajr,
    'dhuhr': dhuhr,
    'asr': asr,
    'maghrib': maghrib,
    'isha': isha,
    'morningAzkar': morningAzkar,
    'eveningAzkar': eveningAzkar,
    'quranPages': quranPages,
    'tasbeehCount': tasbeehCount,
  };

  factory PrayerDay.fromJson(Map<String, dynamic> json) => PrayerDay(
    date: DateTime.parse(json['date']),
    fajr: json['fajr'] ?? false,
    dhuhr: json['dhuhr'] ?? false,
    asr: json['asr'] ?? false,
    maghrib: json['maghrib'] ?? false,
    isha: json['isha'] ?? false,
    morningAzkar: json['morningAzkar'] ?? false,
    eveningAzkar: json['eveningAzkar'] ?? false,
    quranPages: json['quranPages'] ?? 0,
    tasbeehCount: json['tasbeehCount'] ?? 0,
  );
}

class PrayerTime {
  final String name;
  final DateTime time;
  PrayerTime({required this.name, required this.time});
}
