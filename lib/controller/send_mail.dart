import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendInviteEmail(String receiverEmail, String userMessage) async {
  try {
    // 🔥 Your app deep link (optional)
    final deepLink = "myapp://invite";

    // 🔐 Gmail SMTP setup
    final smtpServer = gmail(
      "bikudog0786@gmail.com", // <-- Replace with your Gmail
      "zmgu ovps rxyc sivi", // <-- Replace with your Gmail App Password        
    );

    // 📩 Create email message
    final message = Message()
      ..from =
          Address("bikudog0786@gmail.com", "Venne App") // Email sender & name
      ..recipients.add(receiverEmail) // Friend email
      ..subject = "You got an invite!"
      ..html =
          """
  <p>$userMessage</p>
  <p><b>Click below to open the app:</b></p>
  <a href="myapp://invite">Open App</a>
""";

    // 🚀 SEND EMAIL
    await send(message, smtpServer);

    print("✅ Invite email successfully sent to $receiverEmail");
  } catch (e) {
    print("❌ ERROR sending email: $e");
  }
}
