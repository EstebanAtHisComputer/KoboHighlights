import 'package:flutter/material.dart';

class GithubJSONResponse {
  final String url;
  final String tagName;
  final String body;

  const GithubJSONResponse({
    required this.url,
    required this.tagName,
    required this.body,
  });

  factory GithubJSONResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'body': String body,
        'html_url': String htmlurl,
        'tag_name': String tagName,
      } =>
        GithubJSONResponse(url: htmlurl, tagName: tagName, body: body),
      _ => throw const FormatException("Parse error"),
    };
  }
}

Future<void> errorDialog(BuildContext context, String title, String text) {
  return showDialog(
    context: context,
    requestFocus: true,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.error),
        title: Text(title),
        content: Text(text),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}

void showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationIcon: Image(
      image: Theme.of(context).brightness == Brightness.dark
          ? AssetImage("assets/logo.png")
          : AssetImage("assets/logo_black.png"),
      height: 128.0,
    ),
    applicationVersion: "1.0",
    applicationLegalese: """MIT License

Copyright (c) 2026 EstebanAtHisComputer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

KOBO is a registered trademark owned by RAKUTEN KOBO INC., a TORONTO, ONTARIO based entity.
This software is not affiliated, associated, authorized, or endorsed in any way by RAKUTEN KOBO INC.
""",
  );
}
