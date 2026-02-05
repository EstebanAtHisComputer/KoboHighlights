import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:kobo_highlights/db.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './main_page.dart';
import '../utils.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});
  @override
  State<StatefulWidget> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<GithubJSONResponse> githubResponse;
  String version = "VER_NOT_FOUND";
  String appName = '';
  String appVersion = '';

  _fetchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    appVersion = packageInfo.version;
    setState(() {
      version = "$appName $appVersion";
    });
  }

  Future<GithubJSONResponse> checkUpdates() async {
    final response = await http.get(
      Uri.parse(
        "https://api.github.com/repos/EstebanAtHisComputer/KoboHighlightsFlutter/releases/latest",
      ),
    );
    if (response.statusCode == 200) {
      return GithubJSONResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception("Couldn't fetch updates");
    }
  }

  Future<void> showUpdateDialog(
    BuildContext context,
    GithubJSONResponse response,
  ) {
    return showDialog(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.error),
          title: Text("Update available"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("An update is available: ${response.tagName}"),
              SizedBox(height: 20.0),
              Container(
                color: Theme.of(context).colorScheme.surfaceBright,
                child: Text(response.body),
              ),
              SizedBox(height: 20.0),
              Text("Would you like to open the downloads page?"),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                final Uri url = Uri.parse(response.url);
                if (!await launchUrl(url)) {
                  throw Exception("Failed to launch browser");
                }
              },
              child: const Text("Yes"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  _tryLoad(XFile file) async {
    await tryDB(file.path);
    if (mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  Future<void> _showKoboWarning(XFile file) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning: .kobo folder detected.'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "You seem to be loading the database directly from the .kobo folder in your eReader. This is not advised: if a connection error or some kind of problem damages the file, you could lose all of your content. Please, make a copy of the database file into your computer, and try loading that file instead.",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FilledButton(
              child: const Text("Go back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  ColorScheme.of(context).errorContainer,
                ),
              ),
              child: const Text("Load anyway"),
              onPressed: () {
                Navigator.of(context).pop();
                _tryLoad(file);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchVersion();
    githubResponse = checkUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: Theme.of(context).brightness == Brightness.dark
                  ? AssetImage("assets/logo.png")
                  : AssetImage("assets/logo_black.png"),
            ),
            FilledButton(
              onPressed: () async {
                XFile? file = await openFile();
                if (file != null) {
                  try {
                    if (file.path.contains(".kobo")) {
                      _showKoboWarning(file);
                    } else {
                      _tryLoad(file);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      errorDialog(
                        context,
                        "Error loading Database",
                        e.toString(),
                      );
                    }
                  }
                }
              },
              style: ButtonStyle(
                mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.basic),
              ),
              child: const Text("Open"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.5,
          child: Row(
            children: [
              Text(version),
              FutureBuilder<GithubJSONResponse>(
                future: githubResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String ver = snapshot.data!.tagName;
                    if (ver != appVersion) {
                      return TextButton(
                        style: ButtonStyle(
                          textStyle: WidgetStateTextStyle.resolveWith(
                            (states) =>
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateColor.resolveWith(
                            (x) => Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          showUpdateDialog(context, snapshot.data!);
                        },
                        child: Text("(Update available: $ver)"),
                      );
                    } else {
                      return Text(" (latest)");
                    }
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
