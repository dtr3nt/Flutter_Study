import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyImageView {
  static CachedNetworkImage network({
    @required String imageUrl,
    @required BuildContext context,
  }) =>
      CachedNetworkImage(
        imageUrl: imageUrl ?? 'http://noaddess_null',
        errorWidget: (context, url, error) => Icon(Icons.error, size: 30.0),
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
      );
}
