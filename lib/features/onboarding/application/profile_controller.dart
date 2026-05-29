import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_store.dart';
import '../domain/user_profile.dart';

/// Holds the live [UserProfile] and persists every mutation locally.
/// (Supabase sync layer plugs in here later.)
class ProfileController extends Notifier<UserProfile> {
  late final LocalStore _store;

  @override
  UserProfile build() {
    _store = ref.read(localStoreProvider);
    final raw = _store.getProfile();
    if (raw != null) {
      try {
        return UserProfile.fromJson(raw);
      } catch (_) {/* fall through to default */}
    }
    return const UserProfile();
  }

  void _set(UserProfile next) {
    state = next;
    _store.setProfile(next.toJson());
  }

  void update(UserProfile Function(UserProfile) fn) => _set(fn(state));

  void setGender(Gender g) => _set(state.copyWith(gender: g));
  void setGoal(FitnessGoal g) => _set(state.copyWith(goal: g));
  void setActivity(ActivityLevel a) => _set(state.copyWith(activityLevel: a));
  void setDiet(DietType d) => _set(state.copyWith(dietType: d));
  void setName(String n) => _set(state.copyWith(name: n));
  void setBirthYear(int y) => _set(state.copyWith(birthYear: y));
  void setHeight(double cm) => _set(state.copyWith(heightCm: cm));
  void setCurrentWeight(double kg) =>
      _set(state.copyWith(currentWeightKg: kg));
  void setTargetWeight(double kg) => _set(state.copyWith(targetWeightKg: kg));
  void setWeeklyRate(double kg) => _set(state.copyWith(weeklyRateKg: kg));
  void setUnits(UnitSystem u) => _set(state.copyWith(units: u));

  void toggleArea(BodyArea area) {
    final areas = Set<BodyArea>.from(state.problemAreas);
    areas.contains(area) ? areas.remove(area) : areas.add(area);
    _set(state.copyWith(problemAreas: areas));
  }

  void completeOnboarding() =>
      _set(state.copyWith(onboardingComplete: true));

  void reset() => _set(const UserProfile());
}

final profileProvider =
    NotifierProvider<ProfileController, UserProfile>(ProfileController.new);
