import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _expression = '';
  String _result = '0';

  // Special mode state
  bool _checkSpecialMode = false;
  String _specialSequence = '';
  int _specialSequenceIndex = 0;

  void _startSpecialMode() {
    setState(() {
      // 1. Evaluate current expression to get Current Value
      double currentValue = 0;
      if (_expression.isNotEmpty && _expression != 'Error') {
        try {
          ShuntingYardParser p = ShuntingYardParser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          currentValue = RealEvaluator(cm).evaluate(exp) as double;
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error parsing current expression: $e');
          }
          currentValue = 0; // Default if error
        }
      }

      // 2. Calculate Target (Date Time Code)
      // Current time + 1 minute
      final now = DateTime.now().add(const Duration(minutes: 1));
      // Format as ddmmyyhhmm
      String targetStr =
          '${_twoDigits(now.day)}'
          '${_twoDigits(now.month)}'
          '${_twoDigits(now.year % 100)}'
          '${_twoDigits(now.hour)}'
          '${_twoDigits(now.minute)}';

      double targetValue = double.parse(targetStr);

      // 3. Calculate Difference
      double diff = targetValue - currentValue;
      int diffInt = diff.round();

      // 4. Format Difference as 10 digits (padded with 0)
      //String diffStr = diffInt.abs().toString().padLeft(10, '0');
      String diffStr = diffInt.abs().toString();

      _specialSequence = diffStr;
      _specialSequenceIndex = 0;
      _checkSpecialMode = true;

      if (kDebugMode) {
        debugPrint(
          'Target: $targetValue, Current: $currentValue, Diff: $diffInt, Seq: $_specialSequence',
        );
      }

      // 5. Append '+' to expression to set up the sum
      // Directly append because _onButtonPressed('+') works, but we are inside setState.
      // However, we recently restricted input in _onButtonPressed.
      // So we MUST manually modify _expression here.

      if (_expression == '0') {
        _expression = (diffInt < 0) ? '-' : '+';
      } else {
        _expression += (diffInt < 0) ? '-' : '+';
      }
    });
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (_checkSpecialMode) {
        bool isNumber = RegExp(r'[0-9]').hasMatch(text);

        // Block everything except Numbers and '='
        // We explicitly allowed manual '+' addition in _startSpecialMode via direct state mod.
        if (!isNumber && text != '=') {
          return;
        }

        if (isNumber) {
          if (_specialSequenceIndex < _specialSequence.length) {
            String charToAppend = _specialSequence[_specialSequenceIndex];

            if (_expression == '0' && _specialSequenceIndex == 0) {
              _expression = charToAppend;
            } else {
              _expression += charToAppend;
            }
            _specialSequenceIndex++;
          }
          // Block extra numbers if sequence finished
          return;
        }
      }

      if (text == 'C') {
        _expression = '';
        _result = '0';
        _checkSpecialMode = false; // Reset special mode on Clear
        _specialSequenceIndex = 0;
      } else if (text == '=') {
        _checkSpecialMode = false; // Reset special mode on =
        _specialSequenceIndex = 0;

        try {
          ShuntingYardParser p = ShuntingYardParser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double eval = RealEvaluator(cm).evaluate(exp) as double;
          _result = eval.toString();
          // Remove trailing .0 for integers
          if (_result.endsWith('.0')) {
            _result = _result.substring(0, _result.length - 2);
          }
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_expression == '0') {
          _expression = text;
        } else {
          _expression += text;
        }
      }
    });
  }

  Widget _buildButton(
    String text, {
    Color? color,
    Color? textColor,
    VoidCallback? onDoubleTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: color ?? Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _onButtonPressed(text),
            onDoubleTap: onDoubleTap,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _checkSpecialMode && _specialSequenceIndex < _specialSequence.length
              ? 'Calculadora .'
              : 'Calculadora',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    key: const Key('expression_display'),
                    style: const TextStyle(fontSize: 32, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _result,
                    key: const Key('result_display'),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton(
                          '/',
                          color: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton(
                          '*',
                          color: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton(
                          '-',
                          color: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          'C',
                          color: Colors.red[100],
                          textColor: Colors.red,
                        ),
                        _buildButton('0'),
                        _buildButton('.', color: Colors.grey[200]),
                        _buildButton(
                          '+',
                          color: Colors.orange,
                          textColor: Colors.white,
                          onDoubleTap: _startSpecialMode,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          '=',
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
