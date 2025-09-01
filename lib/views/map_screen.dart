import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/map_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<Map<String, dynamic>> _locations = [];
  bool _updateDialog = false;
  String _selectedLocale = 'tr';
  Map<String, dynamic> _user = {
    'name': 'Sandra Adams',
    'email': 'sandra_a88@gmail.com',
    'travelerDescription': 'I love traveling and meeting new people!',
    'preferredContact': 'EMAIL',
    'contact': 'sandra_a88@gmail.com'
  };
  Map<String, dynamic> _updatedUser = {};
  final List<Map<String, dynamic>> _contactOptions = [
    {'text': 'Email', 'value': 'EMAIL'},
    {'text': 'Phone', 'value': 'PHONE'},
    {'text': 'WhatsApp', 'value': 'WHATSAPP'}
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _selectedContactMethod = 'EMAIL';
  final String _baseUrl = 'localhost:8080'; // Replace with your actual backend URL
  late final MapService _mapService;

  @override
  void initState() {
    super.initState();
    _loadLocale();
    _mapService = MapService(baseUrl: _baseUrl);
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
    setState(() {
      _selectedLocale = prefs.getString('locale') ?? 'tr';
    });
  }

  String _t(String key) {
    final Map<String, Map<String, String>> translations = {
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

    return translations[_selectedLocale]?[key] ?? key;
  }

  Future<void> _checkAuthAndLoadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    try {
      final locations = await _mapService.fetchLocations(token);
      setState(() {
        _locations = locations;
      });
    } catch (error) {
      // Error loading locations
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('user');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _openUpdateDialog() {
    _updatedUser = Map<String, dynamic>.from(_user);
    _nameController.text = _updatedUser['name'] ?? '';
    _emailController.text = _updatedUser['email'] ?? '';
    _descriptionController.text = _updatedUser['travelerDescription'] ?? '';
    _contactController.text = _updatedUser['contact'] ?? '';
    _selectedContactMethod = _updatedUser['preferredContact'] ?? 'EMAIL';

    setState(() {
      _updateDialog = true;
    });
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
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
      if (!success) {
        throw Exception('Update failed');
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $error')),
      );
    }
  }

  List<Marker> _buildMarkers() {
    return _locations.map((location) {
      return Marker(
        point: LatLng(
            location['latitude'].toDouble(), location['longitude'].toDouble()),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => _showLocationPopup(location),
          child: Icon(
            Icons.location_on,
            color: location['isOwner'] == true ? Colors.orange : Colors.red,
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
          title: Text('${_t('owner')}: ${location['name']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${_t('about')}: ${location['travelerDescription']}'),
                const SizedBox(height: 8),
                Text('${_t('offer')}: ${location['locationDescription']}'),
                const SizedBox(height: 8),
                Text('${location['preferredContact']}: ${location['contact']}'),
                if (location['isOwner'] == true) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditLocationDialog(location);
                    },
                    child: Text(_t('updateLocation')),
                  ),
                ],
              ],
            ),
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

  void _showEditLocationDialog(Map<String, dynamic> location) {
    final TextEditingController descriptionController = TextEditingController();
    descriptionController.text = location['locationDescription'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_t('updateLocation')),
          content: TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: _t('offer'),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_t('cancelUpdateLocation')),
            ),
            ElevatedButton(
              onPressed: () {
                _updateLocationDescription(
                  location['latitude'].toDouble(),
                  location['longitude'].toDouble(),
                  descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text(_t('save')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateLocationDescription(
      double latitude, double longitude, String newDescription) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse('http://localhost:8080/api/locations'),
        headers: {
          'accept': '*/*',
          'X-Token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'description': newDescription,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (!response.statusCode.toString().startsWith('2')) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Update failed');
      }

      // Update local data
      setState(() {
        final locationIndex = _locations.indexWhere(
            (l) => l['latitude'] == latitude && l['longitude'] == longitude);
        if (locationIndex != -1) {
          _locations[locationIndex]['locationDescription'] = newDescription;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
    } catch (error) {
      // Error updating location
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _updateDialog
          ? _buildUpdateDialog()
          : Row(
              children: [
                // Navigation Drawer (Sidebar)
                Container(
                  width: 280,
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      // Profile Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  'assets/images/cicloviajera-color-2.png'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user['name'] ?? 'Sandra Adams',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _user['email'] ?? 'sandra_a88@gmail.com',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      // Navigation Items
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
                // Main Content Area (Map)
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: const MapOptions(
                      initialCenter:
                          LatLng(40.0637, -3.7492), // Spain coordinates
                      initialZoom: 7.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: _buildMarkers(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUpdateDialog() {
    return Stack(
      children: [
        // Background overlay
        Container(
          color: Colors.black54,
          width: double.infinity,
          height: double.infinity,
        ),
        // Dialog
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('updateProfile'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: _t('name'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: _t('email'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: _t('aboutMe'),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedContactMethod,
                      decoration: InputDecoration(
                        labelText: _t('preferredContact'),
                        border: const OutlineInputBorder(),
                      ),
                      items: _contactOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option['value'],
                          child: Text(option['text']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedContactMethod = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: _t('contactInfo'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _updateDialog = false;
                            });
                          },
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
          ),
        ),
      ],
    );
  }
}
