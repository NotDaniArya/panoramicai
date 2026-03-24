import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panoramicai/utils/shared_widgets/profile_image_picker.dart';

import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_widgets/button.dart';
import '../../../../utils/shared_widgets/input_text_field.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.put(UserProfileController());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.tanggalLahirController.text = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: TColors.primaryColor),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Image Picker
                  Obx(
                    () => ProfileImagePicker(
                      initialImageUrl:
                          controller.userProfile.value?.photoUrl ?? '',
                      onImageSelected: (image) {
                        controller.selectedImage.value = image;
                      },
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  TInputTextField(
                    controller: controller.fullNameController,
                    labelText: 'Nama Lengkap',
                    icon: Icons.person_outline,
                    inputType: TextInputType.name,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TInputTextField(
                        controller: controller.tanggalLahirController,
                        labelText: 'Tanggal Lahir',
                        icon: Icons.cake_outlined,
                        inputType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TInputTextField(
                    controller: controller.institusiController,
                    labelText: 'Institusi',
                    maxLength: 50,
                    icon: Icons.business_outlined,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TInputTextField(
                    controller: controller.npaController,
                    labelText: 'NPA (Nomor Pokok Anggota PDGI)',
                    minLength: 4,
                    icon: Icons.badge_outlined,
                    inputType: TextInputType.number,
                  ),

                  const SizedBox(height: 40),

                  Obx(
                    () => MyButton(
                      child: controller.isUpdating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: TColors.primaryColor,
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : Text(
                              'Simpan Perubahan',
                              style: textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      onPressed: () => controller.isUpdating.value
                          ? null
                          : controller.updateUserProfile(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
