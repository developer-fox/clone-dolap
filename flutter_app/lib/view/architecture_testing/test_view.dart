
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/state/base_state.dart';
import '../../core/base/view/base_view.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/init/navigation/navigation_service.dart';

class Example {
  String content;
  Example({
    required this.content,
  });
}


class TestView extends StatefulWidget {

  Example string_content;
  TestView({
    Key? key,
    required this.string_content,
  }) : super(key: key);
  
  @override
  State<TestView> createState() => TestViewState();
}

class TestViewState extends BaseState<TestView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: (){},
      onModelDispose: (){},
      onPageBuilder: (context) {
        return  Scaffold(
          body: Center(
            child: Column(
              children: [
                const Text("test view"),
                Text(widget.string_content.content),
                ElevatedButton(
                  child: const Text("navigate to main view"),
                  onPressed: (){
                    NavigationService.instance.navigateToPage(path: NavigationConstants.TEST_MAIN_VIEW,);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class VM extends Cubit<int>{
  VM(): super(0);
}

