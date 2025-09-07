import 'package:flutter/material.dart';
import 'package:students/screens/books/books.dart';
import 'package:students/screens/logbook/logbook.dart';
import 'package:students/services/apis/books_apis.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _controller = PageController();
  int _selected = 0;

  @override
  void initState() {
    // TODO: implement initState
    blogServices.getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          Books(),
          LogBooks(),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // iconSize: 32,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: Image(
              width: 32,
              height: 32,
              color: Colors.grey,
              image: AssetImage("assets/icons/books.png"),
            ),
            title: const Text('Books',style: TextStyle(fontFamily: "OpenSans"),),
            backgroundColor: colors.umber,
            selectedIcon: Image(
              width: 32,
              height: 32,
              image: AssetImage("assets/icons/books.png"),
            ),
          ),
          BottomBarItem(
            icon: Image(
              width: 27,
              height: 27,
              color: Colors.grey,
              image: AssetImage("assets/icons/requests.png"),
            ),
            title: const Text('Requests',style: TextStyle(fontFamily: "OpenSans"),),
            backgroundColor: colors.umber,
            selectedIcon: Image(
              width: 27,
              height: 27,
              image: AssetImage("assets/icons/requests.png"),
            ),
          ),
        ],
        fabLocation: StylishBarFabLocation.center,
        hasNotch: false,
        currentIndex: _selected,
        onTap: (index) {
          setState(() {
            _selected = index;
            _controller.jumpToPage(index);
          });
        },
      )
    );
  }
}
