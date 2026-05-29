import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas 12 - Location Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3B6D11),
        scaffoldBackgroundColor: const Color(0xFFF5F9F0),
      ),
      home: const LocationPage(),
    );
  }
}

class LocationData {
  final double? lat1, lng1;
  final double? lat2, lng2;
  final String? street, city, country;

  LocationData({
    this.lat1,
    this.lng1,
    this.lat2,
    this.lng2,
    this.street,
    this.city,
    this.country,
  });
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  static const darkGreen = Color(0xFF27500A);
  static const midGreen = Color(0xFF3B6D11);
  static const baseGreen = Color(0xFF639922);
  static const lightGreen = Color(0xFF97C459);
  static const paleGreen = Color(0xFFC0DD97);
  static const bgGreen = Color(0xFFEAF3DE);

  bool _loading = true;
  LocationData _data = LocationData();

  @override
  void initState() {
    super.initState();
    _runTasks();
  }

  Future<void> _runTasks() async {
    await _checkPermission();

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('KOORDINAT PERANGKAT | Geolocator.getCurrentPosition()');
      print('Latitude  : ${pos.latitude}');
      print('Longitude : ${pos.longitude}');
      setState(
        () => _data = LocationData(
          lat1: pos.latitude,
          lng1: pos.longitude,
          lat2: _data.lat2,
          lng2: _data.lng2,
          street: _data.street,
          city: _data.city,
          country: _data.country,
        ),
      );
    } catch (e) {
      print('ERROR Instruksi 1: $e');
    }

    try {
      List<Location> locs = await locationFromAddress(
        'Telkom University, Jl. Telekomunikasi No. 1, Bandung',
      );
      print('\n');
      print('\nKOORDINAT KAMPUS | locationFromAddress()');
      print('Latitude  : ${locs.first.latitude}');
      print('Longitude : ${locs.first.longitude}');
      setState(
        () => _data = LocationData(
          lat1: _data.lat1,
          lng1: _data.lng1,
          lat2: locs.first.latitude,
          lng2: locs.first.longitude,
          street: _data.street,
          city: _data.city,
          country: _data.country,
        ),
      );
    } catch (e) {
      print('ERROR Instruksi 2: $e');
    }

    try {
      List<Placemark> marks = await placemarkFromCoordinates(
        52.2165157,
        6.9437819,
      );
      Placemark p = marks.first;
      print('\n');
      print('\nKOORDINAT 52.2165157, 6.9437819 | placemarkFromCoordinates()');
      print('Nama Jalan : ${p.street}');
      print('Kota       : ${p.locality}');
      print('Negara     : ${p.country}');
      setState(() {
        _data = LocationData(
          lat1: _data.lat1,
          lng1: _data.lng1,
          lat2: _data.lat2,
          lng2: _data.lng2,
          street: p.street,
          city: p.locality,
          country: p.country,
        );
        _loading = false;
      });
    } catch (e) {
      print('ERROR Instruksi 3: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _checkPermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildCard('Instruksi 1 — Koordinat Perangkat', [
                    _row('Latitude', _data.lat1?.toStringAsFixed(6) ?? '...'),
                    _row('Longitude', _data.lng1?.toStringAsFixed(6) ?? '...'),
                  ]),
                  const SizedBox(height: 12),
                  _buildCard('Instruksi 2 — Koordinat Kampus', [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Telkom University, Bandung',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    _row('Latitude', _data.lat2?.toStringAsFixed(6) ?? '...'),
                    _row('Longitude', _data.lng2?.toStringAsFixed(6) ?? '...'),
                  ]),
                  const SizedBox(height: 12),
                  _buildCard('Instruksi 3 — Alamat dari Koordinat', [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '52.2165157, 6.9437819',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    _row('Nama jalan', _data.street ?? '...'),
                    _row('Kota', _data.city ?? '...'),
                    _row('Negara', _data.country ?? '...'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: darkGreen,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tugas 12_103012300320_Fidhela Ghaisani Shabrina',
                style: TextStyle(color: paleGreen, fontSize: 13),
              ),
              const Icon(Icons.map_outlined, color: paleGreen, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Geolocator & Geocoding',
            style: TextStyle(
              color: bgGreen,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: midGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: baseGreen,
                  radius: 18,
                  child: const Icon(
                    Icons.my_location,
                    color: bgGreen,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Lokasi',
                      style: TextStyle(color: paleGreen, fontSize: 11),
                    ),
                    Text(
                      _loading ? 'Memuat...' : 'Izin diberikan',
                      style: const TextStyle(
                        color: bgGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: paleGreen, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: midGreen,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: lightGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: bgGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: bgGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: darkGreen,
                fontWeight: FontWeight.w500,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
