import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denemeler_1/register.dart';
import 'package:denemeler_1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:denemeler_1/constants/color_constant.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String username;

  final _formKey = GlobalKey<FormState>();

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email!, password: password!);
                          if (user != null) {
                            Route route = MaterialPageRoute(
                                builder: (context) => HomeScreen());
                            Navigator.push(context, route);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Giriş Yap',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrangeAccent),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (context) => Register());
                        Navigator.push(context, route);
                      },
                      child: Container(
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  'Son Eklenen Şiirler',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor),
                ),
              ),





              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('kitaplar')
                    .orderBy('begeniSayisi', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          padding:
                          EdgeInsets.only(top: 25, right: 25, left: 25),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length >= 10 ? 10 : snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            return  Container(
                              margin: EdgeInsets.only(bottom: 19),
                              height: 81,
                              width: MediaQuery.of(context).size.width - 50,
                              color: kBackgroundColor,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 81,
                                    width: 62,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage( snapshot.data!.docs[index]['foto']),
                                        ),
                                        color: kMainColor),
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.docs[index]['kitapAdi'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: kBlackColor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]['yazarIsmi'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: kGreyColor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            );
                          })
                      : Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}
