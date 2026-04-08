import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/auth/presentations/controllers/auth_controller.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _enteredFullName = '';
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Form(
              key: _form,
              child: Container(
                margin: const EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: textTheme.headlineMedium!.copyWith(
                        color: TColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Image.asset(
                      'assets/images/logo_app.png',
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: TSizes.smallSpace),
                    TInputTextField(
                      controller: _fullNameController,
                      labelText: 'Username',
                      maxLength: 50,
                      icon: Icons.person,
                      minLength: 4,
                      inputType: TextInputType.name,
                      onSaved: (value) {
                        _enteredFullName = value!.trim();
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'The email field cannot be left blank';
                        }

                        if (!GetUtils.isEmail(value.trim())) {
                          return 'Invalid email format!';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!.trim();
                      },
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 70,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        isDense: true,
                      ),
                      maxLength: 15,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 8) {
                          return 'The minimum input length is 8 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _enteredPassword = value;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: MyButton(
                          child: controller.isLoading.value
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
                                  'Register',
                                  style: textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: () {
                            if (controller.isLoading.value) {
                              return;
                            }

                            final isValid = _form.currentState!.validate();

                            if (!isValid) {
                              return;
                            }

                            _form.currentState!.save();

                            controller.register(
                              email: _enteredEmail,
                              password: _enteredPassword,
                              fullName: _enteredFullName,
                            );
                          },
                        ),
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
