import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/views/mydialog.dart';

class AddScreen extends StatefulWidget {
  static const routeName = '/home/addScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddState();
  }
}

class _AddState extends State<AddScreen> {
  _Controller con;
  File image;
  var formKey = GlobalKey<FormState>();
  User user;
  List<PhotoMemo> photoMemos;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    photoMemos ??= args['photoMemoList'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Photo Memo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: image == null
                        ? Icon(
                            Icons.photo_library,
                            size: 300.0,
                          )
                        : Image.file(
                            image,
                            fit: BoxFit.fill,
                          ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: Colors.blue[200],
                      child: PopupMenuButton<String>(
                        onSelected: con.getPicture,
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'camera',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_camera),
                                Text('Camera'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_album),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              con.uploadProgressMessage == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      con.uploadProgressMessage,
                      style: TextStyle(fontSize: 20.0),
                    ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                autocorrect: true,
                validator: con.validatorTitle,
                onSaved: con.onSavedTitle,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Memo',
                ),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                validator: con.validatorMemo,
                onSaved: con.onSavedMemo,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'SharedWith (comma seperated email list)',
                ),
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: con.validatorSharedWith,
                onSaved: con.onSavedSharedWith,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddState _state;
  _Controller(this._state);
  String title;
  String memo;
  List<String> shareWith = [];
  String uploadProgressMessage;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgreeStart(_state.context);

      //1. upload pic to Storage
      Map<String, String> photoInfo = await FirebaseController.uploadStorage(
        image: _state.image,
        uid: _state.user.uid,
        sharedWith: shareWith,
        listener: (double progressPercentage) {
          _state.render(() {
            uploadProgressMessage =
                'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
          });
        },
      );

      //2. get image labels by Machine Learning kit
      _state.render(() => uploadProgressMessage = 'ML Image Labler started');
      List<String> labels =
          await FirebaseController.getImageLabels(_state.image);
      print('*********labels' + labels.toString());

      //3. save photomemo doc to Firestore
      var p = PhotoMemo(
        title: title,
        memo: memo,
        photoPath: photoInfo['path'],
        photoURL: photoInfo['url'],
        createdBy: _state.user.email,
        sharedWith: shareWith,
        updatedAt: DateTime.now(),
        imageLabels: labels,
      );

      p.docId = await FirebaseController.addPhotoMemo(p);
      _state.photoMemos.insert(0, p);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == 'camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      _state.render(() {
        _state.image = File(_imageFile.path);
      });
    } catch (e) {}
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    this.title = value;
  }

  String validatorMemo(String value) {
    if (value == null || value.trim().length < 3) {
      return 'min 3 chars';
    } else {
      return null;
    }
  }

  void onSavedMemo(String value) {
    this.memo = value;
  }

  String validatorSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;

    List<String> emailList = value.split(',').map((e) => e.trim()).toList();

    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'Comma(,) separated email list';
    }
    return null;
  }

  void onSavedSharedWith(String value) {
    if (value.trim().length != 0) {
      this.shareWith = value.split(',').map((e) => e.trim()).toList();
    }
  }
}
