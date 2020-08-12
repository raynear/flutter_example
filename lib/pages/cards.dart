import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:hire/main.dart';

class Cards extends StatefulWidget {
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  @override
  build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          title: Text('cards'),
          actions: [
            CircleAvatar(
                radius: appBarHeight * 1.0,
                backgroundColor: Colors.teal[200],
                child: CircleAvatar(
                  radius: appBarHeight * 0.9,
                  backgroundImage: CachedNetworkImageProvider(
                    Provider.of<Account>(context).avatar,
                  ),
                  backgroundColor: Colors.transparent,
                ))
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('item').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data.documents);
          },
        ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.all(5),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = data;
    print('record ${record['item']}');
    return Container(
      child: ListTile(
        title: Text(record['item']),
        trailing: Text(record['like'].toString()),
      ),
    );
  }
}
