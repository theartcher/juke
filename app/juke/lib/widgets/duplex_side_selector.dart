import 'package:flutter/material.dart';
import 'package:juke/constants.dart';
import 'package:juke/utility/pdf_utils.dart';

class DuplexSideSelector extends StatefulWidget {
  final DuplexFlip selectedFlipSide;
  final Function(DuplexFlip) onChanged;

  const DuplexSideSelector({
    super.key,
    required this.selectedFlipSide,
    required this.onChanged,
  });

  @override
  State<DuplexSideSelector> createState() => _DuplexSideSelectorState();
}

class _DuplexSideSelectorState extends State<DuplexSideSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Which way does the paper flip in your printer?",
          style: TextStyle(
            fontFamily: jetBrainsMonoFamily,
            fontSize: subHeaderTextSize,
          ),
        ),
        RadioGroup<DuplexFlip>(
          groupValue: widget.selectedFlipSide,
          onChanged: (DuplexFlip? value) {
            widget.onChanged.call(value!);
          },
          child: Row(
            spacing: 16.0,
            children: <Widget>[
              Expanded(child: getRadioTile(DuplexFlip.longEdge, 'long')),
              Expanded(child: getRadioTile(DuplexFlip.shortEdge, 'short')),
            ],
          ),
        ),
      ],
    );
  }

  //todo add side indicator, make it blink with the value

  Widget getRadioTile(DuplexFlip value, String title) {
    return Column(
      children: [
        Text(title),
        AspectRatio(
          aspectRatio: 210 / 297,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(width: 2.0)),
          ),
        ),
      ],
    );
  }
}
