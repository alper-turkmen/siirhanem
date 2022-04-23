import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denemeler_1/screens/bookInfo.dart';
import 'package:denemeler_1/screens/social.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:denemeler_1/constants/color_constant.dart';


import 'addbook.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('kitaplar')
        .snapshots()
        .first
        .then((value) => {
              for (int i = 0; i < value.docs.length; i++)
                {print(value.docs[i].data())}
            });
  }

  FirebaseAuth? _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.people), onPressed: (){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Social(),
          ),
        );

      },),
      body: SafeArea(
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25, top: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Merhaba ' + _auth!.currentUser!.email!,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => KitapEkle());
                              Navigator.push(context, route);
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Yazar Ol',
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
                    ],
                  )),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'Son Şiirleri Keşfedin',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor),
                ),
              ),
              Container(
                height: 210,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('kitaplar')
                      .orderBy('eklenmeTarihi', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            padding: EdgeInsets.only(left: 25, right: 6),
                            itemCount: snapshot.data!.docs.length >= 5 ? 5 : snapshot.data!.docs.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookInfo(
                                          snapshot:
                                              snapshot.data!.docs[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 19),
                                  height: 210,
                                  width: 153,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      color: kMainColor,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot
                                            .data!.docs[index]['foto']),
                                      )),
                                ),
                              );
                            })
                        : Center(
                            child: CupertinoActivityIndicator(),
                          );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: Text(
                  'En Çok Beğenilenler',
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
                            FirebaseFirestore.instance
                                .collection('kitaplar')
                                .doc(snapshot.data!.docs[index].id)
                                .get()
                                .then((value) {
                              int begeniSayisi = 0;
                              for (int i = 0;
                                  i < value['begeniler'].length;
                                  i++) {
                                begeniSayisi++;
                              }
                              FirebaseFirestore.instance
                                  .collection('kitaplar')
                                  .doc(snapshot.data!.docs[index].id)
                                  .update({'begeniSayisi': begeniSayisi});
                            });

                            return GestureDetector(
                              onTap: () {
                                print('ListView Tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookInfo(
                                        snapshot:
                                            snapshot.data!.docs[index]),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 19),
                                height: 81,
                                width:
                                    MediaQuery.of(context).size.width - 50,
                                color: kBackgroundColor,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 81,
                                      width: 62,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(snapshot
                                                .data!.docs[index]['foto']),
                                          ),
                                          color: kMainColor),
                                    ),
                                    SizedBox(
                                      width: 21,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['kitapAdi'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: kBlackColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['yazarIsmi'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: kGreyColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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
