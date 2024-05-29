import 'package:flutter/material.dart';

class DialoguePage extends StatelessWidget {
  const DialoguePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dialogue"),
        backgroundColor: Colors.amber,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris id nulla mauris. Nullam erat quam, varius id consequat vitae, lacinia ac orci. Sed ultrices ligula id enim consectetur, ut dictum felis blandit. Aliquam pulvinar lorem et viverra scelerisque. Nulla facilisi. Donec tristique ultricies purus et pulvinar. Aliquam sagittis libero lacus. Mauris vitae blandit ex, ac convallis turpis. Vestibulum non velit tellus. Mauris gravida vitae tortor id luctus. Nunc aliquet eu risus eget bibendum. Ut ut pharetra est. Sed pellentesque arcu est, ut interdum elit aliquam ac.",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
