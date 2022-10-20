
import 'package:clone_dolap/core/base/model/base_model.dart';

import 'test_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/state/base_state.dart';
import '../../core/base/view/base_view.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/init/navigation/navigation_service.dart';
import '../../core/init/network/network_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends BaseState<MainView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: (){},
      onModelDispose: (){},
      viewModel: VM(),
      onPageBuilder: (context) {
        return  Scaffold(
          body: Center(
            child: Column(
              children: [
                ElevatedButton(
                  child: const Text("navigate to test_view"),
                  onPressed: () async{
                      await NetworkManagement.instance.getRequest<S>(path:"/public/notice_details/632f777bf5d9dc71dd1a431a");
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


class S extends BaseModel<S>{
  @override
  Map<String, Object> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
  @override
  fromJson(Map<String, Object> jsonData) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

}


class VM extends Cubit<int>{
  VM(): super(0);
}

