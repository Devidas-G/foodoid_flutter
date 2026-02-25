import 'package:flutter/material.dart';
import '../widgets/map_widget.dart';
import '../widgets/round_icon_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            // Add some spacing
            RoundIconButton(
              icon: Icons.search,
              onPressed: () {
                // Handle search button press
              },
            ),
            SizedBox(width: 8), // Add some spacing
            RoundIconButton(
              icon: Icons.settings,
              onPressed: () {
                // Handle filter button press
              },
            ),
          ],
        ),
        actions: [
          RoundIconButton(
            icon: Icons.notifications,
            onPressed: () {
              // Handle notifications button press
            },
          ),
          SizedBox(width: 8), // Add some spacing
          RoundIconButton(
            icon: Icons.message,
            onPressed: () {
              // Handle message button press
            },
          ),
          SizedBox(width: 8), // Add some spacing
          RoundIconButton(
            icon: Icons.account_circle,
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
      body: Stack(
        children: [
          MapWidget(),

          /// 2️⃣ Top Controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text("data"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          // Handle FAB press
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
