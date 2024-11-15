// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EpisodeGrid extends StatefulWidget {
  final List<dynamic> episodes;
  final int layoutIndex;
  final Function(int) onEpisodeSelected;
  final Function(String, String) onEpisodeDownload;
  final int currentEpisode;
  final String coverImage;
  final int progress;
  final dynamic episodeImages;
  const EpisodeGrid({
    super.key,
    required this.episodes,
    required this.layoutIndex,
    required this.currentEpisode,
    required this.onEpisodeSelected,
    required this.progress,
    required this.coverImage,
    this.episodeImages,
    required this.onEpisodeDownload,
  });

  @override
  _EpisodeGridState createState() => _EpisodeGridState();
}

class _EpisodeGridState extends State<EpisodeGrid> {
  late List<dynamic> filteredEpisodes;

  @override
  void initState() {
    super.initState();
    filteredEpisodes = widget.episodes;
  }

  @override
  void didUpdateWidget(EpisodeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.episodes != oldWidget.episodes) {
      setState(() {
        filteredEpisodes = widget.episodes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isList = widget.layoutIndex == 1;
    bool isGrid = widget.layoutIndex == 2;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isGrid
            ? 5
            : widget.layoutIndex == 1
                ? 2
                : 1,
        mainAxisExtent: isList
            ? 90
            : isGrid
                ? 40
                : 100,
        crossAxisSpacing: 5,
        mainAxisSpacing: widget.layoutIndex == 2 ? 5 : 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      shrinkWrap: true,
      itemCount: filteredEpisodes.length,
      itemBuilder: (context, index) {
        final episode = filteredEpisodes[index];
        final episodeNumber = episode?['number'];
        final episodeTitle = episode?['title'] ?? 'No Title';
        final isFiller = episode?['isFiller'] ?? false;
        final isSelected = widget.currentEpisode == episodeNumber;

        if (widget.layoutIndex == 0) {
          return GestureDetector(
            onTap: () {
              widget.onEpisodeSelected(episodeNumber);
            },
            child: Opacity(
              opacity: (episodeNumber) <= widget.progress ? 0.7 : 1,
              child: Container(
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryFixedVariant
                      : Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12), 
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: (widget.episodeImages != null &&
                                    widget.episodeImages!.length > index
                                ? widget.episodeImages![episodeNumber - 1]
                                        ['image'] ??
                                    widget.coverImage
                                : widget.coverImage),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return CachedNetworkImage(
                                imageUrl: widget.coverImage,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                            errorWidget: (context, error, stackTrace) {
                              return CachedNetworkImage(
                                imageUrl: widget.coverImage,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  width: 50,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'EP ${episodeNumber?.toString() ?? index.toString()}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-Bold',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Text(
                        episodeTitle,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.inverseSurface,
                          fontFamily: 'Poppins-Bold',
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => widget.onEpisodeDownload(
                          episode['episodeId'], episodeNumber.toString()),
                      icon: Icon(Icons.download,
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (widget.layoutIndex == 1) {
          return Opacity(
            opacity: episodeNumber < widget.progress ? 0.7 : 1,
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: (widget.episodeImages != null &&
                            widget.episodeImages!.length > index
                        ? widget.episodeImages![episodeNumber - 1]['image'] ??
                            widget.coverImage
                        : widget.coverImage),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 10, right: 5),
                    decoration: BoxDecoration(
                      color: isFiller
                          ? Colors.lightGreen.shade700.withOpacity(0.8)
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainer
                              .withOpacity(0.6),
                    ),
                    child: Text(
                      episodeTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins-SemiBold'),
                    ),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 20,
                      child: Text(episodeNumber.toString(),
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 24,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.8)))),
                  Positioned(
                      bottom: 7,
                      left: 10,
                      child: InkWell(
                          onTap: () => widget.onEpisodeDownload(
                              episode['episodeId'], episodeNumber.toString()),
                          child: Icon(Icons.download,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.8))))
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            widget.onEpisodeSelected(episodeNumber);
          },
          child: Opacity(
            opacity: episodeNumber < widget.progress ? 0.7 : 1,
            child: Container(
              width: isList ? double.infinity : null,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryFixedVariant
                    : isFiller
                        ? Colors.lightGreen.shade700
                        : Theme.of(context).colorScheme.surfaceContainer,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: isList ? 8.0 : 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isSelected
                        ? const Icon(Icons.play_arrow_rounded,
                            color: Colors.white)
                        : Center(
                            child: Text(
                              isList
                                  ? '$episodeNumber.'
                                  : episodeNumber.toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    if (isList) const SizedBox(width: 5),
                    if (isList)
                      Expanded(
                        child: Text(
                          episodeTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}