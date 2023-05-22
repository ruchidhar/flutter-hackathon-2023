import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasetime/shared/models/user_profile.dart';

class AppModel extends ChangeNotifier {
  bool get isApp => !kIsWeb;
  Session? get session => _session;
  UserProfile get userProfile => _userProfile;

  set userProfile(UserProfile value) {
    _userProfile = value;
    notifyListeners();
  }

  set session(Session? value) {
    _session = value;
    notifyListeners();
  }

  Session? _session;
  UserProfile _userProfile = UserProfile.dummy();
}
