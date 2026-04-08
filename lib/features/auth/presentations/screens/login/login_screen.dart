import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/navigation_menu.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  String _enteredEmail = '';
  String _enteredPass = '';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
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
                const SizedBox(height: TSizes.spaceBtwSections),
                Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Email is invalid';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
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
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                              value.trim().length <= 8) {
                            return 'The minimum input length is 8 characters';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _enteredPass = value!;
                        },
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Obx(
                  () => SizedBox(
                    width: 250,
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
                              'Login',
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

                        controller.signInWithEmail(
                          email: _enteredEmail,
                          password: _enteredPass,
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
    );
  }
}
