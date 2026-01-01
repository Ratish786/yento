import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:yento_app/controller/brodcast_controller_y.dart';

class CreateMomentDialog extends StatefulWidget {
  const CreateMomentDialog({super.key});

  @override
  State<CreateMomentDialog> createState() => _CreateMomentDialogState();
}

class _CreateMomentDialogState extends State<CreateMomentDialog> {
  final TextEditingController _captionController = TextEditingController();
  final MomentServices _momentServices = MomentServices();
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  File? _selectedImage; // Store selected image file
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String _visibilityLabel = 'Everyone';
  String _linkPlanLabel = 'Link Plan';

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // Pick image from gallery or camera
  Future<void> _pickImage() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff1e3a8a)
                      : const Color(0xffdbeafe),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: isDark ? const Color(0xff60a5fa) : const Color(0xff2563eb),
                ),
              ),
              title: Text(
                'Camera',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (image != null) {
                  setState(() {
                    _selectedImage = File(image.path);
                    // If you need to upload to storage and get URL:
                    // _imageUrl = await uploadImageToStorage(_selectedImage!);
                  });
                }
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff065f46)
                      : const Color(0xffdcfce7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: isDark ? const Color(0xff34d399) : const Color(0xff16a34a),
                ),
              ),
              title: Text(
                'Gallery',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (image != null) {
                  setState(() {
                    _selectedImage = File(image.path);
                    // If you need to upload to storage and get URL:
                    // _imageUrl = await uploadImageToStorage(_selectedImage!);
                  });
                }
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF7f1d1d)
                        : const Color(0xFFfee2e2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Color(0xFFef4444),
                  ),
                ),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _imageUrl = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePost() async {
    final caption = _captionController.text.trim();

    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something to post.')),
      );
      return;
    }

    if (_uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post.')),
      );
      return;
    }

    try {
      // TODO: Upload image to Firebase Storage first if _selectedImage is not null
      // String? uploadedImageUrl;
      // if (_selectedImage != null) {
      //   uploadedImageUrl = await uploadImageToStorage(_selectedImage!);
      // }

      await _momentServices.addMoment(_uid!, _imageUrl, caption);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add moment: $e')),
      );
    }
  }

  void _showVisibilityBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String tempSelection = _visibilityLabel;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Who can see this?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.grey[400] : const Color(0xff6b7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Everyone option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        tempSelection = 'Everyone';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff065f46)
                            : const Color(0xffdcfce7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xff16a34a),
                            child: Icon(
                              Icons.public,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Everyone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'Visible to all your contacts.',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[300] : const Color(0xff6b7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (tempSelection == 'Everyone')
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xff16a34a),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Circles section
                  Text(
                    'MY CIRCLES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[500] : const Color(0xff6b7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No circles available yet.',
                        style: TextStyle(
                          color: isDark ? Colors.grey[500] : const Color(0xff9ca3af),
                        ),
                      ),
                    ),
                  ),

                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _visibilityLabel = tempSelection;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xff3B82F6)
                            : const Color(0xff111827),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLinkPlanBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String tempSelection = _linkPlanLabel;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tag an Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.grey[400] : const Color(0xff6b7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // None option
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        tempSelection = 'None';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff78350f)
                            : const Color(0xfffff7ed),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xfff59e0b),
                            child: Icon(
                              Icons.link_off,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'None',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  "Don't tag any event.",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[300] : const Color(0xff6b7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (tempSelection == 'None')
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xfff59e0b),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Empty space
                  Expanded(
                    child: Center(
                      child: Text(
                        'No events available yet.',
                        style: TextStyle(
                          color: isDark ? Colors.grey[500] : const Color(0xff9ca3af),
                        ),
                      ),
                    ),
                  ),

                  // Done button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _linkPlanLabel = tempSelection;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xff3B82F6)
                            : const Color(0xff111827),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: width * 0.95,
        height: height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.grey[400] : const Color(0xff6b7280),
                    ),
                  ),
                  Text(
                    'New Moment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xff111827),
                    ),
                  ),
                  TextButton(
                    onPressed: _handlePost,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      backgroundColor: isDark
                          ? const Color(0xff3B82F6)
                          : const Color(0xff9ca3af),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),

            // ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar + Caption
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://fastly.picsum.photos/id/570/1200/400.jpg?hmac=yJRcaq6hiuStbSfeYJ-2ADujgsZNvzxXR1yIdwo_6nM',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _captionController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark ? Colors.white : const Color(0xff111827),
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: "What's the vibe?",
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: isDark ? Colors.grey[500] : const Color(0xff9ca3af),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Image Preview
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = null;
                                    _imageUrl = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ================= BOTTOM ACTION BAR =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey[700]! : const Color(0xffe5e7eb),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _momentActionChip(
                    icon: Icons.image_outlined,
                    label: _selectedImage != null ? 'Change' : 'Media',
                    fg: isDark ? const Color(0xff60a5fa) : const Color(0xff2563eb),
                    bg: isDark ? const Color(0xff1e3a8a) : const Color(0xffdbeafe),
                    onTap: _pickImage,
                  ),
                  const SizedBox(width: 8),
                  _momentActionChip(
                    icon: Icons.groups_2_outlined,
                    label: _visibilityLabel,
                    fg: isDark ? const Color(0xff34d399) : const Color(0xff16a34a),
                    bg: isDark ? const Color(0xff065f46) : const Color(0xffdcfce7),
                    onTap: _showVisibilityBottomSheet,
                  ),
                  const SizedBox(width: 8),
                  _momentActionChip(
                    icon: Icons.calendar_today_outlined,
                    label: _linkPlanLabel,
                    fg: isDark ? Colors.grey[400]! : const Color(0xff6b7280),
                    bg: isDark ? const Color(0xFF475569) : const Color(0xffe5e7eb),
                    onTap: _showLinkPlanBottomSheet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentActionChip({
    required IconData icon,
    required String label,
    required Color fg,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}