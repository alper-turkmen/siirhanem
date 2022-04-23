import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:denemeler_1/constants/color_constant.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class KitapOku extends StatefulWidget {
  QueryDocumentSnapshot<Object?> snapshot;
  KitapOku({required this.snapshot});

  @override
  State<KitapOku> createState() => _KitapOkuState();
}

class _KitapOkuState extends State<KitapOku> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<dynamic> languages = [];

    flutterTts.getLanguages.then((value) {
      languages = value;
    });
    flutterTts.setLanguage("tr-TR");
    print(languages);
  }

  void dispose(){
    super.dispose();
    flutterTts.stop();
  }

  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: kWhiteColor),
                child: SvgPicture.asset('assets/icons/icon_back_arrow.svg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snapshot['kitapAdi'],
                    style: TextStyle(
                        fontSize: 27,
                        color: kBlackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.snapshot['yazarIsmi'],
                    style: TextStyle(
                        fontSize: 14,
                        color: kGreyColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
                onTap: () async {
                  Future _speak() async {
                    var result =
                        await flutterTts.speak(widget.snapshot['kitapMetni'
                            '']);
                  }

                  _speak();
                },
                child: Icon(
                  Icons.headphones,
                  color: Colors.black87,
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    widget.snapshot['kitapMetni'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      height: 1.3,
                    ),
                  ),
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
