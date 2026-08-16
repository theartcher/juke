import 'package:flutter/material.dart';
import 'package:juke/models/track_info.dart';

class RepairTile extends StatefulWidget {
  final TrackInfo? track;

  const RepairTile({super.key, this.track});

  @override
  State<RepairTile> createState() => _RepairTileState();
}

class _RepairTileState extends State<RepairTile> {
  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      title: Text('ExpansionTile 1'),
      subtitle: Text('Trailing expansion arrow icon'),
      children: <Widget>[ListTile(title: Text('This is tile number 1'))],
    );
  }
}
