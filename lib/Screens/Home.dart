import 'package:flutter/material.dart';
import './Tabs/HomeTab.dart';
import './Tabs/PostTab.dart';
import './Tabs/ProfileTab.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    this.showWelcomePopup,
    this.tab,
  });

  bool showWelcomePopup = false;
  int tab;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.showWelcomePopup == true) {
        showWelcomePopup();
      } else {
        setState(() {
          switch (widget.tab) {
            case 0:
              tab = PostTab();
              break;
            case 1:
              tab = HomeTab();
              break;
            case 2:
              tab = ProfileTab();
              break;
            default:
          }
        });
      }
    });
  }

  void showWelcomePopup() {
    String text = '''
We're glad you're onboard with us! Here's how you can get started!

1) Add Your First Post
  -> Upon dismissing this popup, you'll be prompted to choose either video or image
  -> Select the type of media you want to choose
  -> Select the category of the violation using the dropdown
  -> Write a description of the violation
  -> Submit the violation to the traffic police by clicking the button!

Easy isn't it? You can view our top contributors through the leaderboard from Home tab.
View your recent posts from the home tab too!
    ''';

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        height: 470,
        decoration: BoxDecoration(
          color: Color(0xFF4b4266),
          border: Border.all(
            color: Color(0xFFff79c6),
            width: 3.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Welcome To RoadLance!',
                style: TextStyle(
                  color: Color(0xFF50fa7b),
                  fontFamily: 'Karla-Medium',
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Karla-Medium',
                    fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      print("Modal closed!");
      setState(() {
        tab = PostTab();
      });
    });
  }

  int _selectedIndex = 0;
  Widget tab;

  void onItemTapped(int index) {
    print("New index is $index");
    setState(() {
      _selectedIndex = index;
    });
    setState(() {
      switch (_selectedIndex) {
        case 0:
          tab = PostTab();
          break;
        case 1:
          tab = HomeTab();
          break;
        case 2:
          tab = ProfileTab();
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab,
      backgroundColor: Color(0xFF4b4266),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF282a36),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
