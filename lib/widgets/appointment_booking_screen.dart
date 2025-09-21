import 'package:flutter/material.dart';
import '../models/hospital.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final Hospital hospital;
  final Employee employee;

  const AppointmentBookingScreen({
    super.key,
    required this.hospital,
    required this.employee,
  });

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  final List<String> _timeSlots = [
    '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Al'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Doctor Info Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.employee.photoUrl.isNotEmpty
                      ? NetworkImage(widget.employee.photoUrl)
                      : null,
                  child: widget.employee.photoUrl.isEmpty
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.employee.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.employee.role,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Hospital Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.hospital.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Date Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tarih Seçin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7, // 1 week
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      final isSelected = _selectedDate.day == date.day &&
                          _selectedDate.month == date.month &&
                          _selectedDate.year == date.year;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                            _selectedTimeSlot = null; // Reset time selection
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getDayName(date.weekday),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getMonthName(date.month),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Time Selection
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saat Seçin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final timeSlot = _timeSlots[index];
                    final isSelected = _selectedTimeSlot == timeSlot;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeSlot = timeSlot;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // Book Appointment Button
          Container(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTimeSlot != null
                    ? () => _bookAppointment()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Randevuyu Onayla',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return months[month - 1];
  }

  void _bookAppointment() {
    if (_selectedTimeSlot == null) return;

    final appointmentDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      int.parse(_selectedTimeSlot!.split(':')[0]),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevu Onayı'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doktor: ${widget.employee.name}'),
            Text('Hastane: ${widget.hospital.name}'),
            Text('Tarih: ${_formatDate(appointmentDate)}'),
            Text('Saat: $_selectedTimeSlot'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessDialog();
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Randevu Alındı'),
          ],
        ),
        content: const Text('Randevunuz başarıyla alındı. Randevu detayları size SMS ile gönderilecektir.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
