import 'package:flutter/material.dart';
import '../widgets/map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(),
        AppBar(
          title: const Text('Foodoid'),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.menu,),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ),
      ],
    );
  }
}
