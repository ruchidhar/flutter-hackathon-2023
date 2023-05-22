import 'package:flutter/foundation.dart';

import '../../locator.dart';
import '../models/app_model.dart';

class LoadingViewModel extends ChangeNotifier {
  bool get isLoading => _isLoading;

  /// Fetch the app level data
  AppModel appModel = locator<AppModel>();

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _isLoading = false;
}
