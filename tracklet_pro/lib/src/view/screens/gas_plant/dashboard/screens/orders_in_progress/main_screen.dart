import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class OrdersInProgressScreen extends StatelessWidget {
  const OrdersInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders In Progress"),
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.lightBlueBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orders In Progress",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "This screen displays orders that are currently in progress.",
              style: TextStyle(fontSize: 16),
            ),
            // Add more content here as needed
          ],
        ),
      ),
    );
  }
}