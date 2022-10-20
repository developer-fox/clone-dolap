
import 'package:flutter/material.dart';
import 'INavigationService.dart';

//? NavigationService.instance.<method_name> 
class NavigationService implements INavigationService {
  static NavigationService? _instance = NavigationService._init();
  static NavigationService get instance {
    _instance ??= NavigationService._init();
    return _instance!;
  }

  NavigationService._init();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  
  // bu method ile baska bir sayfaya gidilir.
  //? verisiz gecis: NavigationService.instance.navigateToPage(path: NavigationConstants.<enum>);
  //? veri ile gecis: NavigationService.instance.navigateToPage(path: NavigationConstants.<enum>, data: <object data>);
  @override
  Future<void> navigateToPage({String? path, Object? data}) async{
    path ??= "";
    await navigatorKey.currentState?.pushNamed(path, arguments: data);
  }
  
  // bu method ile baska bir sayfaya gidilir ve mevcut sayfa backstack icerisinden cikarilir.
  @override
  Future<void> navigateToPageClear({String? path, Object? data}) async{
    path ??= "";
    await navigatorKey.currentState?.pushNamedAndRemoveUntil(path, arguments: data,(route) => false);
  }
}