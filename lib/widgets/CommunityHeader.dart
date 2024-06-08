import 'package:eargori/views/CreateArticleScreen.dart';
import 'package:flutter/material.dart';

class CommunityHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                width: 29,
                height: 40,
              ),
              SizedBox(width: 7), // Add this line
              const Text(
                '귀고리',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          _buildMoreButton(context),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);

  Widget _buildMoreButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.create_rounded),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateArticleScreen()));
      },
    );
  }
}
