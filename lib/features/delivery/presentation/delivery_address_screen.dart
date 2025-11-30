import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restaurant_customer_app/features/delivery/models/delivery_location.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final String branchId;
  final String initialAddress;

  const DeliveryAddressScreen({
    super.key,
    required this.branchId,
    required this.initialAddress,
  });

  static String _addrKey(String branchId) => 'delivery_address_branch_$branchId';
  static String _locKey(String branchId) => 'delivery_location_$branchId';

  static Future<String?> loadForBranch(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_addrKey(branchId));
    final s = (raw ?? '').trim();
    if (s.isNotEmpty) return s;
    final loc = await loadLocationForBranch(branchId);
    final a = (loc?.address ?? '').trim();
    return a.isEmpty ? null : a;
  }

  static Future<void> saveForBranch(String branchId, String address) async {
    final prefs = await SharedPreferences.getInstance();
    final s = address.trim();
    if (s.isEmpty) {
      await prefs.remove(_addrKey(branchId));
      await prefs.remove(_locKey(branchId));
      return;
    }
    await prefs.setString(_addrKey(branchId), s);
    await prefs.remove(_locKey(branchId));
  }

  static Future<DeliveryLocation?> loadLocationForBranch(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_locKey(branchId));
    final s = (raw ?? '').trim();
    if (s.isEmpty) return null;
    try {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return DeliveryLocation.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLocationForBranch(
    String branchId,
    DeliveryLocation loc,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locKey(branchId), jsonEncode(loc.toJson()));
    final a = loc.address.trim();
    if (a.isEmpty) {
      await prefs.remove(_addrKey(branchId));
    } else {
      await prefs.setString(_addrKey(branchId), a);
    }
  }

  static Future<void> clearForBranch(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_addrKey(branchId));
    await prefs.remove(_locKey(branchId));
  }

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  GoogleMapController? _mapCtrl;
  final _addressCtrl = TextEditingController();

  LatLng? _picked;
  bool _loadingGps = false;
  bool _loadingReverse = false;
  bool _saving = false;

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _addressCtrl.text = widget.initialAddress.trim();

    DeliveryAddressScreen.loadLocationForBranch(widget.branchId).then((loc) {
      if (!mounted) return;
      if (loc == null) return;
      setState(() {
        _picked = LatLng(loc.lat, loc.lng);
        if (_addressCtrl.text.trim().isEmpty) {
          _addressCtrl.text = loc.address;
        }
      });
    });

    DeliveryAddressScreen.loadForBranch(widget.branchId).then((addr) {
      if (!mounted) return;
      final cur = _addressCtrl.text.trim();
      if (cur.isNotEmpty) return;
      final a = (addr ?? '').trim();
      if (a.isEmpty) return;
      setState(() => _addressCtrl.text = a);
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 900)),
    );
  }

  Future<void> _ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception(_isAr ? 'فعّل خدمة الموقع' : 'Enable location service');
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      throw Exception(_isAr ? 'تم رفض صلاحية الموقع' : 'Location denied');
    }
  }

  Future<void> _moveToMyLocation() async {
    if (_loadingGps) return;
    setState(() => _loadingGps = true);
    try {
      await _ensurePermission();
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final ll = LatLng(pos.latitude, pos.longitude);
      setState(() => _picked = ll);
      await _mapCtrl?.animateCamera(CameraUpdate.newLatLngZoom(ll, 16));
      await _reverseGeocode(ll);
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loadingGps = false);
    }
  }

  Future<void> _reverseGeocode(LatLng ll) async {
    if (_loadingReverse) return;
    setState(() => _loadingReverse = true);
    try {
      final places = await placemarkFromCoordinates(ll.latitude, ll.longitude);
      if (places.isEmpty) return;
      final p = places.first;

      final parts = <String>[
        if ((p.street ?? '').trim().isNotEmpty) p.street!.trim(),
        if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality!.trim(),
        if ((p.locality ?? '').trim().isNotEmpty) p.locality!.trim(),
      ];

      final addr = parts.join(', ').trim();
      if (addr.isNotEmpty && mounted) {
        setState(() => _addressCtrl.text = addr);
      }
    } catch (_) {
      return;
    } finally {
      if (mounted) setState(() => _loadingReverse = false);
    }
  }

  Future<void> _onTapMap(LatLng ll) async {
    setState(() => _picked = ll);
    await _reverseGeocode(ll);
  }

  Future<void> _saveAndReturn() async {
    if (_saving) return;

    final picked = _picked;
    final addr = _addressCtrl.text.trim();

    if (picked == null) {
      _toast(_isAr ? 'حدد موقعك من الخريطة' : 'Pick a location on the map');
      return;
    }

    if (addr.isEmpty) {
      _toast(_isAr ? 'اكتب وصف بسيط للعنوان' : 'Enter a short address');
      return;
    }

    setState(() => _saving = true);
    try {
      final loc = DeliveryLocation(
        address: addr,
        lat: picked.latitude,
        lng: picked.longitude,
      );
      await DeliveryAddressScreen.saveLocationForBranch(widget.branchId, loc);
      if (!mounted) return;
      Navigator.of(context).pop(addr);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: Navigator.of(context, rootNavigator: true).context,
      builder: (ctx) => AlertDialog(
        title: Text(_isAr ? 'حذف الموقع؟' : 'Clear location?'),
        content: Text(
          _isAr
              ? 'رح نحذف موقع وعنوان التوصيل المحفوظ لهذا الفرع.'
              : 'This will remove the saved delivery location for this branch.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(_isAr ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(_isAr ? 'حذف' : 'Clear'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await DeliveryAddressScreen.clearForBranch(widget.branchId);
    if (!mounted) return;

    setState(() {
      _picked = null;
      _addressCtrl.text = '';
    });

    _toast(_isAr ? 'تم الحذف' : 'Cleared');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final initialCamera = CameraPosition(
      target: _picked ?? const LatLng(31.9539, 35.9106),
      zoom: _picked == null ? 12 : 16,
    );

    final markers = _picked == null
        ? const <Marker>{}
        : {
            Marker(
              markerId: const MarkerId('picked'),
              position: _picked!,
              draggable: true,
              onDragEnd: (ll) => _onTapMap(ll),
            )
          };

    return Scaffold(
      appBar: AppBar(
        title: Text(_isAr ? 'تحديد موقع التوصيل' : 'Pick delivery location'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _clear,
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: _loadingGps || _saving ? null : _moveToMyLocation,
            icon: _loadingGps
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCamera,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: markers,
            onMapCreated: (c) {
              _mapCtrl = c;
              final p = _picked;
              if (p != null) {
                _mapCtrl?.moveCamera(CameraUpdate.newLatLngZoom(p, 16));
              }
            },
            onTap: _onTapMap,
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Material(
              color: cs.surface,
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _addressCtrl,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: _isAr ? 'وصف العنوان' : 'Address note',
                        hintText: _isAr
                            ? 'مثال: جنب مسجد… / رقم البناية…'
                            : 'Example: Building no… / Near…',
                        suffixIcon: _loadingReverse
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _saving ? null : _saveAndReturn,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                _isAr ? 'اعتماد هذا الموقع' : 'Use this location',
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
