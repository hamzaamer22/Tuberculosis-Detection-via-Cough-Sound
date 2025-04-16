import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? gender;
  String? fever;
  String? priorTbDiagnosis;
  String? weightLoss;
  String? nightSweats;
  String? smokedPastWeek;

  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  List<String> dropdownOptions = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20), // Added space above the Gender field
                  buildDropdownField('Gender', ['Male', 'Female', 'Other'], (val) {
                    setState(() {
                      gender = val;
                    });
                  }),
                  buildTextField('Age', ageController),
                  buildTextField('Weight', weightController),
                  buildDropdownField('Fever', dropdownOptions, (val) {
                    setState(() {
                      fever = val;
                    });
                  }),
                  buildDropdownField('Prior TB Diagnosis', dropdownOptions, (val) {
                    setState(() {
                      priorTbDiagnosis = val;
                    });
                  }),
                  buildDropdownField('Weight Loss', dropdownOptions, (val) {
                    setState(() {
                      weightLoss = val;
                    });
                  }),
                  buildDropdownField('Night Sweats', dropdownOptions, (val) {
                    setState(() {
                      nightSweats = val;
                    });
                  }),
                  buildDropdownField('Smoked Past Week', dropdownOptions, (val) {
                    setState(() {
                      smokedPastWeek = val;
                    });
                  }),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Navigate to Recording Screen
                          Navigator.pushNamed(context, '/recording');
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              dropdownColor: Colors.white,
              value: items.contains(gender) ? gender : null,
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
