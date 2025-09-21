import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hospital.dart';
import '../providers/hospital_provider.dart';
import '../screens/add_hospital_screen.dart';

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onTap;

  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showDeleteOptions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hospital.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRatingColor(hospital.rating),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          hospital.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hospital.location,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.home, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${hospital.employees.length} çalışan',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  if (hospital.phone.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          hospital.phone,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: []),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Hastaneyi Düzenle'),
                subtitle: Text('${hospital.name} hastanesini düzenle'),
                onTap: () {
                  Navigator.pop(context);
                  _editHospital(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hastaneyi Sil'),
                subtitle: Text('${hospital.name} hastanesini sil'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editHospital(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHospitalScreen(hospitalToEdit: hospital),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hastaneyi Sil'),
          content: Text(
            '${hospital.name} hastanesini silmek istediğinizden emin misiniz?\n\nBu işlem geri alınamaz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteHospital(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHospital(BuildContext context) async {
    try {
      final hospitalProvider = context.read<HospitalProvider>();
      await hospitalProvider.deleteHospital(hospital.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${hospital.name} hastanesi silindi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hastane silinirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.orange;
    if (rating >= 3.0) return Colors.amber;
    return Colors.red;
  }
}
