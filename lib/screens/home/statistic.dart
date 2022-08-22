import 'package:flutter/material.dart';
import 'package:testweb2/helper/quiz_user.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key, required this.users}) : super(key: key);
  final List<QuizUser> users;
  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  int countUsersPass = 0;
  int countUsersFail = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.users.length; i++) {
      if (widget.users[i].score > 20)
        countUsersPass++;
      else
        countUsersFail++;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<QuizProvider>();
    final user = widget.users;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Số Lượng Người Sử Dụng Ứng Dụng:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(user.length.toString(),
              style: const TextStyle(fontSize: 30, color: Colors.red)),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Số Lượng Người Đậu Bài Thi Thử:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(countUsersPass.toString(),
              style: const TextStyle(fontSize: 30, color: Colors.red)),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Số Lượng Người Đậu Bài Thi Thử:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(countUsersFail.toString(),
              style: const TextStyle(fontSize: 30, color: Colors.red)),
        ],
      ),
    );
  }
}
