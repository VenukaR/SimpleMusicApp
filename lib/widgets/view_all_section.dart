import 'package:flutter/material.dart';



class ViewAllSection extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final VoidCallback onPressed;

  const ViewAllSection({super.key, required this.title, this.buttonTitle = "", required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),

          TextButton(onPressed: onPressed , child: Text(
                buttonTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11),
              ))
        ],
      ),
    );
  }
}
