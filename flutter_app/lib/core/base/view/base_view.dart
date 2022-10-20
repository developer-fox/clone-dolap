
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// bu sinif widget ust sinifidir. bu sinif sayesinde urettigimiz tum viewleri tek bir yerden yonetebilecegiz.
class BaseView<T extends Cubit?> extends StatefulWidget {

  //  viewmodel(cubit) sinifindan bir nesne
  final T? viewModel;

  // initstate icerisinde calismasini istedigimiz method
  final Function() onModelReady;

  // dispose icerisinde calismasini istedigimiz method
  final void Function() onModelDispose;

  // build methodu icerisinde render edilmesini istedigimiz widget
  final Widget Function(BuildContext context) onPageBuilder;

  const BaseView({
    Key? key,
    this.viewModel,
    required this.onModelReady,
    required this.onModelDispose,
    required this.onPageBuilder,
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState<T extends Cubit> extends State<BaseView<T>> {

  @override
  void initState() {
    widget.onModelReady();
    super.initState();
  }

  @override
  void dispose() {
    widget.onModelDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return widget.onPageBuilder(context); 
  }
}



