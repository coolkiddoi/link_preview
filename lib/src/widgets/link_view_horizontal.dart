import 'dart:convert';

import 'package:flutter/material.dart';

class LinkViewHorizontal extends StatelessWidget {
  final String url;
  final String title;
  final String description;
  final String imageUri;
  final Function() onTap;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool? showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final double? radius;
  final Color? bgColor;

  const LinkViewHorizontal({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.onTap,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.showMultiMedia,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.bgColor,
    this.radius,
  }) : super(key: key);

  double computeTitleFontSize(double width) {
    var size = width * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight) {
    return layoutHeight >= 100 ? 2 : 1;
  }

  int computeBodyLines(layoutHeight) {
    var lines = 1;
    if (layoutHeight > 40) {
      lines += (layoutHeight - 40.0) ~/ 15.0 as int;
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var _titleFontSize = titleTextStyle ??
            const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            );
        var _bodyFontSize = bodyTextStyle ??
            const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            );

        ImageProvider? _img = imageUri != '' ? NetworkImage(imageUri) : null;
        if (imageUri.startsWith('data:image')) {
          _img = MemoryImage(
            base64Decode(imageUri.substring(imageUri.indexOf('base64') + 7)),
          );
        }

        return InkWell(
          onTap: () => onTap(),
          child: SizedBox(
            height: 100,
            child: Row(
              children: <Widget>[
                showMultiMedia!
                    ? Expanded(
                        flex: 2,
                        child: _img == null
                            ? Container(color: bgColor ?? Colors.grey)
                            : Container(
                                height: 100,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: _img,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: radius == 0
                                      ? BorderRadius.zero
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(radius!),
                                          bottomLeft: Radius.circular(radius!),
                                        ),
                                ),
                              ),
                      )
                    : const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTitleContainer(_titleFontSize, 2),
                        const SizedBox(height: 6),
                        _buildBodyContainer(_bodyFontSize, 2)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleContainer(TextStyle _titleTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: const Alignment(-1.0, -1.0),
            child: Text(
              title,
              style: _titleTS,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle _bodyTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
      child: Container(
        alignment: const Alignment(-1.0, -1.0),
        child: Text(
          description,
          textAlign: TextAlign.left,
          style: _bodyTS,
          overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
