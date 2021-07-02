// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:mbpayment/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//     showModalBottomSheet(
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         context: context,
//         builder: (builder) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 1.5,
//             decoration: BoxDecoration(
//                 color: Theme.of(context).scaffoldBackgroundColor,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   alignment: Alignment.topCenter,
//                   padding: EdgeInsets.all(10),
//                   child: Icon(Icons.drag_handle),
//                 ),
//                 Container(
//                   alignment: Alignment.topCenter,
//                   padding: EdgeInsets.all(20),
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Column(
//                       mainAxisAlignment:
//                       MainAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 15),
//                         TextFormField(
//                           keyboardType: TextInputType.number,
//                           controller: _amount,
//                           decoration: InputDecoration(
//                             hintText: 'Amount',
//                             helperText:
//                             'Enter the amount of money you would like to transfer',
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         TextFormField(
//                           controller: _reference,
//                           decoration: InputDecoration(
//                             hintText: 'Transfer Details',
//                             helperText:
//                             'Enter a Recipient Reference',
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         sendButton(_amount.text),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   });
// }



