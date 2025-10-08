import 'package:flutter/material.dart';

class InventoryDashboard extends StatelessWidget {
  // Sample data for demo
  final int totalProducts = 150;
  final int totalStock = 1200;
  final int lowStockAlerts = 5;
  final int totalSalesToday = 75;

  final List<String> recentActivities = [
    "Sold 10 LED Bulbs",
    "Received 50 USB Cables",
    "Stock adjusted for Wireless Mouse",
    "Added new product: HDMI Cable",
    "Low stock alert for Batteries",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Products', totalProducts, Colors.blue),
                _buildStatCard('Stock', totalStock, Colors.green),
                _buildStatCard('Low Stock', lowStockAlerts, Colors.red),
                _buildStatCard('Sales Today', totalSalesToday, Colors.orange),
              ],
            ),
            SizedBox(height: 30),

            // Recent Activity
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.separated(
                itemCount: recentActivities.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.history),
                    title: Text(recentActivities[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Card(
      color: color.withOpacity(0.85),
      elevation: 4,
      child: Container(
        width: 80,
        height: 80,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InventoryDashboard(),
    theme: ThemeData(primarySwatch: Colors.deepPurple),
  ));
}
