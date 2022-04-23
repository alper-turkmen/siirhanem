import 'package:denemeler_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:denemeler_1/constants/color_constant.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  void initState() {
    super.initState();
    getCurrentUser();
  }

  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        Route route = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.push(context, route);
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Şiirhanem',
                        style: GoogleFonts.gentiumBookBasic(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(

                      'Keşfedilmemiş harika şiirler okuyun ve dinleyin.',
                      cursor: '|',
                      textStyle: GoogleFonts.gentiumBookBasic(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),
                      speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Yazdığınız şiirleri paylaşın.',
                      cursor: '|',
                      textStyle: GoogleFonts.gentiumBookBasic(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),     speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Şiirleri sesli dinleyin.',
                      cursor: '|',
                      textStyle: GoogleFonts.gentiumBookBasic(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),  speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Şiirleri yorumlayın. Alıntıları paylaşın. Muhteşem insanlarla tanışın.',
                      cursor: '|',
                      textStyle: GoogleFonts.gentiumBookBasic(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor),  speed: Duration(milliseconds: 100),
                    ),
                  ],
                  onTap: () {},
                ),
              ),
              Container(
                height: 39,
                margin: EdgeInsets.only(left: 25, right: 25, top: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kLightGreyColor),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      onChanged: (value){
                        email = value;
                      },
                      maxLengthEnforced: true,
                      style: TextStyle(
                          fontSize: 12,
                          color: kBlackColor,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.only(left: 19, right: 50, bottom: 8),
                          border: InputBorder.none,
                          hintText: 'E-Posta',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: kGreyColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Container(
                height: 39,
                margin: EdgeInsets.only(left: 25, right: 25, top: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kLightGreyColor),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      onChanged: (value){
                        password = value;
                      },
                      obscureText: true,
                      maxLengthEnforced: true,
                      style: TextStyle(
                          fontSize: 12,
                          color: kBlackColor,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.only(left: 19, right: 50, bottom: 8),
                          border: InputBorder.none,
                          hintText: 'Şifre',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: kGreyColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: InkWell(
                  onTap: ()async {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: email!, password: password!);
                      if (newUser != null) {
                        Route route = MaterialPageRoute(
                            builder: (context) => HomeScreen());
                        Navigator.push(context, route);
                      }
                    } catch (e) {

                      print(e);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrangeAccent),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
