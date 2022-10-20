import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  // uzerinde calisilan widgeti SliverToBoxAdapter widgetine sarar ve dondurur
  // SliverToBoxAdapter widgetini gormek icin: https://api.flutter.dev/flutter/widgets/SliverToBoxAdapter-class.html
  Widget get toSliver {
    return SliverToBoxAdapter(child: this);
  }
}