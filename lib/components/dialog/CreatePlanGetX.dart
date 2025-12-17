// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/create_plan_controller.dart';

// void createNewPlanGetX() {
//   Get.dialog(const CreatePlanGetXDialog());
// }

// class CreatePlanGetXDialog extends StatelessWidget {
//   const CreatePlanGetXDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CreatePlanController());
    
//     return Dialog(
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Create a new plan',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                   ),
//                   IconButton(
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
              
//               const Divider(),
//               const SizedBox(height: 20),
              
//               // Title
//               const Text('Plan Title', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: controller.titleController,
//                 decoration: InputDecoration(
//                   hintText: "What's the plan?",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Date & Time
//               Row(
//                 children: [
//                   Expanded(
//                     child: Obx(() => GestureDetector(
//                       onTap: controller.selectDate,
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
//                         ),
//                       ),
//                     )),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Obx(() => GestureDetector(
//                       onTap: controller.selectTime,
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute.toString().padLeft(2, '0')}",
//                         ),
//                       ),
//                     )),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 20),
              
//               // Recurring
//               Obx(() => Row(
//                 children: [
//                   Checkbox(
//                     value: controller.isRecurring.value,
//                     onChanged: (_) => controller.toggleRecurring(),
//                   ),
//                   const Text("Make this a recurring plan", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               )),
              
//               // Location
//               const SizedBox(height: 20),
//               const Text('Location (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: controller.locationController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
              
//               // Notes
//               const SizedBox(height: 20),
//               const Text('Notes (optional)', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: controller.notesController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
              
//               const SizedBox(height: 20),
//               const Divider(),
              
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => Get.back(),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
//                     child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//                   ),
//                   Obx(() => ElevatedButton(
//                     onPressed: controller.isLoading.value ? null : controller.createPlan,
//                     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff3b82f6)),
//                     child: controller.isLoading.value
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text('Add Plan', style: TextStyle(color: Colors.white)),
//                   )),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }