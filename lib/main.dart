import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_uni_links/pages/page_one.dart';
import 'package:poc_uni_links/pages/page_two.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Links',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => MyHomePage(title: 'Uni Links com Deep Link'),
        '/page-one': (_) => PageOne(),
        '/page-two': (_) => PageTwo(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  StreamSubscription _sub;

  Future<Null> initUniLinks() async {
    try {
      Uri initialUri = await getInitialUri();
      _sub = getUriLinksStream().listen(
        (Uri deepLink) {
          _navigateWithDeepLink(deepLink);
        },
        onError: (error) {
          print(error);
        },
      );
      _navigateWithDeepLink(initialUri);
    } on PlatformException catch (e) {
      print(e.message);
      print(e.details);
      print(e.stacktrace);
    }
  }

  void _navigateWithDeepLink(Uri deepLink) {
    if (deepLink != null) {
      final path = deepLink.path.replaceAll('/link', '');
      if (path == '/') {
        return;
      }
      if (path == '/page-one/page-two') {
        Navigator.pushNamed(context, '/page-one');
        Navigator.pushNamed(context, '/page-two');
        return;
      }
      Navigator.pushNamed(context, path);
    }
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              child: Text('Ir para a página 1'),
              onPressed: () {
                Navigator.of(context).pushNamed('/page-one');
              },
            ),
            CupertinoButton(
              child: Text('Ir para a página 2'),
              onPressed: () {
                Navigator.of(context).pushNamed('/page-two');
              },
            ),
            // RaisedButton(
            //   onPressed:
            //       !_isCreatingLink ? () => _createDynamicLink(false) : null,
            //   child: const Text('Get Long Link'),
            // ),
            // RaisedButton(
            //   onPressed:
            //       !_isCreatingLink ? () => _createDynamicLink(true) : null,
            //   child: const Text('Get Short Link'),
            // ),
            // Builder(
            //   builder: (contexto) => InkWell(
            //     child: Text(
            //       _linkMessage ?? '',
            //       style: const TextStyle(color: Colors.blue),
            //     ),
            //     onTap: () {
            //       if (_linkMessage != null) {
            //         print(_linkMessage);
            //       }
            //     },
            //     onLongPress: () {
            //       Clipboard.setData(ClipboardData(text: _linkMessage));
            //       Scaffold.of(contexto).showSnackBar(
            //         const SnackBar(content: Text('Link Copiado!')),
            //       );
            //     },
            //   ),
            // ),
            // Text(_linkMessage == null ? '' : _testString)
          ],
        ),
      ),
    );
  }
}
