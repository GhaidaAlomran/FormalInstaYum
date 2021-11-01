import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum1/model/user.dart';
import 'package:instayum1/utils/user_preferences.dart';
import 'package:instayum1/widget/followers_numbers.dart';
import 'package:instayum1/widget/profile_widget.dart';
import 'my_mealplans_screen.dart';
import 'my_recipes_screen.dart';
import 'bookmarks_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:user_profile_example/widget/button_widget.dart'; // if we will add button of follow

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String userUsername = "";
  String imageURL = "";

//getData() to get the data of users like username, image_url from database
  void getData() async {
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        userUsername = userData.data()['username'];
        imageURL = userData.data()['image_url'];
      });
    });
  }

  void initState() {
    super.initState();
    getData(); //we call the method here to get the data immediately when init the page.
  }

  Widget build(BuildContext context) {
    //  final cookingEnthusist = UserPreferences.myCooking_Enthusiast;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  buildImage(),
                  // ProfileWidget(
                  //   imagePath: cookingEnthusist.imagePath,
                  //   onClicked: () async {},
                  // ),
                  Text(
                    userUsername,
                    style: TextStyle(fontSize: 17, fontFamily: 'Open Sans'),
                  ),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: FollowersNumbers(),
              ),
              SizedBox(height: 15.0),
              DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Building the tab bar
                    TabBar(
                      labelColor: Color(0xFFeb6d44),
                      indicatorColor: Color(0xFFeb6d44),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.assignment_rounded),
                          text: ("My recipe"),
                        ),
                        Tab(
                          icon: Icon(Icons.table_view),
                          text: ("My meal plans"),
                        ),
                        Tab(
                          icon: Icon(Icons.bookmark),
                          text: ("Bookmarks"),
                        ),
                      ],
                    ),
                    Container(
                      height: 300, //height of TabBarView
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      // assign my recipes pages ,my_meal_plans
                      child: TabBarView(
                        children: <Widget>[
                          my_recipes(),
                          my_meal_plans(),
                          bookmarked_recipes(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildName(cooking_Enthusiast user) => Container(
  //       margin: EdgeInsets.all(10),
  //       child: Column(
  //         children: [
  //           Text(
  //             user.name,
  //             style: TextStyle(fontSize: 17, fontFamily: 'Open Sans'),
  //           ),
  //         ],
  //       ),
  //     );

  Widget buildImage() {
    final image = imageURL == "noImage"
        ? AssetImage("assets/images/defaultUser.png") // NEW
        : NetworkImage(imageURL);

    return ClipOval(
      child: Material(
        color: Colors.grey.shade400,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 100,
          height: 100,

          // child:
          //     InkWell(onTap: widget.onClicked), // i suggest to delete the edit.
        ),
      ),
    );
  }
}
