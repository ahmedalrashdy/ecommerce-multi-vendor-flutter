import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/models/user_address_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/repos/address_repo.dart';
import '../../../core/services/location_service.dart';
import 'user_address_notifier.dart';

class AddEditAddressState extends Equatable {
  final LatLng? selectedPosition;
  final bool isLoading;
  final bool isFetchingCurrentLocation;
  final String? errorMessage;
  final UserAddressModel? initialAddress;

  const AddEditAddressState({
    this.selectedPosition,
    this.isLoading = true,
    this.isFetchingCurrentLocation = false,
    this.errorMessage,
    this.initialAddress,
  });

  @override
  List<Object?> get props => [
        selectedPosition,
        isLoading,
        isFetchingCurrentLocation,
        errorMessage,
        initialAddress
      ];

  AddEditAddressState copyWith({
    LatLng? selectedPosition,
    bool? isLoading,
    bool? isFetchingCurrentLocation,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddEditAddressState(
      selectedPosition: selectedPosition ?? this.selectedPosition,
      isLoading: isLoading ?? this.isLoading,
      isFetchingCurrentLocation:
          isFetchingCurrentLocation ?? this.isFetchingCurrentLocation,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      initialAddress: initialAddress,
    );
  }
}

class AddEditAddressNotifier extends StateNotifier<AddEditAddressState> {
  final LocationService _locationService;
  final UserAddressModel? _initialAddress;

  AddEditAddressNotifier(this._locationService, this._initialAddress)
      : super(AddEditAddressState(initialAddress: _initialAddress)) {
    _initialize();
  }

  Future<void> _initialize() async {
    // إذا كنا في وضع التعديل ولدينا إحداثيات، استخدمها
    if (_initialAddress?.latitude != null &&
        _initialAddress?.longitude != null) {
      state = state.copyWith(
        selectedPosition:
            LatLng(_initialAddress!.latitude!, _initialAddress!.longitude!),
        isLoading: false,
      );
      return;
    }
    await fetchCurrentLocation();
  }

  void onMapPositionChanged(LatLng newPosition) {
    state = state.copyWith(selectedPosition: newPosition);
  }

  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(
        isFetchingCurrentLocation: true,
        isLoading: state.selectedPosition == null);
    try {
      final position = await _locationService.getCurrentPosition();
      final currentPosition = LatLng(position.latitude, position.longitude);
      state = state.copyWith(
        selectedPosition: currentPosition,
        isLoading: false,
        isFetchingCurrentLocation: false,
      );
    } on LocationServiceException catch (e) {
      state = state.copyWith(
        selectedPosition:
            state.selectedPosition ?? const LatLng(15.3694, 44.1910), // صنعاء
        isLoading: false,
        isFetchingCurrentLocation: false,
        errorMessage: e.message,
      );
    }
  }

  Future<bool> saveAddress({
    required String label,
    required String city,
    required String street,
    String? landmark,
    required WidgetRef ref,
  }) async {
    if (state.selectedPosition == null) {
      state =
          state.copyWith(errorMessage: "الرجاء تحديد موقع على الخريطة أولاً.");
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    // تجميع البيانات لإرسالها
    final data = {
      'label': label,
      'city': city,
      'street': street,
      'landmark': landmark,
      'latitude': state.selectedPosition!.latitude.toStringAsFixed(8),
      'longitude': state.selectedPosition!.longitude.toStringAsFixed(8),
    };

    AppHelper.logger.i(data);
    try {
      final repo = ref.read(addressRepoProvider);
      UserAddressModel savedAddress;

      if (state.initialAddress != null) {
        savedAddress = await repo.updateAddress(state.initialAddress!.id, data);
        ref
            .read(addressNotifierProvider.notifier)
            .updateAddressLocally(savedAddress);
      } else {
        savedAddress = await repo.createAddress(data);
        ref
            .read(addressNotifierProvider.notifier)
            .addAddressLocally(savedAddress);
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final addEditAddressProvider = StateNotifierProvider.autoDispose
    .family<AddEditAddressNotifier, AddEditAddressState, UserAddressModel?>(
        (ref, address) {
  final locationService = ref.watch(locationServiceProvider);
  return AddEditAddressNotifier(locationService, address);
});
