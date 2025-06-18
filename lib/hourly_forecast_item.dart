import "package:flutter/material.dart";

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final double temperature;
  final IconData icon;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(8),
        width: 100,
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Icon(Icons.cloud, size: 32),
            SizedBox(height: 8),
            Text("${temperature.toString()} K", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
