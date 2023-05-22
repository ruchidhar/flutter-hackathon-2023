import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasetime/shared/models/mood_model.dart';
import 'package:supabasetime/shared/models/user_profile.dart';
import 'package:supabasetime/shared/resources/resource.dart';

import '../../models/app_model.dart';

abstract class SupabaseService {
  SupabaseClient get supabaseClient;

  Future<void> init();

  Future<void> signIn(String email);
  Future<UserProfile> getProfile();
  Future<String> uploadBinary(
    String filePath,
    Uint8List bytes,
    XFile? imageFile, {
    FileOptions fileOptions = const FileOptions(),
  });

  Future<bool> updateProfile(UserProfile profile);
  Future<bool> updateMood(MoodEntry mood);
  Future<List<MoodEntry>> fetchMoodRecords(String dateFrom, String dateTo);

  Future<void> signOut();
}

class SupabaseServiceImpl implements SupabaseService {
  SupabaseServiceImpl({
    required AppModel appModel,
  }) : _appModel = appModel;

  final AppModel _appModel;

  @override
  Future<void> init() async {
    if (_initialize) {
      return;
    }

    _initialize = true;

    // Create the instance
    supabase = Supabase.instance.client;
    supabase!.auth.onAuthStateChange.listen(_onAuthStateChange);
  }

  @override
  Future<void> signIn(String email) async {
    try {
      await supabase!.auth.signInWithOtp(
        email: email,
        emailRedirectTo: !_appModel.isApp
            ? null
            : 'com.example.supabasetime://login-callback/',
      );
    } on AuthException catch (error) {
      debugPrint('Auth Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }
  }

  @override
  SupabaseClient get supabaseClient => supabase!;

  @override
  Future<void> signOut() async {
    try {
      await supabase?.auth.signOut();
    } on AuthException catch (error) {
      debugPrint('Auth Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      final userId = supabase?.auth.currentUser!.id;

      final data = await supabase!
          .from(TableResource.profile)
          .select()
          .eq('id', userId)
          .single() as Map<String, dynamic>;

      final profile = UserProfile.fromJson(data);
      return profile;
    } on PostgrestException catch (error) {
      debugPrint('Postgres Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }

    return UserProfile.dummy();
  }

  // INTERNALS
  Future<void> _onAuthStateChange(AuthState data) async {
    final session = data.session;

    if (session != null) {
      _appModel.session = session;
    }
  }

  @override
  Future<String> uploadBinary(
    String filePath,
    Uint8List bytes,
    XFile? imageFile, {
    FileOptions fileOptions = const FileOptions(),
  }) async {
    try {
      await supabase!.storage.from(TableResource.avatars).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile?.mimeType),
          );

      final imageUrlResponse = await supabase!.storage
          .from(TableResource.avatars)
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      return imageUrlResponse;
    } on StorageException catch (error) {
      debugPrint('Storage Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }

    return '';
  }

  @override
  Future<bool> updateProfile(UserProfile profile) async {
    try {
      await supabase!.from(TableResource.profile).upsert(profile);
      return true;
    } on PostgrestException catch (error) {
      debugPrint('Postgres Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }

    return false;
  }

  @override
  Future<bool> updateMood(MoodEntry mood) async {
    try {
      await supabase!.from(TableResource.moodTracker).upsert(mood.toJson());
      return true;
    } on PostgrestException catch (error) {
      debugPrint('Postgres Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }

    return false;
  }

  bool _initialize = false;
  SupabaseClient? supabase;

  @override
  Future<List<MoodEntry>> fetchMoodRecords(
      String dateFrom, String dateTo) async {
    try {
      final data = await supabase!
          .from(TableResource.moodTracker)
          .select()
          .gte(ColumnResource.moodTrackerUpdatedAt, dateFrom)
          .lte(ColumnResource.moodTrackerUpdatedAt, dateTo);

      final modelResp = convertToModelList(data);

      return modelResp;
    } on PostgrestException catch (error) {
      debugPrint('Postgres Exception ${error.message}');
    } catch (error) {
      debugPrint('Unexpected error occurred ${error.toString()}');
    }

    return [];
  }
}
