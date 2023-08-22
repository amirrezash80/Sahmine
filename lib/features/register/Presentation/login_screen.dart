import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sahmine/features/home/presentation/screen/home_screen.dart';
import 'package:sahmine/features/register/Presentation/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/gradient.dart';


class LoginScreen extends StatefulWidget {
  static const String routeName = "LoginScreen";
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // final supabase = Supabase.instance.client;

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {

      if (_boxLogin.get("loginStatus") ?? false) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }

    });


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // backgroundColor: Theme
        //     .of(context)
        //     .colorScheme
        //     .primaryContainer,
        body: Stack(
          children: [
            MyGradient(),
              Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    Text(
                      "خوش آمدید",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "وارد حساب کاربری خود شوید",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(height: 60),
                    TextFormField(

                      controller: _controllerUsername,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "نام کاربری",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onEditingComplete: () => _focusNodePassword.requestFocus(),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "لطفا نام کاربری را وارد کنید.";
                        } else if (_boxAccounts.get("username") != value ) {
                          return "نام کاربری ثبت نشده است.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controllerPassword,
                      focusNode: _focusNodePassword,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "رمز عبور",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: _obscurePassword
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "لطفا رمز عبور را وارد نمایید .";
                        } else if (value !=
                            _boxAccounts.get("password")) {
                          return "رمز اشتباه است.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 60),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              // final AuthResponse res = await supabase.auth.signInWithPassword(
                              //     email: _controllerUsername.text,
                              //     password: _controllerPassword.text
                              // );

                              _boxLogin.put("loginStatus", true);
                              _boxLogin.put("username", _controllerUsername.text);
                              _boxLogin.put("email" , _boxAccounts.get("email"));
                              _boxLogin.put("password" , _boxAccounts.get("password"));
                              Navigator.pushReplacementNamed(context, HomeScreen.routeName);

                            }
                          },
                          child: const Text("ورود"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("حساب کاربری ندارید؟"),
                            TextButton(
                              onPressed: () {
                                _formKey.currentState?.reset();
                                Navigator.pushNamed(context, SignupScreen.routeName);
                              },
                              child: const Text("ثبت نام"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}