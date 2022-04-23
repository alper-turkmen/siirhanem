import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:denemeler_1/constants/color_constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class KitapEkle extends StatefulWidget {
  KitapEkle();

  @override
  State<KitapEkle> createState() => _KitapEkleState();
}

class _KitapEkleState extends State<KitapEkle> {
  String? kitapAdi;
  String? yazarIsmi;
  String? aciklama;
  String? kitapMetni;
  String? foto = '';

  final ImagePicker _picker = ImagePicker();
  var imageFile = null;

  void initState() {
    super.initState();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  createData() {
    Map<String, dynamic> kitap = {
      "kitapAdi": kitapAdi,
      "yazarIsmi": yazarIsmi,
      'kitapMetni': kitapMetni,
      'aciklama':aciklama,
      'foto': foto,
      'eklenmeTarihi' : DateTime.now(),
      'begeniler': [],

      'begeniSayisi':0,
    };

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Kitap Ekleniyor"),
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


    FirebaseFirestore.instance.collection('kitaplar').add(kitap).then((docRef) {


      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text('Kitap Eklendi')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Tamam'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
        height: 49,
        color: Colors.transparent,
        child: FlatButton(
          color: kMainColor,
          onPressed: () {

            if(aciklama != null && kitapAdi != null && kitapMetni != null && yazarIsmi != null && foto !=null){}
            createData();
          },
          child: Text(


            'Şiiri Yayınlayın',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: kWhiteColor),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kMainColor,
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: Container(
                  color: Color(0xFFFFD3B6),
                  height: MediaQuery.of(context).size.height * 0.5,
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
                          margin: EdgeInsets.all(62),
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(foto!

                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () async {
                            final photo = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 40);
                            File file = File(photo!.path);

                            if (file != null) {
                              setState(() {
                                _showDialog();
                              });
                              final _firebaseStorage = FirebaseStorage.instance;
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

                                          Navigator.pop(context);
                                        })
                                      });
                            } else {
                              print('No Image Path Received');
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 25, bottom: 25),
                            height: 49,
                            color: Colors.transparent,
                            child: FlatButton(
                              color: kMainColor,
                              onPressed: () async {
                                final photo = await _picker.pickImage(
                                    source: ImageSource.gallery, imageQuality: 40);
                                File file = File(photo!.path);

                                if (file != null) {
                                  setState(() {
                                    _showDialog();
                                  });
                                  final _firebaseStorage = FirebaseStorage.instance;
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

                                      Navigator.pop(context);
                                    })
                                  });
                                } else {
                                  print('No Image Path Received');
                                }
                              },
                              child: Text(
                                'Şiir Kapağı Seçin',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kWhiteColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        bottom: 10,
                        right: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
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
                          kitapAdi = value;
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
                            hintText: 'Şiirin Adı Ne Olsun?',
                            hintStyle: TextStyle(
                                fontSize: 15,
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
                          yazarIsmi = value;
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
                            hintText: 'Yazar İsmi',
                            hintStyle: TextStyle(
                                fontSize: 15,
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
                              aciklama = value;
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
                                hintText: 'Şiir Açıklaması',
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: kGreyColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kLightGreyColor),
                  child: Stack(
                    children: <Widget>[
                      TextField(

                        onChanged: (value){
                          kitapMetni = value;
                        },


                        maxLines: 20,
                        maxLengthEnforced: true,
                        style: TextStyle(
                            fontSize: 12,
                            color: kBlackColor,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 19, right: 50, bottom: 8, top: 20),
                            border: InputBorder.none,
                            hintText:
                                'Bir sonraki muhteşem şiirinizi yazmaya başlayın...',
                            hintStyle: TextStyle(
                                fontSize: 15,
                                color: kGreyColor,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
