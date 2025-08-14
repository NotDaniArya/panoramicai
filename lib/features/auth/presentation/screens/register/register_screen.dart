import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _enteredFullName = '';
  String _enteredEmail = '';
  bool _isPasswordVisible = false;

  void _submitSignUp() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    // ref
    //     .read(authNotifierProvider.notifier)
    //     .register(
    //       name: _enteredFullName,
    //       email: _enteredEmail,
    //       password: _passwordController.text,
    //       passwordConfirm: _passwordController.text,
    //     );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
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
                      labelText: 'Username',
                      maxLength: 20,
                      icon: Icons.person,
                      minLength: 4,
                      inputType: TextInputType.name,
                      onSaved: (value) {
                        _enteredFullName = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      icon: Icons.phone,
                      maxLength: 12,
                      labelText: 'No. Hp',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      icon: Icons.email_rounded,
                      labelText: 'Email',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
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
                          return 'Panjang input minimal 8 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    SizedBox(
                      width: double.infinity,
                      child: MyButton(text: 'Register', onPressed: () {}),
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
