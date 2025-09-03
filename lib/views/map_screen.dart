import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/map_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  List<Map<String, dynamic>> _locations = [];
  bool _updateDialog = false;
  String _selectedLocale = 'en';
  String _selectedContactMethod = 'EMAIL';

  Map<String, dynamic> _user = {
    'name': 'Sandra Adams',
    'email': 'sandra_a88@gmail.com',
    'travelerDescription': 'I love traveling and meeting new people!',
    'preferredContact': 'EMAIL',
    'contact': 'sandra_a88@gmail.com',
  };

  final List<Map<String, dynamic>> _contactOptions = const [
    {'text': 'Email', 'value': 'EMAIL'},
    {'text': 'Phone', 'value': 'PHONE'},
    {'text': 'WhatsApp', 'value': 'WHATSAPP'}
  ];

  final String _baseUrl = 'localhost:8080';
  late final MapService _mapService = MapService(baseUrl: _baseUrl);

  final Map<String, Map<String, String>> _translations = const {
    'tr': {
      'updateProfile': 'Profili Güncelle',
      'logout': 'Çıkış Yap',
      'cancel': 'İptal',
      'save': 'Kaydet',
      'owner': 'Sahip',
      'about': 'Hakkında',
      'offer': 'Teklif',
      'updateLocation': 'Konumu Güncelle',
      'cancelUpdateLocation': 'İptal',
      'profileUpdated': 'Profil başarıyla güncellendi',
      'name': 'İsim',
      'email': 'Email',
      'aboutMe': 'Hakkımda',
      'preferredContact': 'Tercih Edilen İletişim',
      'contactInfo': 'İletişim Bilgisi',
    },
    'en': {
      'updateProfile': 'Update Profile',
      'logout': 'Logout',
      'cancel': 'Cancel',
      'save': 'Save',
      'owner': 'Owner',
      'about': 'About',
      'offer': 'Offer',
      'updateLocation': 'Update Location',
      'cancelUpdateLocation': 'Cancel',
      'profileUpdated': 'Profile updated successfully',
      'name': 'Name',
      'email': 'Email',
      'aboutMe': 'About Me',
      'preferredContact': 'Preferred Contact Method',
      'contactInfo': 'Contact Info',
    },
    'es': {
      'updateProfile': 'Actualizar Perfil',
      'logout': 'Cerrar Sesión',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'owner': 'Propietario',
      'about': 'Acerca de',
      'offer': 'Oferta',
      'updateLocation': 'Actualizar Ubicación',
      'cancelUpdateLocation': 'Cancelar',
      'profileUpdated': 'Perfil actualizado exitosamente',
      'name': 'Nombre',
      'email': 'Correo',
      'aboutMe': 'Acerca de Mí',
      'preferredContact': 'Método de Contacto Preferido',
      'contactInfo': 'Información de Contacto',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadLocale();
    _checkAuthAndLoadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedLocale = prefs.getString('locale') ?? 'en';
    });
  }

  String _t(String key) {
    return _translations[_selectedLocale]?[key] ?? key;
  }

  Future<void> _checkAuthAndLoadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    try {
      final locations = await _mapService.fetchLocations(token);
      if (!mounted) return;
      setState(() => _locations = locations);
    } catch (_) {}
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('user');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _openUpdateDialog() {
    _nameController.text = _user['name'] ?? '';
    _emailController.text = _user['email'] ?? '';
    _descriptionController.text = _user['travelerDescription'] ?? '';
    _contactController.text = _user['contact'] ?? '';
    _selectedContactMethod = _user['preferredContact'] ?? 'EMAIL';

    setState(() => _updateDialog = true);
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    try {
      final success = await _mapService.updateProfile(token, {
        'name': _nameController.text,
        'email': _emailController.text,
        'travelerDescription': _descriptionController.text,
        'preferredContact': _selectedContactMethod,
        'contact': _contactController.text,
      });
      if (!success) throw Exception('Update failed');

      if (!mounted) return;
      setState(() {
        _user = {
          'name': _nameController.text,
          'email': _emailController.text,
          'travelerDescription': _descriptionController.text,
          'preferredContact': _selectedContactMethod,
          'contact': _contactController.text,
        };
        _updateDialog = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('profileUpdated'))),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.updateFailed ??
                'Update failed: $error')),
      );
    }
  }

  List<Marker> _buildMarkers() {
    return _locations.map((location) {
      return Marker(
        point: LatLng(
          (location['latitude'] ?? 0).toDouble(),
          (location['longitude'] ?? 0).toDouble(),
        ),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showLocationPopup(location),
          child: Icon(
            Icons.location_on,
            color: location['isOwner'] == true
                ? const Color.fromRGBO(255, 165, 0, 1)
                : const Color.fromRGBO(255, 0, 0, 1),
            size: 40,
          ),
        ),
      );
    }).toList();
  }

  void _showLocationPopup(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(location['name'] ?? _t('offer')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_t('owner')}: ${location['owner'] ?? ''}'),
              const SizedBox(height: 8),
              Text('${_t('about')}: ${location['description'] ?? ''}'),
              const SizedBox(height: 8),
              Text('${_t('contactInfo')}: ${location['contact'] ?? ''}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_t('cancel')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpdateDialog() {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: _t('name'))),
              const SizedBox(height: 8),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: _t('email'))),
              const SizedBox(height: 8),
              TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: _t('aboutMe'))),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedContactMethod,
                items: _contactOptions
                    .map((option) => DropdownMenuItem<String>(
                          value: option['value'],
                          child: Text(option['text'] ?? ''),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedContactMethod = value ?? 'EMAIL';
                  });
                },
                decoration: InputDecoration(labelText: _t('preferredContact')),
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: _t('contactInfo'))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _updateDialog = false),
                    child: Text(_t('cancel')),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text(_t('save')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/hero-banner.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _updateDialog ? _buildUpdateDialog() : _buildMainLayout(),
      ),
    );
  }

  Widget _buildMainLayout() {
    return Row(
      children: [
        Container(
          width: 280,
          color: Colors.grey.shade100,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                          'lib/assets/images/cicloviajera-color-2.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_user['name'] ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(_user['email'] ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(_t('updateProfile')),
                onTap: _openUpdateDialog,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(_t('logout')),
                onTap: _logout,
              ),
            ],
          ),
        ),
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
                initialCenter: LatLng(40.0637, -3.7492), initialZoom: 7.0),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
        ),
      ],
    );
  }
}
