import 'package:flutter/material.dart';

class ComplaintImage extends StatefulWidget {
  final String imageUrl;
  const ComplaintImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ComplaintImage> createState() => _ComplaintImageState();
}

class _ComplaintImageState extends State<ComplaintImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b4850),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b4850),
        title: const Text("Complaint Image",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Image.network(widget.imageUrl),
        ),
      ),
    );
  }
}
