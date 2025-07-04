import 'package:flutter/material.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

class TableOrder extends StatefulWidget {
  const TableOrder({super.key});

  @override
  State<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends State<TableOrder> {
  String? selectedDate;
  String? selectedTime;
  String? selectedTable;

  final List<String> dates = ['5 Juli 2025', '6 Juli 2025', '7 Juli 2025'];
  final List<String> times = ['10:00', '12:00', '14:00', '16:00'];
  final List<String> tables = ['Meja 1', 'Meja 2', 'Meja 3', 'Meja 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Seat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/image/table.png',
                width: 300,
                height: 300,
              ),
            ),
            const SizedBox(height: 24),

            Dropdown(
              hint: 'Pilih Tanggal',
              value: selectedDate,
              items: dates,
              onChanged: (val) => setState(() => selectedDate = val),
            ),

            const SizedBox(height: 16),

            Dropdown(
              hint: 'Pilih Jam',
              value: selectedTime,
              items: times,
              onChanged: (val) => setState(() => selectedTime = val),
            ),

            const SizedBox(height: 16),

            Dropdown(
              hint: 'Pilih Meja',
              value: selectedTable,
              items: tables,
              onChanged: (val) => setState(() => selectedTable = val),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
