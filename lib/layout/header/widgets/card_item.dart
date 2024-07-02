// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isUnview;
  final int numberUnview;
  final bool isSelected;
  const CardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isUnview,
    required this.numberUnview,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 0),
      decoration: BoxDecoration(
        borderRadius:
            isSelected ? BorderRadius.circular(12) : BorderRadius.zero,
        color: isSelected ? Colors.grey.shade200 : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // icon
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // title
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // icon notification
              isUnview
                  ? Container(
                      height: 20,
                      constraints: const BoxConstraints(minWidth: 25),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          '$numberUnview',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
