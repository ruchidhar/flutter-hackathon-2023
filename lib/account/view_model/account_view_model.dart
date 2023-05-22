import 'package:flutter/widgets.dart';
import 'package:supabasetime/shared/models/user_profile.dart';
import 'package:supabasetime/shared/routes/routes.dart';
import 'package:supabasetime/shared/services/image_picker/image_picker_service.dart';

import '../../shared/services/navigation/navigation_service.dart';
import '../../shared/services/supabase/supabase_service.dart';
import '../../shared/view_models/loading_view_model.dart';

class AccountViewModel extends LoadingViewModel {
  AccountViewModel({
    required NavigationService navigationService,
    required SupabaseService supabaseService,
    required ImagePickerService imagePickerService,
  })  : _navigationService = navigationService,
        _supabaseService = supabaseService,
        _imagePickerService = imagePickerService;

  final NavigationService _navigationService;
  final SupabaseService _supabaseService;
  final ImagePickerService _imagePickerService;

  Future<void> signOut() async {
    await _supabaseService.signOut();
    _navigationService.pushReplacementNamed(AppRoutes.splashRoute);
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    appModel.userProfile = await _supabaseService.getProfile();
    isLoading = false;
  }

  Future<void> uploadPhoto() async {
    try {
      final fileDetails = await _imagePickerService.pickImage();

      isLoading = true;

      final imageUrl = await _supabaseService.uploadBinary(
        fileDetails.fileName,
        fileDetails.bytes,
        fileDetails.imageFile,
      );

      await _supabaseService.updateProfile(
        UserProfile(
          id: appModel.userProfile.id,
          avatarUrl: imageUrl,
          updatedAt: DateTime.now().toIso8601String(),
          username: appModel.userProfile.username,
        ),
      );

      await fetchProfile();
    } catch (err) {
      debugPrint('Error in uploadPhoto ${err.toString()}');
    }

    isLoading = false;
  }

  Future<void> updateUserName(String username) async {
    try {
      isLoading = true;

      await _supabaseService.updateProfile(
        UserProfile(
          id: appModel.userProfile.id,
          avatarUrl: appModel.userProfile.avatarUrl,
          updatedAt: DateTime.now().toIso8601String(),
          username: username,
        ),
      );

      await fetchProfile();
    } catch (err) {
      debugPrint('Error in updateUserName ${err.toString()}');
    }

    isLoading = false;
  }
}
