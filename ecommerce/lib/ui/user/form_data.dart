import 'package:ecommerce/irfan/pages/login_page.dart';
import 'package:ecommerce/utils/api/get_form_user_data.dart';
import 'package:ecommerce/utils/api/update_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDataUser extends StatefulWidget {
  const FormDataUser({super.key});

  @override
  State<FormDataUser> createState() => _FormDataUserState();
}

class _FormDataUserState extends State<FormDataUser> {
  String _userId = '';
  final _alamatController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Map<String, String>? _selectedProvince;
  Map<String, String>? _selectedKabupaten;
  Map<String, String>? _selectedKecamatan;
  Map<String, String>? _selectedDesa;
  List<Map<String, String>> _provinceItems = [];
  List<Map<String, String>> _kabupatenItems = [];
  List<Map<String, String>> _kecamatanItems = [];
  List<Map<String, String>> _desaItems = [];
  bool _isProfileCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showProfileCompletionDialog());
  }

  Future<void> _loadProvinsi() async {
    List<Map<String, String>> provinces = await fetchProvinsi();
    setState(() {
      _provinceItems = provinces;
    });
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _loadKabupaten(String provinceId) async {
    List<Map<String, String>> kabupaten = await fetchKabupaten(provinceId);
    setState(() {
      _kabupatenItems = kabupaten;
    });
  }

  Future<void> _loadKecamatan(String kabupatenId) async {
    List<Map<String, String>> kecamatan = await fetchKecamatan(kabupatenId);
    setState(() {
      _kecamatanItems = kecamatan;
    });
  }

  Future<void> _loadDesa(String kecamatanId) async {
    List<Map<String, String>> desa = await fetchDesa(kecamatanId);
    setState(() {
      _desaItems = desa;
    });
  }

  Future<void> _showProfileCompletionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lengkapi Profil'),
          content: Text('Lengkapi profil kamu sekarang juga!!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _isProfileCompleted = true;
                });
                _loadProvinsi();
                _loadUserId();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> getFormData() {
    List<Map<String, String>> formData = [];
    String? alamat = _alamatController.text;
    String? provinsiId = _selectedProvince!['name'];
    String? kabupatenId = _selectedKabupaten!['name'];
    String kabupatenName = kabupatenId!.replaceFirst('KAB. ', '');
    String? kecamatanId = _selectedKecamatan!['name'];
    String? desaId = _selectedDesa!['name'];
    formData = [
      {'alamat': alamat},
      {
        'desaId': desaId!,
        'kecamatanId': kecamatanId!,
        'kabupatenId': kabupatenName,
        'provinsiId': provinsiId!,
      },
    ];

    return formData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lengkapi Profile Kamu'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: _isProfileCompleted
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _provinceItems.isEmpty
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: Key('firstname'),
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  controller: _firstNameController,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  key: Key('lastname'),
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  controller: _lastNameController,
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 16),
                    TextFormField(
                      key: Key('username'),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      controller: _usernameController,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      key: Key('alamat'),
                      decoration: InputDecoration(
                        labelText: 'Alamat Lengkap',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      controller: _alamatController,
                    ),
                    SizedBox(height: 16),
                    buildDropdown(
                      label: 'Provinsi',
                      hint: 'Pilih Provinsi',
                      value: _selectedProvince,
                      items: _provinceItems,
                      onChanged: (newValue) {
                        print(newValue!['id']);
                        setState(() {
                          _selectedProvince = newValue;
                          _selectedKabupaten = null;
                          _selectedKecamatan = null;
                          _kabupatenItems = [];
                          _desaItems = [];
                          _loadKabupaten(newValue['id']!);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    buildDropdown(
                      label: 'Kabupaten',
                      hint: _selectedProvince == null
                          ? 'Pilih provinsi terlebih dahulu'
                          : 'Pilih Kabupaten',
                      value: _selectedKabupaten,
                      items: _kabupatenItems,
                      onChanged: _selectedProvince == null
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedKabupaten = newValue;
                                _selectedKecamatan = null;
                                _kecamatanItems = [];
                                _desaItems = [];
                                _loadKecamatan(_selectedKabupaten!['id']!);
                              });
                            },
                      isDisabled: _selectedProvince == null,
                    ),
                    SizedBox(height: 16),
                    buildDropdown(
                      label: 'Kecamatan',
                      hint: _selectedKabupaten == null
                          ? 'Pilih kabupaten terlebih dahulu'
                          : 'Pilih Kecamatan',
                      value: _selectedKecamatan,
                      items: _kecamatanItems,
                      onChanged: _selectedKabupaten == null
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedKecamatan = newValue;
                                _selectedDesa = null;
                                _desaItems = [];
                                _loadDesa(_selectedKecamatan!['id']!);
                              });
                            },
                      isDisabled: _selectedKabupaten == null,
                    ),
                    SizedBox(height: 16),
                    buildDropdown(
                      label: 'Desa',
                      hint: _selectedKecamatan == null
                          ? 'Pilih Kecamatan terlebih dahulu'
                          : 'Pilih Desa',
                      value: _selectedDesa,
                      items: _desaItems,
                      onChanged: _selectedKecamatan == null
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedDesa = newValue;
                              });
                            },
                      isDisabled: _selectedKecamatan == null,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          List<Map<String, String>> formData = getFormData();
                          patchUser(
                              username: _usernameController.text,
                              fullName:
                                  '${_firstNameController.text} + ${_lastNameController.text}',
                              id: _userId,
                              alamat: formData);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text('Simpan')),
                    _selectedProvince != null &&
                            _selectedKabupaten != null &&
                            _selectedKecamatan != null &&
                            _selectedDesa != null
                        ? Text(
                            'Provinsi: ${_selectedProvince!['name']} \nKabupaten: ${_selectedKabupaten!['name']} \nKecamatan: ${_selectedKecamatan!['name']}',
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String hint,
    required Map<String, String>? value,
    required List<Map<String, String>> items,
    required void Function(Map<String, String>?)? onChanged,
    bool isDisabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: DropdownButtonFormField<Map<String, String>>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        value: value,
        isExpanded: true,
        hint: Text(hint),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        items: items.map((item) {
          return DropdownMenuItem<Map<String, String>>(
            value: item,
            child: Text(item['name']!),
          );
        }).toList(),
        onChanged: isDisabled ? null : onChanged,
        disabledHint: isDisabled ? Text(hint) : null,
      ),
    );
  }
}
