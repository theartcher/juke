import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
import 'package:juke/widgets/custom_button.dart';
import 'package:juke/widgets/custom_input.dart';

class RepairTile extends StatefulWidget {
  final TrackInfo track;
  final VoidCallback onDelete;
  final ValueChanged<TrackInfo> onTrackUpdated;
  final VoidCallback onMark;

  const RepairTile({
    super.key,
    required this.track,
    required this.onDelete,
    required this.onTrackUpdated,
    required this.onMark,
  });

  @override
  State<RepairTile> createState() => _RepairTileState();
}

class _RepairTileState extends State<RepairTile> {
  late final TextEditingController releaseYearController;
  late final TextEditingController titleController;
  late final TextEditingController primaryArtistController;
  late final TextEditingController secondaryArtistsController;

  @override
  void initState() {
    super.initState();
    releaseYearController = TextEditingController(
      text: widget.track.releaseYear?.toString() ?? '',
    );
    titleController = TextEditingController(text: widget.track.title);
    primaryArtistController = TextEditingController(
      text: widget.track.primaryArtist,
    );
    secondaryArtistsController = TextEditingController(
      text: widget.track.secondaryArtists.join(', '),
    );
  }

  void _saveEditedTrack() {
    final parsedYear = int.tryParse(releaseYearController.text.trim());

    final updatedTrack = widget.track.copyWith(
      title: titleController.text.trim(),
      primaryArtist: primaryArtistController.text.trim(),
      secondaryArtists: secondaryArtistsController.text
          .split(',')
          .map((artist) => artist.trim())
          .where((artist) => artist.isNotEmpty)
          .toList(),
      releaseYear: parsedYear,
    );

    widget.onTrackUpdated(updatedTrack);
  }

  @override
  void dispose() {
    releaseYearController.dispose();
    titleController.dispose();
    primaryArtistController.dispose();
    secondaryArtistsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: onSecondaryColor,
      collapsedBackgroundColor: onSecondaryColor,
      shape: Border.all(color: secondaryColor, width: 2.0),
      collapsedShape: Border.all(color: secondaryColor, width: 2.0),
      title: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              widget.track.releaseYear.toString(),
              style: TextStyle(
                fontFamily: jetBrainsMonoFamily,
                color: primaryColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.track.title,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: jetBrainsMonoFamily,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.track.primaryArtist,
                          style: TextStyle(
                            fontFamily: jetBrainsMonoFamily,
                            color: secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                        if (widget.track.secondaryArtists.isNotEmpty)
                          TextSpan(
                            text:
                                ' (feat. ${widget.track.secondaryArtists.join(', ')})',
                            style: TextStyle(
                              fontFamily: jetBrainsMonoFamily,
                              color: secondaryColor,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            child: Column(
              spacing: 16.0,
              children: [
                CustomFormField(
                  controller: releaseYearController,
                  labelText: 'Release year',
                  onChanged: (_) => _saveEditedTrack(),
                ),
                CustomFormField(
                  controller: titleController,
                  labelText: 'Title',
                  onChanged: (_) => _saveEditedTrack(),
                ),
                CustomFormField(
                  controller: primaryArtistController,
                  labelText: 'Primary Artist',
                  onChanged: (_) => _saveEditedTrack(),
                ),
                CustomFormField(
                  controller: secondaryArtistsController,
                  labelText: 'Secondary Artists (if applicable)',
                  onChanged: (_) => _saveEditedTrack(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.destructive,
                  size: ButtonSize.small,
                  text: 'delete card',
                  onPress: () {
                    widget.onDelete();
                  },
                ),
              ),
              Expanded(
                child: CustomButton(
                  type: ButtonType.primary,
                  size: ButtonSize.small,
                  text: 'mark as correct',
                  onPress: () {
                    _saveEditedTrack();
                    widget.onMark();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
