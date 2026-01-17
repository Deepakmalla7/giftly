import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _principalNumberController =
      TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  double? _result;
  void _calculateSI() {
    double principalNumber =
        double.tryParse(_principalNumberController.text) ?? 00;
    double rate = double.tryParse(_rateController.text) ?? 0;
    double time = double.tryParse(_timeController.text) ?? 0;
    setState(() {
      _result = (principalNumber * rate * time) / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Simple Interest Calculator",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _principalNumberController,
            decoration: InputDecoration(labelText: "Principal"),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _rateController,
            decoration: InputDecoration(labelText: "Rate"),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _timeController,
            decoration: InputDecoration(labelText: "Time"),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _calculateSI, child: Text("Calculate SI")),
          SizedBox(height: 20),

          Text('Result:$_result', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
//
//