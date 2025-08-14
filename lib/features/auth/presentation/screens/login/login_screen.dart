import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPass = '';
  bool _isPasswordVisible = false;

  void _submitLogin() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    // ref
    //     .read(authNotifierProvider.notifier)
    //     .login(email: _enteredEmail, password: _enteredPass);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
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
                Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                            return 'Panjang input minimal 8 karakter';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _enteredPass = value!;
                        },
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Lupa password?',
                            textAlign: TextAlign.end,
                            style: textTheme.bodyMedium!.copyWith(
                              color: TColors.secondaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: 250,
                  child: MyButton(text: 'Login', onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
