import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator/main.dart';

void main() {
  // Helper to find button by text
  Finder findButton(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }

  // Helper to get text from a Text widget by key
  String getText(WidgetTester tester, String key) {
    final Text widget = tester.widget(find.byKey(Key(key)));
    return widget.data ?? '';
  }

  testWidgets('Calculator basic addition test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Verify initial state
    expect(getText(tester, 'result_display'), '0');
    
    // Tap '1'
    await tester.tap(findButton('1'));
    await tester.pump();
    
    // Tap '+'
    await tester.tap(findButton('+'));
    await tester.pump();
    
    // Tap '2'
    await tester.tap(findButton('2'));
    await tester.pump();
    
    // Tap '='
    await tester.tap(findButton('='));
    await tester.pump();
    
    // Verify result is 3
    expect(getText(tester, 'result_display'), '3');
  });

  testWidgets('Calculator clear test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(findButton('5'));
    await tester.pump();
    
    // Check expression has 5
    expect(getText(tester, 'expression_display'), '5');
    
    await tester.tap(findButton('C'));
    await tester.pump();
    
    // Should be back to initial state
    expect(getText(tester, 'result_display'), '0');
    expect(getText(tester, 'expression_display'), '');
  });
  
  testWidgets('Calculator division test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tester.tap(findButton('8'));
    await tester.pump();
    await tester.tap(findButton('/'));
    await tester.pump();
    await tester.tap(findButton('2'));
    await tester.pump();
    await tester.tap(findButton('='));
    await tester.pump();
    
    expect(getText(tester, 'result_display'), '4');
  });
}
