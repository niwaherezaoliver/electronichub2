import 'package:flutter/foundation.dart';
import '../services/location_service.dart';

/// Location address model
class Address {
  final String id;
  final String label; // e.g., "Home", "Work"
  final String street;
  final String city;
  final String region;
  final String country;
  final String postalCode;
  final LatLng coordinates;
  final String phoneNumber;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
    required this.coordinates,
    required this.phoneNumber,
  });

  String get fullAddress => '$street, $city, $region, $country';
}

/// Provider for location management
class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  Address? _currentAddress;
  LatLng? _currentLocation;
  bool _isLoading = false;
  String? _errorMessage;
  final List<Address> _savedAddresses = [];

  LocationProvider() : _locationService = LocationServiceFactory.create() {
    _init();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Address? get currentAddress => _currentAddress;
  LatLng? get currentLocation => _currentLocation;
  List<Address> get savedAddresses => List.unmodifiable(_savedAddresses);

  Future<void> _init() async {
    await _locationService.initialize();
  }

  Future<void> getCurrentLocation() async {
    _setLoading(true);
    _clearError();

    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      final address = await _locationService.getAddressFromCoordinates(
        location,
      );
      _parseAndSetAddress(address, location);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchAddress(String query) async {
    _setLoading(true);
    _clearError();

    try {
      final coordinates = await _locationService.getCoordinatesFromAddress(
        query,
      );
      _currentLocation = coordinates;

      final address = await _locationService.getAddressFromCoordinates(
        coordinates,
      );
      _parseAndSetAddress(address, coordinates);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _parseAndSetAddress(String addressString, LatLng coordinates) {
    // Simple parsing - in real app would use proper address parsing
    _currentAddress = Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: 'Current Location',
      street: addressString,
      city: 'City',
      region: 'Region',
      country: 'Ghana',
      postalCode: '00000',
      coordinates: coordinates,
      phoneNumber: '',
    );
    notifyListeners();
  }

  Future<void> saveAddress(Address address) async {
    _savedAddresses.add(address);
    notifyListeners();
  }

  void selectAddress(Address address) {
    _currentAddress = address;
    _currentLocation = address.coordinates;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
