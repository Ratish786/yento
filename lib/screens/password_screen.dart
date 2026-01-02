import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/pass_controller.dart';
import 'homescreen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPin = "";
  final PassController passC = Get.put(PassController());

  void onKeyTap(String value) async {
    if (enteredPin.length >= 4) return;

    setState(() {
      enteredPin += value;
    });

    if (enteredPin.length == 4) {
      final isCorrect = await passC.verifyPin(enteredPin);

      if (isCorrect) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Get.snackbar(
          'Incorrect PIN',
          'Password is incorrect or not matched',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() => enteredPin = "");
      }
    }
  }

  void onBackspace() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  Widget pinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.all(6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < enteredPin.length
                ? Colors.black
                : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget numberButton(String number) {
    return GestureDetector(
      onTap: () => onKeyTap(number),
      child: Container(
        alignment: Alignment.center,
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget backspaceButton() {
    return GestureDetector(
      onTap: onBackspace,
      child: Container(
        alignment: Alignment.center,
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(Icons.backspace_outlined),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // 🔒 Lock Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock, size: 30, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            const Text(
              "Enter PIN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Enter your 4-digit PIN to unlock Yento.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // 🔘 PIN dots
            pinDots(),

            const SizedBox(height: 40),

            // 🔢 Keypad
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map(numberButton).toList(),
                      ),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 70),
                      numberButton('0'),
                      backspaceButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
