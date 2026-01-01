import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void TermsOfServices(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    // Drag Handle
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

                    // Header
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms of Service',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Last Updated: 29/12/2025',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Blue Info Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1e3a8a)
                                    : const Color(0xFFF0F6FF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF2563eb)
                                      : const Color(0xFFD6E4FF),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: isDark
                                        ? const Color(0xFF60a5fa)
                                        : const Color(0xFF4F7CFF),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'By using Venne, you agree to these terms. Please read them carefully, especially the sections regarding AI usage and subscriptions.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1F3A8A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Section 1
                            SectionTitle(
                              '1. Artificial Intelligence (AI) Services',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            SectionText(
                              'Venne utilizes artificial intelligence technologies, including Google Gemini, to provide features such as travel itineraries, budget estimates, local guides, and message suggestions ("AI Output").',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),

                            // Disclaimer Box
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF7f1d1d)
                                    : const Color(0xFFFFF1F1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color: isDark
                                        ? const Color(0xFFef4444)
                                        : const Color(0xFFEF4444),
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : const Color(0xFF7F1D1D),
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Disclaimer of Accuracy: ',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text:
                                      'AI Output is generated automatically and may be inaccurate, outdated, or offensive. You acknowledge that Venne does not verify the accuracy of AI Output. You should independently verify all travel details before relying on them.',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : const Color(0xFF475569),
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'No Liability: ',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                    text:
                                    'Venne is not liable for any losses, missed flights, financial discrepancies, or safety issues resulting from your reliance on AI Output.',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                            SectionTitle(
                              '2. Subscriptions and Payments (Venne+)',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            SectionText(
                              'Certain features require a paid subscription ("Venne+").',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),

                            _BulletItem(
                              title: 'Billing:',
                              text: 'Payments are processed securely via Stripe.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: 'Renewal:',
                              text: 'Subscriptions automatically renew unless canceled.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: 'Cancellation:',
                              text:
                              'You may cancel anytime. Access continues until end of billing period.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: 'Refunds:',
                              text:
                              'Payments are generally non-refundable, except as required by law.',
                              isDark: isDark,
                            ),

                            const SizedBox(height: 32),
                            SectionTitle(
                              '3. User Content & Conduct',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            SectionText(
                              'You retain ownership of your content but grant Venne a license to display it.',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'You agree NOT to:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 5),

                            _BulletItem(
                              title: '',
                              text: 'Use the app for illegal purposes.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: '',
                              text: 'Harass, bully, or intimidate other users.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: '',
                              text:
                              'Upload malware or violate intellectual property rights.',
                              isDark: isDark,
                            ),
                            _BulletItem(
                              title: '',
                              text: 'Reverse-engineer the app or AI integrations.',
                              isDark: isDark,
                            ),

                            const SizedBox(height: 10),
                            Text(
                              'We may suspend violating accounts without notice.',
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? Colors.grey[300]
                                    : const Color(0xFF475569),
                              ),
                            ),

                            const SizedBox(height: 32),
                            SectionTitle(
                              '4. Affiliate Links & Third-Party Services',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            SectionText(
                              'Some booking links are affiliate links. We earn commission on bookings.',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 5),
                            SectionText(
                              'We are not responsible for third-party services.',
                              isDark: isDark,
                            ),

                            const SizedBox(height: 32),
                            SectionTitle(
                              '5. Limitation of Liability',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            SectionText(
                              'To the maximum extent permitted by law, Venne shall not be liable for indirect, incidental, or consequential damages.',
                              isDark: isDark,
                            ),

                            const SizedBox(height: 32),
                            SectionTitle('6. Contact Us', isDark: isDark),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                  fontSize: 15,
                                ),
                                children: [
                                  const TextSpan(text: 'Questions? Email us at '),
                                  TextSpan(
                                    text: 'legal@venne-app.com',
                                    style: const TextStyle(
                                      color: Color(0xff3B82F6),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final uri = Uri(
                                          scheme: 'mailto',
                                          path: 'legal@venne-app.com',
                                        );
                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(uri);
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// Reusable widgets to reduce repetition
class SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  const SectionTitle(this.text, {super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  final bool isDark;
  const SectionText(this.text, {super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: isDark ? Colors.grey[300] : const Color(0xFF475569),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String title;
  final String text;
  final bool isDark;
  const _BulletItem({
    required this.title,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.grey[400] : const Color(0xFF475569),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? Colors.grey[300] : const Color(0xFF475569),
                ),
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}