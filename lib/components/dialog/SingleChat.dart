// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/chat_controller.dart';
//
// class SingleChat extends StatefulWidget {
//   final String name;
//   final String image;
//   final String receiverId;
//
//   const SingleChat({
//     super.key,
//     required this.name,
//     required this.image,
//     required this.receiverId,
//   });
//
//   @override
//   State<SingleChat> createState() => _SingleChatState();
// }
//
// class _SingleChatState extends State<SingleChat> {
//   final chatC = Get.find<ChatController>();
//   final msgController = TextEditingController();
//
//   @override
//   void dispose() {
//     msgController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Container(
//       key: const ValueKey("singleChat"),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF334155) : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           // ---------- HEADER ----------
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF334155) : Colors.white,
//               border: Border(
//                 bottom: BorderSide(
//                   color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundImage: NetworkImage(widget.image),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     widget.name,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? Colors.white : const Color(0xFF0F172A),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.videocam_outlined,
//                     color: isDark ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                   onPressed: () {
//                     // TODO: Start video call
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.more_vert,
//                     color: isDark ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                   onPressed: () {
//                     // TODO: Show options menu
//                   },
//                 ),
//               ],
//             ),
//           ),
//
//           // ---------- CHAT MESSAGES ----------
//           Expanded(
//             child: Container(
//               color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.chat_bubble_outline,
//                       size: 64,
//                       color: isDark ? Colors.grey[700] : Colors.grey[300],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "Start chatting with ${widget.name}",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isDark ? Colors.grey[400] : Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // ---------- INPUT FIELD ----------
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF334155) : Colors.white,
//               border: Border(
//                 top: BorderSide(
//                   color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     // TODO: Attach file
//                   },
//                   icon: Icon(
//                     Icons.attach_file_rounded,
//                     color: isDark ? Colors.grey[400] : Colors.grey[600],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // TODO: Create poll
//                   },
//                   icon: Icon(
//                     Icons.poll_outlined,
//                     color: isDark ? Colors.grey[400] : Colors.grey[600],
//                   ),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: msgController,
//                     style: TextStyle(
//                       color: isDark ? Colors.white : Colors.black,
//                     ),
//                     decoration: InputDecoration(
//                       prefixIcon: IconButton(
//                         onPressed: () {
//                           // TODO: Pick image
//                         },
//                         icon: Icon(
//                           Icons.image_outlined,
//                           color: isDark ? Colors.grey[400] : Colors.grey[600],
//                         ),
//                       ),
//                       hintText: "Send a message...",
//                       hintStyle: TextStyle(
//                         color: isDark ? Colors.grey[500] : Colors.grey[500],
//                       ),
//                       filled: true,
//                       fillColor: isDark
//                           ? const Color(0xFF475569)
//                           : const Color(0xFFF1F5F9),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide(
//                           color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: const BorderSide(
//                           color: Color(0xff3B82F6),
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () async {
//                     if (msgController.text.trim().isEmpty) return;
//
//                     await chatC.sendMessage(
//                       widget.receiverId,
//                       msgController.text.trim(),
//                     );
//                     msgController.clear();
//                   },
//                   child: Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: isDark
//                           ? const Color(0xff2563eb)
//                           : const Color(0xffbfdbfe),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.send,
//                       color: isDark ? Colors.white : const Color(0xff1e40af),
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