// ignore: constant_identifier_names
enum MoodType { Awesome, Good, Neutral, Sad }

MoodType mapStringToMood(String value) {
  return MoodType.values.firstWhere(
    (item) => item.toString() == 'MoodType.$value',
    orElse: () => MoodType.Awesome,
  );
}

List<MoodEntry> convertToModelList(List<dynamic> list) {
  return list.map((dynamicItem) {
    return MoodEntry(
      id: dynamicItem['id'] as String,
      updatedAt: dynamicItem['updated_at'] as String,
      date: dynamicItem['date'] as String,
      moodName: dynamicItem['mood_type'] as String,
      userId: dynamicItem['user_id'] as String,
    );
  }).toList();
}

class MoodEntry {
  final String moodName;
  final String? updatedAt;
  final String? data;
  final String? id;
  final String userId;
  final String date;

  MoodEntry({
    this.id,
    required this.moodName,
    required this.userId,
    required this.date,
    this.updatedAt,
    this.data,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        id: json["id"],
        updatedAt: json["updated_at"],
        moodName: json["mood_type"],
        data: json["data"],
        userId: json["user_id"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "updated_at": updatedAt,
        "data": data,
        "mood_type": moodName,
        "date": date,
      };
}
