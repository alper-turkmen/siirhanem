import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denemeler_1/models/getModel.dart';
import 'package:denemeler_1/OCR/camera_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:denemeler_1/constants/color_constant.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Social extends StatefulWidget {
  Social();

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController yorumController = TextEditingController();

  int defaultTab = 0;
  String? yorum;
  List a = [];
  bool isContain = false;
  final ImagePicker _picker = ImagePicker();
  var imageFile = null;
  String foto = '';
  GetModel getModel = Get.put(GetModel());

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      // flutter defined function
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Kapak Yükleniyor"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
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
      ),
      bottomSheet: BottomAppBar(
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
                    controller: getModel.yorumController,
                    maxLines: 4,
                    minLines: 1,
                    onChanged: (value) {
                      yorum = value;
                    },
                    style: TextStyle(
                        fontSize: 20,
                        color: kBlackColor,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                        hintText: 'Düşüncelerinizi Ekleyin...',
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: kGreyColor,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.deepOrangeAccent,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: kMainColor,
                            onPressed: () {
                              getModel.yorumController.clear();
                              getModel.recognizedTexts.clear();

                              Route route = MaterialPageRoute(
                                  builder: (context) => CameraView(
                                      title: 'title',
                                      customPaint: null,
                                      onImage: (InputImage) {}));
                              Navigator.push(context, route).then((value) {});
                            },
                            icon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  'OCR',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.deepOrangeAccent,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: kMainColor,
                            onPressed: () async {
                              final photo = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 40);
                              File file = File(photo!.path);

                              if (file != null) {
                                setState(() {
                                  _showDialog();
                                });
                                final _firebaseStorage =
                                    FirebaseStorage.instance;
                                //Upload to Firebase
                                var snapshot = await _firebaseStorage
                                    .ref()
                                    .child('images/' + photo.name)
                                    .putFile(file);
                                var downloadUrl = await snapshot.ref
                                    .getDownloadURL()
                                    .then((value) => {
                                          setState(() {
                                            foto = value;
                                            print(value);
                                            FirebaseFirestore.instance
                                                .collection('sosyal')
                                                .add({
                                              'tur': 'foto',
                                              'yorum': foto,
                                              'yazar': _auth.currentUser!.uid,
                                              'email': _auth.currentUser!.email,
                                              'tarih': DateTime.now()
                                            }).then((value) {
                                              Navigator.pop(context);
                                            });
                                          })
                                        });
                              } else {
                                print('No Image Path Received');
                              }
                            },
                            icon: Icon(
                              Icons.photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      color: kMainColor,
                      onPressed: () {
                        FirebaseFirestore.instance.collection('sosyal').add({
                          'tur': 'yazi',
                          'yorum': yorum == null ? getModel.yorumController.text : yorum,
                          'yazar': _auth.currentUser!.uid,
                          'email': _auth.currentUser!.email,
                          'tarih': DateTime.now()
                        }).then((value) {
                          getModel.yorumController.clear();
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
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sosyal')
                  .orderBy('tarih', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.docs.length != 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: snapshot.data!.docs[index]['yazar'] ==
                                      _auth.currentUser!.uid
                                  ? Row(
                                      children: [
                                        Spacer(),
                                        snapshot.data!.docs[index]['tur'] ==
                                                'yazi'
                                            ? ChatBubble(
                                                clipper: ChatBubbleClipper4(
                                                    type:
                                                        BubbleType.sendBubble),
                                                backGroundColor:
                                                    Colors.deepOrangeAccent,
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                  ),
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['yorum'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : ChatBubble(
                                                clipper: ChatBubbleClipper4(
                                                    type:
                                                        BubbleType.sendBubble),
                                                backGroundColor:
                                                    Colors.deepOrangeAccent,
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                  ),
                                                  child: Image.network(snapshot
                                                      .data!
                                                      .docs[index]['yorum']),
                                                ),
                                              ),
                                        IconButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('sosyal')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.deepOrangeAccent,
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(snapshot.data!.docs[index]
                                            ['email']),
                                        snapshot.data!.docs[index]['tur'] ==
                                            'yazi' ?  ChatBubble(
                                          clipper: ChatBubbleClipper4(
                                              type: BubbleType.receiverBubble),
                                          backGroundColor: Color(0xffE7E7ED),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                            ),
                                            child: Text(
                                              snapshot.data!.docs[index]
                                                  ['yorum'],
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ) : ChatBubble(
                                          clipper: ChatBubbleClipper4(
                                              type: BubbleType.receiverBubble),
                                          backGroundColor: Color(0xffE7E7ED),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.6,
                                            ),
                                            child: Image.network(
                                              snapshot.data!.docs[index]
                                              ['yorum'],

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          } else {
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
          ]),
        ],
      ),
    );
  }
}
