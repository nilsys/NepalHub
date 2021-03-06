import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  CachedImage(this.imageURL, {this.tag});

  final String imageURL;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag ?? UniqueKey(),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageURL ?? '',
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
              Icon(FontAwesomeIcons.image, size: 16),
            ],
          ),
        ),
        errorWidget: (context, url, error) => Opacity(
          opacity: 0.45,
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey[500],
            child: Icon(FontAwesomeIcons.image, size: 32),
          ),
        ),
      ),
    );
  }
}
