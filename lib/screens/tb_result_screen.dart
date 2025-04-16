import 'package:flutter/material.dart';
import 'dart:math';

class TBResultScreen extends StatelessWidget {
  final bool tbDetected; // Determines which result to show

  TBResultScreen({required this.tbDetected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/detection_icon.png', // Replace with your detection icon
              width: 180,
              height: 180,
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    tbDetected ? "TB Detected" : "No TB Detected",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: tbDetected ? Colors.red : Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    tbDetected
                        ? "Consult a doctor for confirmation"
                        : "Stay Healthy",
                    style: TextStyle(
                      fontSize: 18,
                      color: tbDetected ? Colors.red : Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(200, 50),
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to recording screen
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
