// ignore: file_names
import 'package:flutter/material.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Color.fromARGB(255, 174, 173, 173)
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Bible',
                  backgroundColor: Colors.white
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Discover',
                  backgroundColor: Color.fromARGB(255, 174, 173, 173)
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.0), // adjust as needed
              child: FloatingActionButton.small(
                onPressed: () {
                  // go to previous page of bible
                },
                child: const Icon(Icons.arrow_back_ios_rounded),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.0), // adjust as needed
              child: FloatingActionButton.small(
                onPressed: () {
                  // go to next page of bible
                },
                child: const Icon(Icons.arrow_forward_ios_rounded),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}