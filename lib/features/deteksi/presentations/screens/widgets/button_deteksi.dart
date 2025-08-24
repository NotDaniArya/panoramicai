import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class ButtonDeteksi extends StatefulWidget {
  const ButtonDeteksi({
    super.key,
    required this.label,
    required this.icon,
    this.isPrimary = false,
    this.isCamera = true,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isCamera;

  @override
  State<ButtonDeteksi> createState() => _ButtonDeteksiState();
}

class _ButtonDeteksiState extends State<ButtonDeteksi> {
  // File? _pickedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedImage == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Sesuaikan gambar',
          toolbarColor: TColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ), // Kunci rasio agar tetap persegi
        IOSUiSettings(
          title: 'Potong Gambar',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      // _pickedImageFile = File(croppedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: widget.isCamera
              ? () {
                  _pickImage(ImageSource.camera);
                }
              : () {
                  _pickImage(ImageSource.gallery);
                },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.isPrimary
                  ? TColors.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: widget.isPrimary
                  ? null
                  : Border.all(color: TColors.primaryColor, width: 3),
            ),
            child: Icon(
              widget.icon,
              color: widget.isPrimary ? Colors.white : TColors.primaryColor,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
