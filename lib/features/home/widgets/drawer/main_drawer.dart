import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Text DrawerTextStyle(String text, context) {
  return Text(
    text,
    style: TextStyle(
        color: Color(0xff2A5034), fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Container myDivider() {
  return Container(
    color: Colors.teal.withOpacity(0.3),
    height: 1,
  );
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: DrawerHeader(
                margin: EdgeInsets.all(0),
                child: Container(
                  child: Image.asset(
                    'assets/images/DrawerLogo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ListTile(
                      title: DrawerTextStyle("پروفایل",context),
                      leading: Icon(Icons.person),
                    ),
                    myDivider(),
                    ExpansionTile(
                      title: DrawerTextStyle(
                        "درباره من",
                        context,
                      ),
                      leading: Icon(Icons.info),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "سلام خیلی خوش اومدید! من امیررضام،\n یک عدد توسعه‌دهنده موبایل (:",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "امیدوارم از این برنامه لذت ببرید.",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "اگر پیشنهاد، نظر یا انتقادی دارید،",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "از طریق راه‌های ارتباطی با من در میون بذارید.",
                                style: TextStyle(fontSize: 16),
                              ),
                              // Add more about me information here
                            ],
                          ),
                        ),
                      ],
                    ),
                    myDivider(),
                    ExpansionTile(
                      title: DrawerTextStyle(
                        "راه ارتباطی",
                        context,
                      ),
                      leading: Icon(Icons.contact_mail),
                      children: const [
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          title: Text(
                            "ایمیل:\nsharifzadeamir80@gmail.com",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.telegram,
                            color: Colors.teal,
                          ),
                          title: Text(
                            "تلگرام:\n AmirSharif80@",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.computer,
                            color: Colors.teal,
                          ),
                          title: Text(
                            "لینکدین:\n www.linkedin.com/in/amirreza-sharifzade",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Add more contact information here
                      ],
                    ),
                    myDivider(),
                    ExpansionTile(
                      title: DrawerTextStyle(
                        "حمایت",
                        context,
                      ),
                      leading: Icon(Icons.assistant),
                      children: const [
                        ListTile(
                          leading: Icon(
                            Icons.favorite,
                            color: Colors.teal,
                          ),
                          title: Text(
                            "از طریق رسانه‌های اجتماعی من را دنبال کنید!",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Add more ways to support here
                      ],
                    ),
                    myDivider(),
                    ExpansionTile(
                      title: DrawerTextStyle(
                        "اشتراک ‌گذاری اپلیکیشن",
                        context,
                      ),
                      leading: Icon(Icons.share),
                      children: [
                        ListTile(
                          title: Text(
                            "این برنامه را با دوستان و آشنایانتون به اشتراک بگذارید",
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(
                            Icons.share,
                            color: Colors.teal,
                          ),
                          onTap: () {
                            Share.share(
                              "سلام! اپلیکیشن فوق‌العاده‌ای رو پیدا کردم به نام Time's Up! که واقعاً دوستش دارم. می‌توانید از فروشگاه اپل یا گوگل پلی اپ استور دانلودش کنید.",
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
