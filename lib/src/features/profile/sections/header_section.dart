import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/models/user.dart';
import '../../../shared/utils/toast.dart';

class ProfileHeaderSection extends StatefulWidget {
  const ProfileHeaderSection({super.key});

  @override
  State<ProfileHeaderSection> createState() => _ProfileHeaderSectionState();
}

class _ProfileHeaderSectionState extends State<ProfileHeaderSection> {
  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = User.fake();
    _avatarPath = user.avatarPath;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _avatarPath = image.path;
        });
        showToast('Photo updated successfully!');
        // TODO: Upload to backend and save path
      }
    } catch (e) {
      showToast('Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = User.fake();
    final houseColor = _houseColor(user.houseId);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: houseColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
      child: Column(
        children: [
          // Avatar with camera overlay
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: _avatarPath != null
                    ? FileImage(File(_avatarPath!))
                    : null,
                child: _avatarPath == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Name
          Text(
            user.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          // Club Name (auto-assigned based on department)
          if (user.clubName != null && user.clubName!.isNotEmpty)
            Text(
              user.clubName!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Color _houseColor(String id) => switch (id) {
    'ruby' => Colors.red,
    'sapphire' => Colors.blue,
    'topaz' => Colors.orange,
    'emerald' => Colors.green,
    _ => Colors.indigo,
  };
}
