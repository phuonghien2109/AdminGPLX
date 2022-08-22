import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/provider/quiz_provider.dart';
import 'package:testweb2/screens/home/home.dart';
import 'package:testweb2/screens/home/statistic.dart';
import 'package:testweb2/screens/sign_in.dart';
import 'package:testweb2/screens/traffic_signs/traffic_signs_screen.dart';
import 'package:testweb2/services/auth_service.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kColor,
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            height: 40,
            alignment: Alignment.topCenter,
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            'Quản Lý Ôn Tập GPLX',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          MenuItem(
            title: 'Trang Chủ',
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
            },
          ),
          MenuItem(
            title: 'Biển Báo',
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrafficSigns(),
                  ));
            },
          ),
          MenuItem(
            title: 'Thống kê',
            press: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Statistic(
                          users: provider.users,
                        ),
                      ),
                    );
                  });
            },
          ),
          MenuItem(
            title: 'Đăng xuất',
            press: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAboutDialog(context),
              );
            },
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget _buildAboutDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Đăng Xuất'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Bạn có muốn đăng xuất không?'),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Hủy'),
      ),
      TextButton(
        onPressed: () {
          AuthService().signOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ));
        },
        child: const Text('Đăng Xuất'),
      ),
    ],
  );
}
