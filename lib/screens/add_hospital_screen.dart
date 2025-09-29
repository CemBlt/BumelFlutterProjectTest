import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hospital_provider.dart';
import '../models/hospital.dart';

class AddHospitalScreen extends StatefulWidget {
  final Hospital? hospitalToEdit;
  
  const AddHospitalScreen({super.key, this.hospitalToEdit});

  @override
  State<AddHospitalScreen> createState() => _AddHospitalScreenState();
}

class _AddHospitalScreenState extends State<AddHospitalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    if (widget.hospitalToEdit != null) {
      _loadHospitalData();
    }
  }

  void _loadHospitalData() {
    final hospital = widget.hospitalToEdit!;
    _nameController.text = hospital.name;
    _cityController.text = hospital.city;
    _districtController.text = hospital.district;
    _addressController.text = hospital.address;
    _phoneController.text = hospital.phone ?? '';
    _emailController.text = hospital.email ?? '';
    _descriptionController.text = hospital.description ?? '';
    _imageUrlController.text = hospital.imageUrl ?? '';
    _employees.addAll(hospital.employees);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addEmployee() {
    showDialog(
      context: context,
      builder: (context) => _EmployeeDialog(
        onSave: (employee) {
          setState(() {
            _employees.add(employee);
          });
        },
      ),
    );
  }


  void _saveHospital() {
    if (_formKey.currentState!.validate()) {
      final hospital = Hospital(
        id: widget.hospitalToEdit?.id ?? 0,
        name: _nameController.text,
        city: _cityController.text,
        district: _districtController.text,
        rating: null, // Puan kullanıcı yorumlarından hesaplanacak
        employees: _employees,
        reviews: [], // Yorumlar ayrı ekranda eklenecek
        address: _addressController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
        createdAt: DateTime.now(),
      );

      if (widget.hospitalToEdit != null) {
        context.read<HospitalProvider>().updateHospital(hospital);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hastane başarıyla güncellendi!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        context.read<HospitalProvider>().addHospital(hospital);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hastane başarıyla eklendi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.hospitalToEdit != null ? 'Hastane Düzenle' : 'Hastane Ekle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Temel Bilgiler'),
              _buildTextField(
                controller: _nameController,
                label: 'Hastane Adı',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hastane adı gerekli';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _cityController,
                label: 'Şehir',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şehir gerekli';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _districtController,
                label: 'İlçe',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İlçe gerekli';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _addressController,
                label: 'Adres',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Adres gerekli';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Telefon',
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'E-posta',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Açıklama (Opsiyonel)',
                maxLines: 3,
              ),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Resim URL (Opsiyonel)',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Çalışanlar'),
              if (_employees.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Henüz çalışan eklenmemiş',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._employees.asMap().entries.map((entry) {
                  final index = entry.key;
                  final employee = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(employee.name[0]),
                      ),
                      title: Text(employee.name),
                      subtitle: Text(employee.role),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _employees.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ElevatedButton.icon(
                onPressed: _addEmployee,
                icon: const Icon(Icons.person_add),
                label: const Text('Çalışan Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveHospital,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.hospitalToEdit != null ? 'Değişiklikleri Kaydet' : 'Hastaneyi Kaydet',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
}

class _EmployeeDialog extends StatefulWidget {
  final Function(Employee) onSave;

  const _EmployeeDialog({required this.onSave});

  @override
  State<_EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<_EmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _photoUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Çalışan Ekle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
                textInputAction: TextInputAction.next,
                enableSuggestions: true,
                autocorrect: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad soyad gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Rol'),
                textInputAction: TextInputAction.next,
                enableSuggestions: true,
                autocorrect: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rol gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'Fotoğraf URL'),
                textInputAction: TextInputAction.done,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final employee = Employee(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text,
                role: _roleController.text,
                specialization: '',
                experienceYears: 0,
                photoUrl: _photoUrlController.text,
              );
              widget.onSave(employee);
              Navigator.pop(context);
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}


