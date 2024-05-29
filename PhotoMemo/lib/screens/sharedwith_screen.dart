import 'package:flutter/material.dart';
import 'package:photomemo/model/photomemo.dart';
import 'package:photomemo/screens/views/myimageview.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/home/sharedWithScreen';

  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  _Controller con;
  List<PhotoMemo> photoMemos;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    photoMemos ??= args['sharedPhotoMemoList'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shared With Me'),
      ),
      body: photoMemos.length == 0
          ? Text(
              'No PhotoMemos shared with me',
              style: TextStyle(fontSize: 20.0),
            )
          : ListView.builder(
              itemCount: photoMemos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 2.0, 5.0),
                  child: Card(
                    elevation: 10.0,
                    color: Colors.blue[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: MyImageView.network(
                            imageUrl: photoMemos[index].photoURL,
                            context: context,
                          ),
                        ),
                        Text(
                          'Title: ${photoMemos[index].title}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Text(
                          '${photoMemos[index].memo}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Created By: ${photoMemos[index].createdBy}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Updated At: ${photoMemos[index].updatedAt}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Shared With: ${photoMemos[index].sharedWith}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Controller {
  _SharedWithState _state;
  _Controller(this._state);
}
