import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/PrivacyPolicy.dart';
import 'package:yento_app/components/custom/TermsOfServices.dart';
import 'package:yento_app/controller/auth_controller.dart';
import 'package:yento_app/controller/theme_controller.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeC = Get.find<ThemeController>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeC.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5FF);
      final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
      final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
      final subtextColor = isDark ? const Color(0xFF94A3B8) : Colors.black54;
      final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
      final inputBg = isDark ? const Color(0xFF0F172A) : Colors.white;

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'V',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your inner circle, in sync.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        _buildLabel("Full Name", textColor),
                        _buildTextField(
                          nameController,
                          "Enter your full name",
                          inputBg,
                          borderColor,
                          textColor,
                          subtextColor,
                          prefixIcon: Icons.person_outline,
                          validator: (v) =>
                          v!.length < 3 ? "Name too short" : null,
                        ),

                        // Email
                        _buildLabel("Email Address", textColor),
                        _buildTextField(
                          emailController,
                          "Enter your email",
                          inputBg,
                          borderColor,
                          textColor,
                          subtextColor,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (v) =>
                          !v!.contains("@") ? "Invalid email" : null,
                        ),

                        // Phone
                        _buildLabel("Phone Number", textColor),
                        _buildTextField(
                          phoneController,
                          "Enter phone number",
                          inputBg,
                          borderColor,
                          textColor,
                          subtextColor,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: (v) =>
                          v!.length != 10 ? "Invalid phone number" : null,
                        ),

                        // Password
                        _buildLabel("Password", textColor),
                        _buildTextField(
                          passController,
                          "Create a password",
                          inputBg,
                          borderColor,
                          textColor,
                          subtextColor,
                          isObscure: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: subtextColor,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (v) =>
                          v!.length < 6 ? "Password too short" : null,
                        ),

                        // Confirm Password
                        _buildLabel("Confirm Password", textColor),
                        _buildTextField(
                          confirmPassController,
                          "Confirm your password",
                          inputBg,
                          borderColor,
                          textColor,
                          subtextColor,
                          isObscure: _obscureConfirmPassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: subtextColor,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (v) => v != passController.text
                              ? "Passwords don't match"
                              : null,
                        ),

                        const SizedBox(height: 30),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Obx(() => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            onPressed: authController.isLoading.value
                                ? null
                                : () {
                              if (formKey.currentState!.validate()) {
                                authController.signup(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  phoneController.text.trim(),
                                  passController.text.trim(),
                                );
                              }
                            },
                            child: authController.isLoading.value
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                        ),

                        const SizedBox(height: 24),

                        // Terms Text
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "By creating an account, you agree to our\n",
                              style: TextStyle(
                                fontSize: 12,
                                color: subtextColor,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms of Service",
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => TermsOfServices(context),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(color: subtextColor),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => PrivacyPolicy(context),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In Link
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subtextColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Helper widgets
  Widget _buildLabel(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: color,
      ),
    ),
  );

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      Color inputBg,
      Color borderColor,
      Color textColor,
      Color hintColor, {
        bool isObscure = false,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        IconData? prefixIcon,
        Widget? suffixIcon,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          filled: true,
          fillColor: inputBg,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: hintColor, size: 20)
              : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}