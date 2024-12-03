import 'package:alnoor/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ReusableCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final bool showProgress;
  final CacheManager? cacheManager;

  const ReusableCachedImage({
    Key? key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheManager,
    this.showProgress = false,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      cacheManager: cacheManager ?? getIt<CacheManager>(),
      imageUrl: imageUrl,
      fit: fit,
      placeholder: placeholder ??
          (context, string) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      // progressIndicatorBuilder:
      //     (context, url, downloadProgress) => Center(
      //           child: CircularProgressIndicator(
      //             value: downloadProgress.progress, // Shows loading progress
      //           ),
      //         )
      //     ,
    );
  }
}
