import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sahmine/features/register/Presentation/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "ProfileScreen";

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, String> updatedValues = {};

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = _boxLogin.get("username");
    emailController.text = _boxLogin.get("email");
    passwordController.text = _boxLogin.get("password");
  }

  Future<void> _showConfirmationDialog(
      String action, VoidCallback onConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تایید عملیات'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('آیا از انجام این کار اطمینان دارید؟'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('خیر'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('بله'),
                onPressed: () {
                  onConfirmed();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.teal,
            expandedHeight: size.height * 0.3,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'حساب کاربری',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              background: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    child: Image.asset(
                      'assets/images/watercolor.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: size.height * 0.1,
                      backgroundImage:
                          AssetImage("assets/images/LightLogo.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'نام کاربری'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'ایمیل'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'رمز عبور',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog(
                          'ذخیره تغییرات',
                          () {
                            setState(() {
                              _boxLogin.put(
                                  "username", usernameController.text);
                              _boxLogin.put("email", emailController.text);
                              _boxLogin.put(
                                  "password", passwordController.text);
                              _boxAccounts.put(
                                  "username", usernameController.text);
                              _boxAccounts.put("email", emailController.text);
                              _boxAccounts.put(
                                  "password", passwordController.text);
                              // Update any other user data fields as needed
                              updatedValues = {
                                "username": usernameController.text,
                                "email": emailController.text,
                                "password": passwordController.text,
                              };
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text("اطلاعات شما به‌روزرسانی شد.")),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("ذخیره تغییرات"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            _showConfirmationDialog(
              'خروج از حساب',
              () {
                _boxLogin.put("loginStatus", false);
                // Delay for 500 milliseconds before navigating to LoginScreen
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                });
              },
            );
          },
          child: Text(
            "خروج از حساب",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
