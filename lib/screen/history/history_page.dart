// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   bool _isAscending = true;

//   // Dummy list data
//   final List<Map<String, dynamic>> _historyList = [
//     {"date": DateTime(2025, 8, 13), "result": "Downy Mildew"},
//     {"date": DateTime(2025, 8, 10), "result": "Healthy"},
//     {"date": DateTime(2025, 8, 5), "result": "Powdery Mildew"},
//   ];

//   List<Map<String, dynamic>> get _sortedHistory {
//     final list = [..._historyList];
//     list.sort(
//       (a, b) => _isAscending
//           ? a["date"].compareTo(b["date"])
//           : b["date"].compareTo(a["date"]),
//     );
//     return list;
//   }

//   void _toggleSortOrder() {
//     setState(() {
//       _isAscending = !_isAscending;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           // Tombol ascending/descending
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton.icon(
//                 onPressed: _toggleSortOrder,
//                 icon: Icon(
//                   _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
//                 ),
//                 label: Text(_isAscending ? "Tanggal" : "Tanggal"),
//               ),
//             ),
//           ),

//           // List riwayat
//           Expanded(
//             child: ListView.builder(
//               itemCount: _sortedHistory.length,
//               itemBuilder: (context, index) {
//                 final item = _sortedHistory[index];
//                 return ListTile(
//                   leading: const Icon(Icons.history),
//                   title: Text(item["result"]),
//                   subtitle: Text(DateFormat.yMMMMd().format(item["date"])),
//                   onTap: () {
//                     // nanti bisa buka detail result
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
