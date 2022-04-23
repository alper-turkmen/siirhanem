import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denemeler_1/screens/readBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:denemeler_1/constants/color_constant.dart';

import 'package:google_fonts/google_fonts.dart';

class BookInfo extends StatefulWidget {
  QueryDocumentSnapshot<Object?> snapshot;
  BookInfo({required this.snapshot});

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('kitaplar')
        .doc(widget.snapshot.id)
        .get()
        .then((value) {
      a = value.data()!['begeniler'];

      for (int i = 0; i < a.length; i++) {
        if (a[i] == _auth.currentUser!.uid) {
          print('ICERIYOR AQ');
          setState(() {
            isContain = true;
          });
        }
      }
    });
  }
TextEditingController yorumController = TextEditingController();
  int defaultTab = 0;
  String? yorum;
  List a = [];
  bool isContain = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomSheet: defaultTab == 0
          ? BottomAppBar(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: kMainColor,
                      onPressed: () {
                        print(widget.snapshot.id);
                        Route route = MaterialPageRoute(
                            builder: (context) => KitapOku(
                                  snapshot: widget.snapshot,
                                ));
                        Navigator.push(context, route);
                      },
                      child: Text(
                        'Şiiri Oku',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kWhiteColor),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            )
          : BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kLightGreyColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: yorumController,
                          maxLines: 4,
                          minLines: 1,
                          onChanged: (value) {
                            yorum = value;
                          },
                          style: TextStyle(
                              fontSize: 12,
                              color: kBlackColor,
                              fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              hintText: 'Yorumunuzu Ekleyin...',
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: kGreyColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                        color: kMainColor,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('kitaplar')
                              .doc(widget.snapshot.id)
                              .collection('yorumlar')
                              .add({'yorum': yorum, 'yazar':_auth.currentUser!.uid, 'email':_auth.currentUser!.email, 'tarih':DateTime.now()}).then((value) {
                                yorumController.clear();
                          });
                        },
                        child: Text(
                          'Yorumu Ekle',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kWhiteColor),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            color: Color(0xFFFFD3B6),
            height: MediaQuery.of(context).size.height * 0.38,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 25,
                  top: 35,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kWhiteColor),
                      child: SvgPicture.asset(
                          'assets/icons/icon_back_arrow.svg'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(50),
                    width: 150,
                    height: 225,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.snapshot['foto']),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
              children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24, left: 25),
                      child: Text(
                        widget.snapshot['kitapAdi'],
                        style: TextStyle(
                            fontSize: 27,
                            color: kBlackColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 7, left: 25),
                      child: Text(
                        widget.snapshot['yazarIsmi'],
                        style: TextStyle(
                            fontSize: 14,
                            color: kGreyColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (isContain) {
                      a.remove(_auth.currentUser!.uid);
                      FirebaseFirestore.instance
                          .collection('kitaplar')
                          .doc(widget.snapshot.id)
                          .update({'begeniler': a});
                      setState(() {
                        isContain = false;
                      });
                    } else {
                      a.add(_auth.currentUser!.uid);
                      FirebaseFirestore.instance
                          .collection('kitaplar')
                          .doc(widget.snapshot.id)
                          .update({'begeniler': a});
                      setState(() {
                        isContain = true;
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.deepOrangeAccent,
                    radius: 25,
                    child: Icon(
                      isContain ? Icons.favorite : Icons.favorite_border,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 28,
                  margin: EdgeInsets.only(top: 23, bottom: 36),
                  padding: EdgeInsets.only(left: 25),
                  child: DefaultTabController(
                    length: 2,
                    child: TabBar(
                        onTap: (value) {
                          setState(() {
                            defaultTab = value;
                          });
                        },
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5),
                        indicatorPadding: EdgeInsets.all(0),
                        isScrollable: true,
                        labelColor: kBlackColor,
                        unselectedLabelColor: kGreyColor,
                        labelStyle: GoogleFonts.gentiumBookBasic(),
                        tabs: [
                          Tab(
                            child: Container(
                              child: Text('Açıklama'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('Yorumlar'),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            defaultTab == 0
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, bottom: 25, top: 25),
                    child: Text(
                      widget.snapshot['aciklama'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kGreyColor,
                        letterSpacing: 1.5,
                        height: 2,
                      ),
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('kitaplar')
                      .doc(widget.snapshot.id)
                      .collection('yorumlar').orderBy('tarih', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {

                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {

                              if(snapshot.data!.docs.length != 0){
                                 return   Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  child: snapshot.data!.docs[index]['yazar'] == _auth.currentUser!.uid  ? Row(
                                    children: [Spacer(),
                                      ChatBubble(
                                        clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
                                        backGroundColor: Colors.deepOrangeAccent,

                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                                          ),
                                          child:       Text(
                                            snapshot.data!.docs[index]['yorum'],style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                      IconButton(onPressed: (){

                                        FirebaseFirestore.instance
                                            .collection('kitaplar')
                                            .doc(widget.snapshot.id)
                                            .collection('yorumlar').doc(snapshot.data!.docs[index].id).delete();

                                      }, icon: Icon(Icons.delete)),
                                    ],
                                  ) : Column(
                                    children: [
                                      Text(snapshot.data!.docs[index]['email']),
                                      ChatBubble(
                                        clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                                        backGroundColor: Color(0xffE7E7ED),

                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                                          ),
                                          child:       Text(
                                            snapshot.data!.docs[index]['yorum'],style: TextStyle(color: Colors.black87),),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                              return Center(
                              child: CupertinoActivityIndicator(),
                              );
                              }

                            })
                        : Center(
                            child: CupertinoActivityIndicator(),
                          );
                  },
                ),
          ])
        ],
      ),
    );
  }
}
