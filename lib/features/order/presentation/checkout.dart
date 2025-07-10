import 'package:flutter/material.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout Details'),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionCard(
              title: "Address Details",
              children: [
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.orange),
                  title: Text("Store Location"),
                  subtitle: Text("Mang Engking"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SectionCard(
              title: "Seats Details",
              children: [
                ListTile(
                  leading: Icon(Icons.chair_alt_rounded, color: Colors.orange),
                  title: Text("Table No 9"),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.orange),
                  title: Text("Sabtu, 25 Agustus"),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.orange),
                  title: Text("16.00 - 19.00"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SectionCard(
              title: "Rincian Pesanan",
              children: [
                OrderItem(
                  qty: "10 x",
                  name: "Udang Bakar Madu",
                  price: "115.000",
                ),
                OrderItem(qty: "1 x", name: "Es Kopyor", price: "15.000"),
                OrderItem(qty: "10 x", name: "Nasi Putih", price: "100.000"),
                Divider(),
                OrderItem(qty: "", name: "Subtotal", price: "230.000"),
                OrderItem(qty: "", name: "Admin 4%", price: "9.100"),
                Divider(),
                OrderItem(
                  qty: "",
                  name: "Total",
                  price: "Rp239.100",
                  isBold: true,
                  color: Colors.orange,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Checkout Now"),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
