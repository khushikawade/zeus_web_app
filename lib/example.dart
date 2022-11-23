// import 'package:flutter/material.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:zeus/helper_widget/delete_dialog.dart';

// class Example extends StatefulWidget {
//   @override
//   // ignore: no_logic_in_create_state
//   @override
//   ExampleState createState() => ExampleState();
// }

// class ExampleState extends State<Example> {
//   bool loadingdata = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Example'),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: Colors.white,
//             child: TextButton(
//                 onPressed: () {
//                   _showLoading();
                  
//                 },
//                 child: Text(
//                   'Click',
//                   style: TextStyle(color: Colors.black),
//                 )),
//           ),
          
//         ],
//       ),
//     );
//   }

//   void _showLoading() async {
//     SmartDialog.showLoading(
//       msg: "Your request is in progress please wait for a while...",
//     );
//     await Future.delayed(Duration(seconds: 2));
//     SmartDialog.dismiss();
//   }
// }
