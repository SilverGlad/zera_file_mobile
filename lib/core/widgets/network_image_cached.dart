import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class NetworkImageCached extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;

  const NetworkImageCached({
    Key key,
    this.imageUrl,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      var imageLink = "";

      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageLink = "http://$imageUrl";
      } else {
        imageLink = "https://verumpe.com.br/wp-content/themes/consultix/images/no-image-found-360x250.png";
      }

      return CachedNetworkImage(
        imageUrl: imageLink,
        fit: boxFit,
        placeholder: (context, url) => Container(
          color: Colors.black12,
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
            backgroundColor: Colors.black12,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.black12,
        ),
      );
    } catch (_) {
      return Container(
        color: Colors.black12,
      );
    }
  }
}
