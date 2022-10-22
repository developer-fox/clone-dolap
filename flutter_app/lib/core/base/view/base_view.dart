
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// bu sinif widget ust sinifidir. bu sinif sayesinde urettigimiz tum viewleri tek bir yerden yonetebilecegiz.
class BaseView<T extends Cubit?> extends StatefulWidget {

  // viewmodel(cubit) sinifindan bir nesne
  final T? viewModel;

  // initstate icerisinde calismasini istedigimiz method
  final void Function(BuildContext context)? onModelReady;

  // dispose icerisinde calismasini istedigimiz method
  final void Function(BuildContext context)? onModelDispose;

  final void Function(BuildContext context)? onModelDeactivate;

  // build methodu icerisinde render edilmesini istedigimiz widget
  final Widget Function(BuildContext context) onPageBuilder;

  const BaseView({
    Key? key,
    this.viewModel,
    this.onModelReady,
    this.onModelDispose,
    this.onModelDeactivate,
    required this.onPageBuilder, 
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Cubit?> extends State<BaseView<T>> {

  @override
  void initState() {
    if(widget.onModelReady != null) widget.onModelReady!(context);
    super.initState();
  }

  @override
  void dispose() {
    if(widget.onModelDispose != null) widget.onModelDispose!(context);
    super.dispose();
  }

  @override
  void deactivate() {
    if(widget.onModelDeactivate != null) widget.onModelDeactivate!(context);
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
   return widget.onPageBuilder(context); 
  }
}



