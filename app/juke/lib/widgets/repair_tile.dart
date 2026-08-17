import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/models/track_info.dart';
import 'package:juke/widgets/custom_button.dart';

class RepairTile extends StatefulWidget {
  final TrackInfo? track;

  const RepairTile({super.key, this.track});

  @override
  State<RepairTile> createState() => _RepairTileState();
}

class _RepairTileState extends State<RepairTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: onSecondaryColor,
      collapsedBackgroundColor: onSecondaryColor,
      shape: Border.all(color: secondaryColor, width: 1.0),
      collapsedShape: Border.all(color: secondaryColor, width: 1.0),
      title: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              widget.track?.releaseYear?.toString() ?? 'N/A',
              style: TextStyle(
                fontFamily: jetBrainsMonoFamily,
                color: primaryColor,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.track?.title ?? 'N/A',
                  style: TextStyle(
                    fontFamily: jetBrainsMonoFamily,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.track?.primaryArtist ?? 'N/A',
                  style: TextStyle(
                    fontFamily: jetBrainsMonoFamily,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      children: [
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
                  onPress: () {},
                ),
              ),
              Expanded(
                child: CustomButton(
                  type: ButtonType.primary,
                  size: ButtonSize.small,
                  text: 'mark as corrected',
                  onPress: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
