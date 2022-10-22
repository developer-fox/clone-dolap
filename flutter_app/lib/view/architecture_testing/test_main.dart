
import 'test_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/base/state/base_state.dart';
import '../../core/base/view/base_view.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/init/navigation/navigation_service.dart';
class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends BaseState<MainView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: VM(),
      onPageBuilder: (context) {
        return  Scaffold(
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                  child: const Text("navigate to test_view"),
                  onPressed: () async{
                    NavigationService.instance.navigateToPage(path: NavigationConstants.TEST_VIEW, data: Example(content: "second try"));
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

