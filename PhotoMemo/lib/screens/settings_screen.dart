import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/screens/views/mydialog.dart';
import 'package:photomemo/screens/views/myimageview.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/homeScreen/settingScreen';
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'),
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
              Text(
                'Change Profile Picture',
                style: TextStyle(fontSize: 20.0),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: con.imageFile == null
                        ? MyImageView.network(
                            imageUrl: user.photoURL,
                            context: context,
                          )
                        : Image.file(con.imageFile, fit: BoxFit.fill),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
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
                  ),
                ],
              ),
              con.progressMessage == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      con.progressMessage,
                      style: TextStyle(fontSize: 20.0),
                    ),
              TextFormField(
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintText: 'Display Name',
                ),
                initialValue: user.displayName ?? 'N/A',
                autocorrect: false,
                validator: con.validatorDisplayName,
                onSaved: con.onSavedDisplayName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SettingsState _state;
  String progressMessage;
  File imageFile;
  String displayName;

  _Controller(this._state);

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      await FirebaseController.updateProfile(
        image: imageFile,
        displayName: displayName,
        user: _state.user,
        progressListener: (double percentage) {
          _state.render(() {
            progressMessage = 'Uploading ${percentage.toStringAsFixed(1)} %';
          });
        },
      );

      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Profile update error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _image;
      if (src == 'camera')
        _image = await ImagePicker().getImage(source: ImageSource.camera);
      else
        _image = await ImagePicker().getImage(source: ImageSource.gallery);
      _state.render(() => imageFile = File(_image.path));
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Image capture error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorDisplayName(String value) {
    if (value.length < 2)
      return 'min 2 chars';
    else
      return null;
  }

  void onSavedDisplayName(String value) {
    this.displayName = value;
  }
}
