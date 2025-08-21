import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_widgets/button.dart';
import '../../../../utils/shared_widgets/input_text_field.dart';
import '../../../../utils/shared_widgets/profile_image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data profil yang ada
    _fullNameController = TextEditingController(text: 'User');
    _phoneController = TextEditingController(text: '082323232323');
    _addressController = TextEditingController(text: 'Jalan Kenangan');
    _cityController = TextEditingController(text: 'Kayangan');
  }

  @override
  void dispose() {
    // dispose controller supaya tidak memory leak
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitEditProfile() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profil', style: textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _form,
              child: Container(
                margin: const EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // widget profile image picker
                    ProfileImagePicker(
                      initialImageUrl:
                          'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                      onImageSelected: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      controller: _fullNameController,
                      labelText: 'Nama Lengkap',
                      maxLength: 100,
                      minLength: 4,
                      icon: Icons.person,
                      inputType: TextInputType.name,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _phoneController,
                      labelText: 'Nomor Hp',
                      icon: Icons.call,
                      maxLength: 12,
                      minLength: 10,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _addressController,
                      labelText: 'Alamat',
                      maxLength: 50,
                      icon: Icons.home,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _cityController,
                      labelText: 'Kota asal',
                      maxLength: 50,
                      icon: Icons.location_city,
                      inputType: TextInputType.text,
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: 250,
                      child: MyButton(
                        text: 'Simpan Perubahan',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
