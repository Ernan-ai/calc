// lib/main.dart
// A very simple calculator – written the way a junior would do it

import 'package:flutter/material.dart';

void main() {
  // Start the app
  runApp(const CalculatorApp());
}

// The main app widget (stateless – it never changes)
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

// The screen that holds the calculator (stateful – it can change)
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// All the logic lives here
class _CalculatorScreenState extends State<CalculatorScreen> {
  // What the user sees on the screen
  String display = '0';

  // The first number the user typed
  double firstNumber = 0;

  // The operation the user chose (+, -, ×, ÷)
  String operation = '';

  // Helper: when a number button (0-9 or .) is pressed
  void _numberPressed(String value) {
    setState(() {
      if (display == '0') {
        display = value;               // replace the starting 0
      } else {
        display = display + value;     // add the new digit
      }
    });
  }

  // Helper: when an operation button (+, -, ×, ÷) is pressed
  void _operationPressed(String op) {
    setState(() {
      firstNumber = double.parse(display);   // remember the first number
      operation = op;                        // remember the operation
      display = '0';                         // ready for the second number
    });
  }

  // Helper: when the "=" button is pressed
  void _equalsPressed() {
    final secondNumber = double.parse(display);
    double result = 0;

    // Do the math based on the chosen operation
    if (operation == '+') {
      result = firstNumber + secondNumber;
    } else if (operation == '-') {
      result = firstNumber - secondNumber;
    } else if (operation == '×') {
      result = firstNumber * secondNumber;
    } else if (operation == '÷') {
      if (secondNumber == 0) {
        display = 'Error';
        return;
      }
      result = firstNumber / secondNumber;
    }

    setState(() {
      // Show only whole numbers when possible
      if (result == result.truncate()) {
        display = result.toInt().toString();
      } else {
        display = result.toString();
      }
      // Reset for the next calculation
      firstNumber = 0;
      operation = '';
    });
  }

  // Helper: when "C" (clear) is pressed
  void _clearPressed() {
    setState(() {
      display = '0';
      firstNumber = 0;
      operation = '';
    });
  }

  // Build a single button
  Widget _buildButton(String text, Color color, {bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Decide what to do based on the button text
            if (text == 'C') {
              _clearPressed();
            } else if (text == '=') {
              _equalsPressed();
            } else if ('+-×÷'.contains(text)) {
              _operationPressed(text);
            } else {
              _numberPressed(text);
            }
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // ---------- DISPLAY ----------
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                display,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ---------- BUTTONS ----------
          // Row 1
          Row(
            children: [
              _buildButton('C', Colors.red),
              _buildButton('7', Colors.grey[800]!),
              _buildButton('8', Colors.grey[800]!),
              _buildButton('9', Colors.grey[800]!),
              _buildButton('÷', Colors.orange),
            ],
          ),
          // Row 2
          Row(
            children: [
              _buildButton('4', Colors.grey[800]!),
              _buildButton('5', Colors.grey[800]!),
              _buildButton('6', Colors.grey[800]!),
              _buildButton('×', Colors.orange),
            ],
          ),
          // Row 3
          Row(
            children: [
              _buildButton('1', Colors.grey[800]!),
              _buildButton('2', Colors.grey[800]!),
              _buildButton('3', Colors.grey[800]!),
              _buildButton('-', Colors.orange),
            ],
          ),
          // Row 4
          Row(
            children: [
              _buildButton('0', Colors.grey[800]!, isWide: true), // 0 is twice as wide
              _buildButton('.', Colors.grey[800]!),
              _buildButton('=', Colors.green),
              _buildButton('+', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}