import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:hire/main.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Account>(context).loading) return _loading(context);
    if (Provider.of<Account>(context).user == null) return _logIn(context);
    return _main(context);
  }

  Widget _loading(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('loading...')),
        body: Center(child: CircularProgressIndicator()));
  }

  Widget _logIn(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('login page')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('login'),
              onPressed: () {
                _signIn(context);
              },
            )
          ],
        )));
  }

  Widget _main(BuildContext context) {
    var appBarHeight =
        AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(title: Text('logged in'), actions: <Widget>[
          FlatButton(
              child: CircleAvatar(
                  radius: appBarHeight * 1.0,
                  backgroundColor: Colors.teal[200],
                  child: CircleAvatar(
                    radius: appBarHeight * 0.9,
                    backgroundImage: CachedNetworkImageProvider(
                      Provider.of<Account>(context).avatar,
                    ),
                    backgroundColor: Colors.transparent,
                  )),
              onPressed: () {
                _signOut(context);
              })
        ]),
        body: Center(
            child: Column(children: <Widget>[
          Text(Provider.of<Account>(context).user.displayName),
          Text(Provider.of<Account>(context).user.email),
          CachedNetworkImage(
              imageUrl: Provider.of<Account>(context).user.photoUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error)),
        ])));
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _signIn(BuildContext context) async {
    Provider.of<Account>(context, listen: false).changeState(true);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print(user);

    Provider.of<Account>(context, listen: false).changeState(false);
    Provider.of<Account>(context, listen: false).setUser(user);

    return 'success';
  }

  void _signOut(BuildContext context) async {
    await googleSignIn.signOut();
    Provider.of<Account>(context, listen: false).setUser(null);
  }
}
