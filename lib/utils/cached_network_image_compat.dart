import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

/// CachedNetworkImage 兼容层 — 用 extended_image 实现
/// API 对齐 cached_network_image，方便从主仓库同步代码
class CachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, String)? placeholder;
  final ImageWidgetBuilder? imageBuilder;
  final bool fadeIn;
  final Duration fadeInDuration;

  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.memCacheWidth,
    this.memCacheHeight,
    this.errorWidget,
    this.placeholder,
    this.imageBuilder,
    this.fadeIn = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: memCacheWidth,
      cacheHeight: memCacheHeight,
      cache: true,
      enableLoadState: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (placeholder != null) {
              return placeholder!(context, imageUrl);
            }
            return const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            );
          case LoadState.failed:
            state.imageProvider.evict();
            if (errorWidget != null) {
              return errorWidget!(context, imageUrl, state.lastException);
            }
            return const Icon(Icons.broken_image, size: 24);
          case LoadState.completed:
            if (imageBuilder != null) {
              return imageBuilder!(context, state.completedWidget);
            }
            return fadeIn
                ? FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: state.imageProvider,
                    width: width,
                    height: height,
                    fit: fit,
                    fadeInDuration: fadeInDuration,
                  )
                : null;
        }
      },
    );
  }
}

/// 1x1 透明占位图
final kTransparentImage = Uint8List.fromList(
  [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 13, 73, 68, 65, 84, 120, 218, 99, 248, 15, 0, 0, 1, 1, 0, 5, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130],
);

import 'dart:typed_data';

/// CachedNetworkImageProvider 兼容层
class CachedNetworkImageProvider extends ImageProvider<CachedNetworkImageProvider> {
  final String url;
  final double scale;
  final int? maxWidth;
  final int? maxHeight;

  const CachedNetworkImageProvider(
    this.url, {
    this.scale = 1.0,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  ImageStreamCompleter loadImage(CachedNetworkImageProvider key, ImageDecoderCallback decode) {
    return ExtendedImage.network(
      url,
      width: maxWidth?.toDouble(),
      height: maxHeight?.toDouble(),
      fit: BoxFit.cover,
      cache: true,
    ).image.resolve(ImageConfiguration.empty);
  }

  @override
  Future<CachedNetworkImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedNetworkImageProvider>(this);
  }
}
