import 'package:flutter/foundation.dart';
import '../models/personal_details_model.dart';
import '../models/address_details_model.dart';
import '../models/family_details_model.dart';
import '../models/nominee_details_model.dart';
import '../repositories/local_storage.dart';

/// State container for onboarding flow.
///
/// This provider stores models in memory and persists to LocalStorage as needed.
/// It attempts to load from LocalStorage in its constructor (non-blocking).
class OnboardingProvider extends ChangeNotifier {
  PersonalDetailsModel? personal;
  AddressDetailsModel? address;
  FamilyDetailsModel? family;
  NomineeDetailsModel? nominee;
  bool onboardingCompleted = false;

  OnboardingProvider() {
    // Load persisted data asynchronously. This is fire-and-forget but will
    // update listeners once loaded to refresh UI.
    loadFromLocalStorage();
  }

  /// Loads saved models and onboarding flag from LocalStorage.
  /// Expected storage keys: 'personal', 'address', 'family', 'nominee', 'onboarding_completed'
  Future<void> loadFromLocalStorage() async {
    try {
      final p = await LocalStorage.getPersonal();
      if (p != null) {
        personal = PersonalDetailsModel.fromJson(p);
      }
      final a = await LocalStorage.getAddress();
      if (a != null) {
        address = AddressDetailsModel.fromJson(a);
      }
      final f = await LocalStorage.getFamily();
      if (f != null) {
        family = FamilyDetailsModel.fromJson(f);
      }
      final n = await LocalStorage.getNominee();
      if (n != null) {
        nominee = NomineeDetailsModel.fromJson(n);
      }
      onboardingCompleted = await LocalStorage.getOnboardingCompleted();
      notifyListeners();
    } catch (_) {
      // Silently ignore; UI will show defaults.
      notifyListeners();
    }
  }

  /// Persists all present models and completed flag to LocalStorage.
  Future<void> saveAllToLocal() async {
    if (personal != null) await LocalStorage.savePersonal(personal!.toJson());
    if (address != null) await LocalStorage.saveAddress(address!.toJson());
    if (family != null) await LocalStorage.saveFamily(family!.toJson());
    if (nominee != null) await LocalStorage.saveNominee(nominee!.toJson());
    await LocalStorage.saveOnboardingCompleted(onboardingCompleted);
  }

  void updatePersonal(PersonalDetailsModel model) {
    personal = model;
    notifyListeners();
    LocalStorage.savePersonal(model.toJson());
  }

  void updateAddress(AddressDetailsModel model) {
    address = model;
    notifyListeners();
    LocalStorage.saveAddress(model.toJson());
  }

  void updateFamily(FamilyDetailsModel model) {
    family = model;
    notifyListeners();
    LocalStorage.saveFamily(model.toJson());
  }

  void updateNominee(NomineeDetailsModel model) {
    nominee = model;
    notifyListeners();
    LocalStorage.saveNominee(model.toJson());
  }

  Future<void> markCompleted(bool value) async {
    onboardingCompleted = value;
    await LocalStorage.saveOnboardingCompleted(value);
    notifyListeners();
  }
}
