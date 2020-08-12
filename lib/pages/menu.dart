import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:hire/main.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
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
      body: Center(
        child: Column(children: [
          RaisedButton(
            child: Text('Login'),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          RaisedButton(
            child: Text('Cards'),
            onPressed: () {
              Navigator.pushNamed(context, '/cards');
            },
          ),
          RaisedButton(
            child: Text('Map'),
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
          RaisedButton(
            child: Text('Camera'),
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
        ]),
      ),
    );
  }
}
