import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void PrivacyPolicy(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Effective Date: 29/12/2025',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey[400] : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // --- SCROLLABLE CONTENT ---
                  Expanded(
                    child: Container(
                      color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'At Venne, we believe your social life should be private, organized, and yours. '
                                    'This policy outlines how we handle your data across our features.',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // --- CARD 1 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _cardHeader(
                                      Icons.verified_outlined,
                                      const Color(0xff3B82F6),
                                      '1. Information We Collect',
                                      isDark,
                                    ),
                                    const SizedBox(height: 16),
                                    _policyBullet(
                                      title: 'Account Basics:',
                                      text: 'Name, email, phone number, and profile picture.',
                                      isDark: isDark,
                                    ),
                                    _policyBullet(
                                      title: 'User Content:',
                                      text: 'Plans, chat messages, "Moments", and Voice Notes.',
                                      isDark: isDark,
                                    ),
                                    _policyBullet(
                                      title: 'Contacts:',
                                      text: 'Hashes used for matching and then discarded.',
                                      boldNote: true,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- CARD 2 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _cardHeader(
                                      Icons.auto_awesome,
                                      const Color(0xff3B82F6),
                                      '2. Artificial Intelligence (Gemini)',
                                      isDark,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Venne uses Google Gemini to power smart features like:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _simpleBullet(
                                      'Smart Scheduling (Time suggestions).',
                                      isDark,
                                    ),
                                    _simpleBullet(
                                      'Trip Planning (Itineraries & Budgets).',
                                      isDark,
                                    ),
                                    _simpleBullet(
                                      'Content refinement (Message drafting).',
                                      isDark,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'How it works:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                          color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'When you use these features, prompt data is sent to Google API. ',
                                          ),
                                          TextSpan(
                                            text: 'We do not send private chat history for training.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- CARD 3 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _cardHeader(
                                      Icons.visibility_off_outlined,
                                      Colors.deepPurple,
                                      '3. Media & Content',
                                      isDark,
                                    ),
                                    const SizedBox(height: 16),
                                    _policyBullet(
                                      title: 'Moments & Broadcasts:',
                                      text: 'Photos and videos you upload are stored securely. You control the audience.',
                                      isDark: isDark,
                                    ),
                                    _policyBullet(
                                      title: 'Voice Notes:',
                                      text: 'Audio data is processed to generate transcripts but is not used for voice biometric identification.',
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- CARD 4 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _cardHeader(
                                      Icons.lock_outline,
                                      Colors.green,
                                      '4. Payment Information',
                                      isDark,
                                    ),
                                    const SizedBox(height: 16),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.6,
                                          color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'All payments for Venne+ subscriptions are processed by ',
                                          ),
                                          TextSpan(
                                            text: 'Stripe',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '. Venne never sees or stores your full credit card number. We only retain the subscription status (e.g., "Active", "Canceled").',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- CARD 5 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5. Data Sharing',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.6,
                                          color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'We do not sell your personal data. ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'We only share data with:',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _simpleBullet(
                                      'Service providers (Google, Stripe, Firebase) essential to app functionality.',
                                      isDark,
                                    ),
                                    _simpleBullet(
                                      'Legal authorities if required by a valid court order.',
                                      isDark,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- CARD 6 ---
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(isDark),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '6. Your Rights & Deletion',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'You can delete your account at any time via Settings. This action triggers a hard delete of your personal data, chats, and media from our active databases within 30 days.',
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[500] : Colors.grey,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Questions? Contact us at '),
                                      TextSpan(
                                        text: 'privacy@venne-app.com',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff3B82F6),
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            final Uri emailLaunchUri = Uri(
                                              scheme: 'mailto',
                                              path: 'privacy@venne-app.com',
                                            );
                                            try {
                                              await launchUrl(emailLaunchUri);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// --- Helper Widgets ---

BoxDecoration _cardDecoration(bool isDark) {
  return BoxDecoration(
    color: isDark ? const Color(0xFF334155) : Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: isDark
        ? null
        : [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Widget _cardHeader(IconData icon, Color color, String title, bool isDark) {
  return Row(
    children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    ],
  );
}

Widget _policyBullet({
  required String title,
  required String text,
  bool boldNote = false,
  required bool isDark,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
        ),
        children: [
          TextSpan(
            text: '$title ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          TextSpan(
            text: text,
            style: boldNote
                ? const TextStyle(fontWeight: FontWeight.w600)
                : null,
          ),
        ],
      ),
    ),
  );
}

Widget _simpleBullet(String text, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : const Color(0xFF4A5568),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
            ),
          ),
        ),
      ],
    ),
  );
}