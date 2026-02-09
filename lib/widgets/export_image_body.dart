import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kobo_highlights/utils.dart';

class ExportImageBody extends StatefulWidget {
  final String text;
  final String title;

  const ExportImageBody({required this.title, required this.text, super.key});

  @override
  State<ExportImageBody> createState() => _ExportImageBodyState();
}

class _ExportImageBodyState extends State<ExportImageBody> {
  final GlobalKey _cardKey = GlobalKey();

  bool _bigText = false;
  bool _includeAuthor = true;

  //Based on https://medium.com/@henryifebunandu/capture-and-save-flutter-widgets-as-images-a-step-by-step-guide-638e77225f6f
  Future<void> _captureAndSave(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final String fileName = "${widget.title}.png";
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          XTypeGroup(label: "Image file", extensions: [".png"]),
        ],
      );
      if (result == null) {
        return;
      }
      final file = File(result.path);
      await file.writeAsBytes(pngBytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        await errorDialog(context, "Error exporting image", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _cardKey,
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(32),
              child: Column(
                children: [
                  Text(
                    '"${widget.text}"',
                    style: TextStyle(fontSize: _bigText ? 24 : 16),
                  ),
                  _includeAuthor
                      ? Text(
                          widget.title,
                          style: TextStyle(fontSize: _bigText ? 16 : 14),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 225,
              child: SwitchListTile(
                value: _bigText,
                onChanged: (b) {
                  setState(() {
                    _bigText = b;
                  });
                },
                title: Text("Big text"),
              ),
            ),
            SizedBox(
              width: 225,
              child: SwitchListTile(
                value: _includeAuthor,
                onChanged: (b) {
                  setState(() {
                    _includeAuthor = b;
                  });
                },
                title: Text("Include title"),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsetsGeometry.directional(end: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 12.0,
            children: [
              FilledButton(
                onPressed: () {
                  _captureAndSave(context);
                },
                child: Text("Save"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    ColorScheme.of(context).secondary,
                  ),
                ),
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
