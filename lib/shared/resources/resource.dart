import 'package:supabasetime/shared/models/mood_model.dart';

class TableResource {
  TableResource._();

  static const String profile = 'profiles';
  static const String avatars = 'avatars';
  static const String moodTracker = 'mood_tracker';
}

class ColumnResource {
  ColumnResource._();

  static const String moodTrackerUpdatedAt = 'updated_at';
}

class SVGResource {
  SVGResource._();

  static const String logo = 'assets/images/app_logo.svg';
}

class ConstantsResource {
  ConstantsResource._();

  static String emojiMap(MoodType type) {
    switch (type) {
      case MoodType.Awesome:
        return '🥳';

      case MoodType.Good:
        return '😃';

      case MoodType.Neutral:
        return '😐';

      case MoodType.Sad:
        return '😞';
    }
  }
}
