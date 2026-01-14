import 'package:flutter/material.dart';

class PostDetailsItem extends StatelessWidget {
  final int id;
  final String title;
  final String body;

  const PostDetailsItem({
    super.key,
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('post_details:$id'),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            key: Key('post_details_title:$id'),
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(height: 10),
          Text(
            key: Key('post_details_body:$id'),
            body,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
