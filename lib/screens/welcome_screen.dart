import 'package:flutter/material.dart';
import '../widgets/background_painter.dart';
import 'form_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BackgroundPainter())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.black, size: 28),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Step 1: Prepare to\nrecord in a quiet environment.\n\nStep 2: Enter correct\nbackground information for optimal results.\n\nStep 3: Tap the record button and cough when prompted",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset('assets/person_coughing.png', width: 170),
                  ),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/form');
                    },
                    child: Text("Agree & Continue", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
