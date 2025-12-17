// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/chat_controller.dart';

// class SingleChat extends StatefulWidget {
//   final String name;
//   final String image;
//   final String receiverId;

//   const SingleChat({
//     super.key,
//     required this.name,
//     required this.image,
//     required this.receiverId,
//   });

//   @override
//   State<SingleChat> createState() => _SingleChatState();
// }

// class _SingleChatState extends State<SingleChat> {
//   final chatC = Get.find<ChatController>();
//   final msgController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       key: const ValueKey("singleChat"),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),

//       child: Column(
//         children: [
//           // ---------- HEADER ----------
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 CircleAvatar(radius: 22, backgroundImage: NetworkImage(image)),
//                 const SizedBox(width: 10),
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const Divider(),

//           // ---------- CHAT MESSAGES ----------
//           Expanded(
//             child: Center(
//               child: Text(
//                 "Chat with $name",
//                 style: const TextStyle(fontSize: 18, color: Colors.black54),
//               ),
//             ),
//           ),

//           // ---------- INPUT FIELD ----------
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
//             child: Row(
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.attach_file_rounded, color: Colors.grey),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.poll_outlined, color: Colors.grey),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: msgController,
//                     decoration: InputDecoration(
//                       prefixIcon: IconButton(
//                         onPressed: () {},
//                         icon: Icon(Icons.image_outlined, color: Colors.grey),
//                       ),
//                       hintText: "Send a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(35),
//                         borderSide: const BorderSide(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () async {
//                     if (msgController.text.trim().isEmpty) return;

//                     await chatC.sendMessage(
//                       widget.receiverId,
//                       msgController.text.trim(),
//                     );
//                     msgController.clear();
//                   },
//                   child: CircleAvatar(
//                     radius: 22,
//                     backgroundColor: Color(0xffbfdbfe),
//                     child: const Icon(
//                       Icons.send,
//                       color: Color(0xff1e40af),
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
