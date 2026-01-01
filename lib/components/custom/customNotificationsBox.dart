import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/create_plan_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomNotificationsBox extends StatelessWidget {
  const CustomNotificationsBox({super.key});

  @override
  Widget build(BuildContext context) {
    final planC = Get.find<CreatePlanController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.topCenter,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),

              // 🔥 INVITATION LIST
              Expanded(
                child: StreamBuilder<List<InvitationModel>>(
                  stream: planC.getPendingInvitations(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final invites = snapshot.data!;

                    if (invites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 60,
                              color: isDark ? Colors.grey[600] : Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No new notifications",
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: invites.length,
                      itemBuilder: (context, index) {
                        final invite = invites[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: isDark ? const Color(0xFF475569) : Colors.white,
                          elevation: isDark ? 0 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isDark
                                ? BorderSide(color: Colors.grey[700]!, width: 1)
                                : BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have a new plan invitation",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('SingupUsers')
                                      .doc(invite.ownerId)
                                      .get(),
                                  builder: (context, userSnapshot) {
                                    String senderName = 'Unknown User';
                                    if (userSnapshot.hasData &&
                                        userSnapshot.data!.exists) {
                                      final userData = userSnapshot.data!.data()
                                      as Map<String, dynamic>?;
                                      senderName =
                                          userData?['name'] ?? 'Unknown User';
                                    }
                                    return Text(
                                      "From: $senderName",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[300]
                                            : const Color(0xFF475569),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 10),

                                // ✅ ACTION BUTTONS
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xff10b981),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          planC.respondToInvite(
                                            ownerId: invite.ownerId,
                                            planId: invite.planId,
                                            response: "accepted",
                                          );
                                          Navigator.of(context).pop();
                                          Get.offAllNamed('/home');
                                        },
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xffef4444),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          planC.respondToInvite(
                                            ownerId: invite.ownerId,
                                            planId: invite.planId,
                                            response: "rejected",
                                          );
                                        },
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        color: isDark ? Colors.grey[400] : const Color(0xFF475569),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Mute",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : const Color(0xFF475569),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Clear All",
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : const Color(0xFF475569),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}