import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateGroupChat extends StatefulWidget {
  const CreateGroupChat({super.key});

  @override
  State<CreateGroupChat> createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_outlined,
              size: 22, color: Colors.black),
        ),
        title: const Text(
          'Tạo nhóm chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Tên nhóm: ',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    width: screenWidth * 0.55,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tên nhóm của bạn',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Thành viên: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    width: screenWidth * 0.55,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tên thành viên',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                width: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFd9a5b3), // Light Blue
                      Color(0xFF1868ae), // Greenink Purple
                      Color(0xFFc6d7eb), // Greenink Purple
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Hoàn thành',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Gợi ý',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // ListView.builder(itemBuilder: itemBuilder)
          ],
        ),
      ),
    );
  }
}
