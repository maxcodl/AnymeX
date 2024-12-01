// ignore_for_file: camel_case_types, use_build_context_synchronously, must_be_immutable
import 'dart:math';
import 'package:anymex/components/android/helper/scroll_helper.dart';
import 'package:anymex/pages/Android/Anime/details_page.dart';
import 'package:anymex/pages/Android/Manga/details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class anilistCarousel extends StatelessWidget {
  final List<dynamic>? carouselData;
  final String? title;
  final String? tag;
  bool isManga;
  anilistCarousel(
      {super.key,
      this.title,
      this.carouselData,
      this.tag,
      this.isManga = false});

  final ScrollDirectionHelper _scrollDirectionHelper = ScrollDirectionHelper();

  @override
  Widget build(BuildContext context) {
    final bool usingCompactCards =
        Hive.box('app-data').get('usingCompactCards', defaultValue: false);
    final bool usingSaikouCards =
        Hive.box('app-data').get('usingSaikouCards', defaultValue: true);

    if (carouselData == null || carouselData!.isEmpty) {
      return const SizedBox.shrink();
    }

    Matrix4 getTransformMatrix(TransformableListItem item) {
      const maxScale = 1;
      const minScale = 0.9;
      final viewportWidth = item.constraints.viewportMainAxisExtent;
      final itemLeftEdge = item.offset.dx;
      final itemRightEdge = item.offset.dx + item.size.width;

      bool isScrollingRight =
          _scrollDirectionHelper.isScrollingRight(item.offset);

      double visiblePortion;
      if (isScrollingRight) {
        visiblePortion = (viewportWidth - itemLeftEdge) / item.size.width;
      } else {
        visiblePortion = (itemRightEdge) / item.size.width;
      }

      if ((isScrollingRight && itemLeftEdge < viewportWidth) ||
          (!isScrollingRight && itemRightEdge > 0)) {
        const scaleRange = maxScale - minScale;
        final scale =
            minScale + (scaleRange * visiblePortion).clamp(0.0, scaleRange);

        return Matrix4.identity()
          ..translate(item.size.width / 2, 0, 0)
          ..scale(scale)
          ..translate(-item.size.width / 2, 0, 0);
      }

      return Matrix4.identity();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            title ?? '??',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: usingSaikouCards
              ? (usingCompactCards ? 170 : 210)
              : (usingCompactCards ? 280 : 300),
          child: TransformableListView.builder(
            padding: const EdgeInsets.only(left: 20),
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            getTransformMatrix: getTransformMatrix,
            scrollDirection: Axis.horizontal,
            itemCount: carouselData!.length,
            itemExtent: MediaQuery.of(context).size.width /
                (usingSaikouCards ? 3.3 : 2.3),
            itemBuilder: (context, index) {
              final itemData = carouselData?[index]['media'];
              final String posterUrl = itemData?['coverImage']?['large'] ??
                  'https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx16498-73IhOXpJZiMF.jpg';
              int random = Random().nextInt(100000);
              final tagg = '$random$index';
              const String proxyUrl = '';
              dynamic extraData =
                  '${isManga ? 'Chapter' : 'Episode'} ${carouselData?[index]?['progress']?.toString() ?? '?'}';
              '1';
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    if (isManga) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MangaDetailsPage(
                                    id: itemData['id'],
                                    tag: tagg,
                                    posterUrl: proxyUrl + posterUrl,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                    id: itemData['id'],
                                    tag: tagg,
                                    posterUrl: proxyUrl + posterUrl,
                                  )));
                    }
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Stack(children: [
                            SizedBox(
                              height: usingSaikouCards ? 160 : 240,
                              child: Hero(
                                tag: tagg,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CachedNetworkImage(
                                    imageUrl: proxyUrl + posterUrl,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[900]!,
                                      highlightColor: Colors.grey[700]!,
                                      child: Container(
                                        color: Colors.grey[900],
                                        width: double.infinity,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: usingSaikouCards
                                        ? (usingCompactCards ? 200 : 170)
                                        : (usingCompactCards ? 280 : 250),
                                  ),
                                ),
                              ),
                            ),
                            if (!usingCompactCards)
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            bottomRight: Radius.circular(16))),
                                    child: Text(
                                      extraData,
                                      style: TextStyle(
                                          fontFamily: 'Poppins-SemiBold',
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface),
                                    ),
                                  )),
                            if (usingCompactCards)
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer,
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(18),
                                            topRight: Radius.circular(16))),
                                    child: Text(
                                      extraData,
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface),
                                    ),
                                  )),
                          ]),
                          if (usingCompactCards)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (usingCompactCards)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Text(
                                itemData?['title']?['english'] ??
                                    itemData?['title']?['romaji'] ??
                                    '?',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontSize: usingSaikouCards ? 10 : 13,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else
                            Column(
                              children: [
                                SizedBox(
                                  height: usingSaikouCards ? 164 : 248,
                                  width: MediaQuery.of(context).size.width /
                                      (usingSaikouCards ? 3.3 : 2.3),
                                ),
                                Text(
                                  itemData?['title']?['english'] ??
                                      itemData?['title']?['romaji'] ??
                                      '?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                    fontSize: usingSaikouCards ? 10 : 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}