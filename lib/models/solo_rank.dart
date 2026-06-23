enum SoloRank { e, d, c, b, a, s }

enum SubjectBranch { science, math, literature }

extension SoloRankExtension on SoloRank {
  String get name {
    switch (this) {
      case SoloRank.e: return 'E-Rank';
      case SoloRank.d: return 'D-Rank';
      case SoloRank.c: return 'C-Rank';
      case SoloRank.b: return 'B-Rank';
      case SoloRank.a: return 'A-Rank';
      case SoloRank.s: return 'S-Rank';
    }
  }

  String get title {
    switch (this) {
      case SoloRank.e: return 'مبتدئ';
      case SoloRank.d: return 'مجتهد';
      case SoloRank.c: return 'مثابر';
      case SoloRank.b: return 'متقن';
      case SoloRank.a: return 'نابغة';
      case SoloRank.s: return 'أسطورة';
    }
  }

  String get emoji {
    switch (this) {
      case SoloRank.e: return '🟢';
      case SoloRank.d: return '🔵';
      case SoloRank.c: return '🟣';
      case SoloRank.b: return '🟠';
      case SoloRank.a: return '🔴';
      case SoloRank.s: return '👑';
    }
  }

  int get requiredLevel {
    switch (this) {
      case SoloRank.e: return 0;
      case SoloRank.d: return 10;
      case SoloRank.c: return 20;
      case SoloRank.b: return 35;
      case SoloRank.a: return 50;
      case SoloRank.s: return 60;
    }
  }
}
