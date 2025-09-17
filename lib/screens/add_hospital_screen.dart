import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hospital_provider.dart';
import '../models/hospital.dart';

class AddHospitalScreen extends StatefulWidget {
  const AddHospitalScreen({super.key});

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
  final _ratingController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  final List<Employee> _employees = [];
  final List<Review> _reviews = [];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ratingController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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

  void _addReview() {
    showDialog(
      context: context,
      builder: (context) => _ReviewDialog(
        onSave: (review) {
          setState(() {
            _reviews.add(review);
          });
        },
      ),
    );
  }

  void _saveHospital() {
    if (_formKey.currentState!.validate()) {
      final hospital = Hospital(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        city: _cityController.text,
        district: _districtController.text,
        rating: double.tryParse(_ratingController.text) ?? 0.0,
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
        employees: _employees,
        reviews: _reviews,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      context.read<HospitalProvider>().addHospital(hospital);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hastane başarıyla eklendi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane Ekle'),
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
              // Temel bilgiler
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
                controller: _ratingController,
                label: 'Puan (0-5)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final rating = double.tryParse(value);
                    if (rating == null || rating < 0 || rating > 5) {
                      return 'Puan 0-5 arasında olmalı';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Konum bilgileri
              _buildSectionTitle('Konum Bilgileri'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _latitudeController,
                      label: 'Enlem',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _longitudeController,
                      label: 'Boylam',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Çalışanlar
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
                      subtitle: Text('${employee.role} - ${employee.specialization}'),
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
              const SizedBox(height: 24),
              // Yorumlar
              _buildSectionTitle('Yorumlar'),
              if (_reviews.isEmpty)
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
                        Icons.rate_review_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Henüz yorum eklenmemiş',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._reviews.asMap().entries.map((entry) {
                  final index = entry.key;
                  final review = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(review.userName[0]),
                      ),
                      title: Text(review.userName),
                      subtitle: Text(review.comment),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          Text(' ${review.rating}'),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _reviews.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ElevatedButton.icon(
                onPressed: _addReview,
                icon: const Icon(Icons.add_comment),
                label: const Text('Yorum Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // Kaydet butonu
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
                  child: const Text(
                    'Hastaneyi Kaydet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _photoUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rol gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Uzmanlık Alanı'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Deneyim Yılı'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'Fotoğraf URL'),
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
                specialization: _specializationController.text,
                experienceYears: int.tryParse(_experienceController.text) ?? 0,
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

class _ReviewDialog extends StatefulWidget {
  final Function(Review) onSave;

  const _ReviewDialog({required this.onSave});

  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _commentController = TextEditingController();
  final _photoUrlController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _userNameController.dispose();
    _commentController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yorum Ekle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kullanıcı adı gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Puan: ${_rating.toStringAsFixed(1)}'),
              Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 8,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Yorum'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yorum gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Fotoğraf URL'),
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
              final review = Review(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                userName: _userNameController.text,
                userPhotoUrl: _photoUrlController.text,
                rating: _rating,
                comment: _commentController.text,
                date: DateTime.now(),
                photos: [],
              );
              widget.onSave(review);
              Navigator.pop(context);
            }
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
