import 'package:flutter/material.dart';

/// To widgets like this that are used in more than one page/module
/// it is not recommended to put the viewmodel as a paramters, because
/// doing this I am binding the viewmodel with the component and restricting
/// its using to a specific page/module.
/// So, it's recommended to put just the parameters needed separeted.
final class PlayerPhoto extends StatelessWidget {

  final String initials;
  final String? photo;

  const PlayerPhoto({
    super.key,
    required this.initials,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      foregroundImage: photo != null
        ? NetworkImage(photo!)
        : null,
      child: photo == null
        ? Text(initials)
        : null,
    );
  }
}