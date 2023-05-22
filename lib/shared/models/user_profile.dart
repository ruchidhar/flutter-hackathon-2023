import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  String id;
  String? updatedAt;
  String? username;
  String? avatarUrl;
  String? website;

  UserProfile({
    required this.id,
    this.updatedAt,
    this.username,
    this.avatarUrl,
    this.website,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        updatedAt: json["updated_at"],
        username: json["username"],
        avatarUrl: json["avatar_url"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updated_at": updatedAt,
        "username": username,
        "avatar_url": avatarUrl,
        "website": website,
      };

  factory UserProfile.dummy() => UserProfile(
        id: '',
        updatedAt: '',
        username: '',
        avatarUrl: '',
        website: '',
      );
}
