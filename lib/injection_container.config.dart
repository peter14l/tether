// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import 'core/theme/time_theme_cubit.dart' as _i66;
import 'core/utils/encryption_service.dart' as _i376;
import 'core/utils/escrow_service.dart' as _i873;
import 'core/utils/key_derivation.dart' as _i880;
import 'features/circles/data/repositories/supabase_circle_repository.dart'
    as _i759;
import 'features/circles/domain/repositories/circle_repository.dart' as _i333;
import 'features/circles/presentation/bloc/circle_cubit.dart' as _i75;
import 'features/couples/data/repositories/supabase_couples_repository.dart'
    as _i701;
import 'features/couples/data/repositories/supabase_gallery_repository.dart'
    as _i14;
import 'features/couples/data/repositories/supabase_milestones_repository.dart'
    as _i896;
import 'features/couples/domain/repositories/couples_repository.dart' as _i331;
import 'features/couples/domain/repositories/gallery_repository.dart' as _i340;
import 'features/couples/domain/repositories/milestones_repository.dart'
    as _i122;
import 'features/couples/presentation/bloc/couple_bubble_cubit.dart' as _i375;
import 'features/couples/presentation/bloc/private_gallery_cubit.dart' as _i361;
import 'features/couples/presentation/bloc/space_to_breathe_cubit.dart'
    as _i177;
import 'features/family/data/repositories/supabase_bedtime_stories_repository.dart'
    as _i35;
import 'features/family/data/repositories/supabase_family_repository.dart'
    as _i660;
import 'features/family/data/repositories/supabase_heritage_repository.dart'
    as _i600;
import 'features/family/domain/repositories/bedtime_stories_repository.dart'
    as _i133;
import 'features/family/domain/repositories/family_repository.dart' as _i665;
import 'features/family/domain/repositories/heritage_repository.dart' as _i209;
import 'features/family/presentation/bloc/bedtime_stories_cubit.dart' as _i310;
import 'features/family/presentation/bloc/family_safety_cubit.dart' as _i412;
import 'features/family/presentation/bloc/heritage_cubit.dart' as _i523;
import 'features/feed/data/repositories/supabase_feed_repository.dart' as _i409;
import 'features/feed/domain/repositories/feed_repository.dart' as _i185;
import 'features/feed/presentation/bloc/feed_cubit.dart' as _i400;
import 'features/journal/data/repositories/supabase_journal_repository.dart'
    as _i422;
import 'features/journal/data/repositories/supabase_reflection_repository.dart'
    as _i742;
import 'features/journal/domain/repositories/journal_repository.dart' as _i246;
import 'features/journal/domain/repositories/reflection_repository.dart'
    as _i832;
import 'features/journal/presentation/bloc/journal_cubit.dart' as _i485;
import 'features/journal/presentation/bloc/reflection_cubit.dart' as _i738;
import 'features/messaging/data/repositories/supabase_messaging_repository.dart'
    as _i540;
import 'features/messaging/domain/repositories/messaging_repository.dart'
    as _i77;
import 'features/messaging/presentation/bloc/messaging_cubit.dart' as _i431;
import 'features/mood/data/repositories/supabase_mood_repository.dart' as _i904;
import 'features/mood/domain/repositories/mood_repository.dart' as _i116;
import 'features/mood/presentation/bloc/mood_cubit.dart' as _i553;
import 'features/settings/data/repositories/shared_prefs_settings_repository.dart'
    as _i68;
import 'features/settings/domain/repositories/settings_repository.dart'
    as _i309;
import 'features/wellness/data/repositories/supabase_presence_repository.dart'
    as _i599;
import 'features/wellness/domain/repositories/presence_repository.dart'
    as _i358;
import 'features/wellness/presentation/bloc/presence_cubit.dart' as _i870;
import 'injection_container.dart' as _i809;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i66.TimeThemeCubit>(() => _i66.TimeThemeCubit());
    gh.lazySingleton<_i376.EncryptionService>(() => _i376.EncryptionService());
    gh.lazySingleton<_i880.KeyDerivation>(() => _i880.KeyDerivation());
    gh.lazySingleton<_i340.IGalleryRepository>(
      () => _i14.SupabaseGalleryRepository(
        gh<_i454.SupabaseClient>(),
        gh<_i376.EncryptionService>(),
      ),
    );
    gh.lazySingleton<_i873.EscrowService>(
      () => _i873.EscrowService(
        gh<_i376.EncryptionService>(),
        gh<_i880.KeyDerivation>(),
      ),
    );
    gh.lazySingleton<_i309.ISettingsRepository>(
      () => _i68.SharedPrefsSettingsRepository(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i246.IJournalRepository>(
      () => _i422.SupabaseJournalRepository(
        gh<_i454.SupabaseClient>(),
        gh<_i376.EncryptionService>(),
      ),
    );
    gh.lazySingleton<_i832.IReflectionRepository>(
      () => _i742.SupabaseReflectionRepository(
        gh<_i454.SupabaseClient>(),
        gh<_i376.EncryptionService>(),
      ),
    );
    gh.factory<_i738.ReflectionCubit>(
      () => _i738.ReflectionCubit(
        gh<_i832.IReflectionRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i133.IBedtimeStoriesRepository>(
      () => _i35.SupabaseBedtimeStoriesRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i209.IHeritageRepository>(
      () => _i600.SupabaseHeritageRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i77.IMessagingRepository>(
      () => _i540.SupabaseMessagingRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i185.IFeedRepository>(
      () => _i409.SupabaseFeedRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i400.FeedCubit>(
      () => _i400.FeedCubit(
        gh<_i185.IFeedRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i358.IPresenceRepository>(
      () => _i599.SupabasePresenceRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i431.MessagingCubit>(
      () => _i431.MessagingCubit(
        gh<_i77.IMessagingRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i333.ICircleRepository>(
      () => _i759.SupabaseCircleRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i665.IFamilyRepository>(
      () => _i660.SupabaseFamilyRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i361.PrivateGalleryCubit>(
      () => _i361.PrivateGalleryCubit(gh<_i340.IGalleryRepository>()),
    );
    gh.lazySingleton<_i331.ICouplesRepository>(
      () => _i701.SupabaseCouplesRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i523.HeritageCubit>(
      () => _i523.HeritageCubit(
        gh<_i209.IHeritageRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i116.IMoodRepository>(
      () => _i904.SupabaseMoodRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i412.FamilySafetyCubit>(
      () => _i412.FamilySafetyCubit(
        gh<_i665.IFamilyRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i75.CircleCubit>(
      () => _i75.CircleCubit(
        gh<_i333.ICircleRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i122.IMilestonesRepository>(
      () => _i896.SupabaseMilestonesRepository(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i870.PresenceCubit>(
      () => _i870.PresenceCubit(gh<_i358.IPresenceRepository>()),
    );
    gh.factory<_i375.CoupleBubbleCubit>(
      () => _i375.CoupleBubbleCubit(
        gh<_i331.ICouplesRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i177.SpaceToBreatheCubit>(
      () => _i177.SpaceToBreatheCubit(
        gh<_i331.ICouplesRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i485.JournalCubit>(
      () => _i485.JournalCubit(
        gh<_i246.IJournalRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i310.BedtimeStoriesCubit>(
      () => _i310.BedtimeStoriesCubit(
        gh<_i133.IBedtimeStoriesRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i553.MoodCubit>(
      () => _i553.MoodCubit(
        gh<_i116.IMoodRepository>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i809.RegisterModule {}
