import 'package:get_it/get_it.dart';
import 'package:supabasetime/home/repository/home_repo.dart';
import 'package:supabasetime/shared/services/image_picker/image_picker_service.dart';
import 'package:supabasetime/shared/services/input_validator/input_validator_service.dart';
import 'package:supabasetime/shared/services/navigation/navigation_service.dart';
import 'package:supabasetime/shared/services/supabase/supabase_service.dart';

import 'shared/models/app_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  _setupSingletons();
  _setupFactories();
}

// Place where we put all the factories
void _setupFactories() {
  locator.registerFactory<ImagePickerService>(
    () => ImagePickerServiceImpl(),
  );

  locator.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(),
  );
}

// Place where we put all the singletons
void _setupSingletons() {
  locator.registerLazySingleton<AppModel>(() => AppModel());

  locator.registerLazySingleton<NavigationService>(
    () => NavigationServiceImpl(),
  );

  locator.registerLazySingleton<SupabaseService>(
    () {
      final service = SupabaseServiceImpl(
        appModel: locator<AppModel>(),
      );
      service.init();
      return service;
    },
  );

  locator.registerLazySingleton<InputValidatorService>(
    () => InputValidatorServiceImpl(),
  );
}
