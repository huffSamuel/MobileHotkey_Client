part of mobile_hotkey;

class SplashPage extends StatefulWidget {
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _signIn.onCurrentUserChanged
    .firstWhere((user) => user != null)
    .then((user) {
      Navigator.of(context).pushReplacementNamed('/home');
    });
    
    new Future.delayed(new Duration(seconds: 1))
      .then((_) => signInWithGoogle());
  }

  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new SizedBox(width: 20.0),
              new Text("Signing in...")
            ],
          )
        ],
      )
    );
  }
}