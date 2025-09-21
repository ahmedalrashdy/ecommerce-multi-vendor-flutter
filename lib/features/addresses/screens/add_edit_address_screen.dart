import 'package:ecommerce/core/helpers/app_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/models/user_address_model.dart';
import '../providers/add_edit_address_provider.dart';
import '../providers/enum.dart';

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final UserAddressModel? address;
  const AddEditAddressScreen({super.key, this.address});

  @override
  ConsumerState<AddEditAddressScreen> createState() =>
      _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  GoogleMapController? _mapController;

  late final TextEditingController _labelController;
  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  YemeniCity? _selectedCity;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address?.label);
    _streetController = TextEditingController(text: widget.address?.street);
    _landmarkController = TextEditingController(text: widget.address?.landmark);
    _selectedCity = YemeniCity.fromString(widget.address?.city ?? '');
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _labelController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(addEditAddressProvider(widget.address).notifier);

    final success = await notifier.saveAddress(
      label: _labelController.text,
      city: _selectedCity!.arabicName,
      street: _streetController.text,
      landmark: _landmarkController.text,
      ref: ref,
    );

    if (mounted) {
      if (success) {
        AppMessage.showSuccess(message: 'تم حفظ العنوان بنجاح');
        Navigator.of(context).pop();
      } else {
        final errorMessage =
            ref.read(addEditAddressProvider(widget.address)).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(errorMessage ?? 'حدث خطأ غير متوقع'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEditAddressProvider(widget.address));
    final notifier = ref.read(addEditAddressProvider(widget.address).notifier);
    final bool isEditMode = widget.address != null;

    ref.listen<AddEditAddressState>(addEditAddressProvider(widget.address),
        (previous, next) {
      if (previous?.selectedPosition != next.selectedPosition &&
          next.selectedPosition != null) {
        _mapController
            ?.animateCamera(CameraUpdate.newLatLng(next.selectedPosition!));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'تعديل العنوان' : 'إضافة عنوان جديد'),
        actions: [
          // عرض مؤشر تحميل أثناء الحفظ
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white)),
            )
          else
            IconButton(
              onPressed: _onSave,
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'حفظ',
            ),
        ],
      ),
      body: Stack(
        children: [
          state.isLoading
              ? const Center(child: Text("جاري تحديد موقعك..."))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: state.selectedPosition!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: notifier.onMapPositionChanged,
                  markers: {
                    if (state.selectedPosition != null)
                      Marker(
                        markerId: const MarkerId('selected-location'),
                        position: state.selectedPosition!,
                        draggable: true, // السماح بسحب الدبوس
                        onDragEnd: (newPosition) {
                          notifier.onMapPositionChanged(newPosition);
                        },
                      ),
                  },
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildAddressForm(state),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: state.isFetchingCurrentLocation
                  ? null
                  : notifier.fetchCurrentLocation,
              child: state.isFetchingCurrentLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location),
            ),
          )
        ],
      ),
    );
  }

  // داخل class _AddEditAddressScreenState

  Widget _buildAddressForm(AddEditAddressState state) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(
        addEditAddressProvider(widget.address).select((s) => s.isLoading));

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تفاصيل العنوان',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (state.isLoading)
                    const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              ),
              const Divider(height: 24),

              TextFormField(
                controller: _labelController,
                decoration: _buildInputDecoration(
                  labelText: 'اسم العنوان',
                  hintText: 'مثال: المنزل، العمل...',
                  icon: Icons.label_outline_rounded,
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<YemeniCity>(
                value: _selectedCity,
                hint: const Text('المدينة'),
                isExpanded: true,
                items: YemeniCity.values.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city.arabicName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => _selectedCity = newValue);
                    _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(newValue.coordinates, 14));
                  }
                },
                decoration: _buildInputDecoration(
                  labelText: 'المدينة',
                  icon: Icons.location_city_rounded,
                ),
                validator: (value) =>
                    value == null ? 'الرجاء اختيار مدينة' : null,
              ),
              const SizedBox(height: 16),

              // --- حقل الشارع ---
              TextFormField(
                controller: _streetController,
                decoration: _buildInputDecoration(
                  labelText: 'الشارع',
                  hintText: 'ادخل اسم الشارع',
                  icon: Icons.signpost_rounded,
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // --- حقل أقرب معلم ---
              TextFormField(
                controller: _landmarkController,
                decoration: _buildInputDecoration(
                  labelText: 'أقرب معلم (اختياري)',
                  hintText: 'مثال: بجانب جامع الخير',
                  icon: Icons.flag_rounded,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

// ✅ --- دالة مساعدة مركزية لتصميم الحقول ---
  InputDecoration _buildInputDecoration({
    required String labelText,
    String? hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5),
      ),
    );
  }
}
