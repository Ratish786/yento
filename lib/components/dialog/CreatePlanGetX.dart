// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/create_plan_controller.dart';
//
// void createNewPlanGetX() {
//   Get.dialog(const CreatePlanGetXDialog());
// }
//
// class CreatePlanGetXDialog extends StatelessWidget {
//   const CreatePlanGetXDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CreatePlanController());
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF334155) : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Create a new plan',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                         color: isDark ? Colors.white : const Color(0xFF0F172A),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Get.back(),
//                       icon: Icon(
//                         Icons.close,
//                         color: isDark ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
//                 const SizedBox(height: 20),
//
//                 // Title
//                 Text(
//                   'Plan Title',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : const Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: controller.titleController,
//                   style: TextStyle(
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: "What's the plan?",
//                     hintStyle: TextStyle(
//                       color: isDark ? Colors.grey[500] : Colors.grey[500],
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xff3B82F6),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Date & Time
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Obx(() => GestureDetector(
//                         onTap: controller.selectDate,
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isDark ? const Color(0xFF475569) : Colors.white,
//                             border: Border.all(
//                               color: isDark ? Colors.grey[700]! : Colors.grey,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.calendar_today,
//                                 size: 16,
//                                 color: isDark ? Colors.grey[400] : Colors.grey[600],
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
//                                 style: TextStyle(
//                                   color: isDark ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Obx(() => GestureDetector(
//                         onTap: controller.selectTime,
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isDark ? const Color(0xFF475569) : Colors.white,
//                             border: Border.all(
//                               color: isDark ? Colors.grey[700]! : Colors.grey,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.access_time,
//                                 size: 16,
//                                 color: isDark ? Colors.grey[400] : Colors.grey[600],
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute.toString().padLeft(2, '0')}",
//                                 style: TextStyle(
//                                   color: isDark ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Recurring
//                 Obx(() => Row(
//                   children: [
//                     Checkbox(
//                       value: controller.isRecurring.value,
//                       onChanged: (_) => controller.toggleRecurring(),
//                     ),
//                     Text(
//                       "Make this a recurring plan",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : const Color(0xFF0F172A),
//                       ),
//                     ),
//                   ],
//                 )),
//
//                 // Location
//                 const SizedBox(height: 20),
//                 Text(
//                   'Location (Optional)',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : const Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: controller.locationController,
//                   style: TextStyle(
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                   decoration: InputDecoration(
//                     hintStyle: TextStyle(
//                       color: isDark ? Colors.grey[500] : Colors.grey[500],
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xff3B82F6),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Notes
//                 const SizedBox(height: 20),
//                 Text(
//                   'Notes (optional)',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : const Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: controller.notesController,
//                   maxLines: 3,
//                   style: TextStyle(
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                   decoration: InputDecoration(
//                     hintStyle: TextStyle(
//                       color: isDark ? Colors.grey[500] : Colors.grey[500],
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xff3B82F6),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//                 Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
//                 const SizedBox(height: 16),
//
//                 // Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => Get.back(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: isDark
//                               ? const Color(0xFF475569)
//                               : Colors.grey[300],
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: isDark ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Obx(() => ElevatedButton(
//                         onPressed: controller.isLoading.value
//                             ? null
//                             : controller.createPlan,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff3B82F6),
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           disabledBackgroundColor: isDark
//                               ? const Color(0xFF475569)
//                               : Colors.grey[400],
//                         ),
//                         child: controller.isLoading.value
//                             ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                             : const Text(
//                           'Add Plan',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }