import 'package:flutter/widgets.dart';

class MountedState<T extends StatefulWidget> extends State<T> {

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}