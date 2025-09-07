import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:students/utils/palettes/app_colors.dart';

class CacheNetworkImages{
  Widget cacheNetwork({String? url, double radius = 10, double width = 0, double height = 0}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageUrl: url!,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: colors.umber,
            strokeWidth: 2.5,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
final CacheNetworkImages cacheNetworkImages = new CacheNetworkImages();