import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NetworkCenterEntity extends Equatable {
  final String imagePath;
  final String title;
  final Function(BuildContext context) navCallBack;

  const NetworkCenterEntity({
    required this.imagePath,
    required this.title,
    required this.navCallBack,
  });

  @override
  List<Object?> get props => [
        imagePath,
        title,
        navCallBack,
      ];
}
