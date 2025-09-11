import 'package:flutter/material.dart';

class IsDetailView {
  bool value = false;
  ScrollController? scrollController;
  IsDetailView({
    required this.value,
    this.scrollController,
  });
}

class IsSharePost {
  bool value = false;
  IsSharePost({
    required this.value,
  });
}
