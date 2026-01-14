import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final int id;
  final String title;
  final String body;
  final VoidCallback onTap;

  const PostItem({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        key: Key('post_item:$id'),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: Key("post_item_title:$id"),
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(key: Key("post_item_body:$id"), body),
            Container(height: 10),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
