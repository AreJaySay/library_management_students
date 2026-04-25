import 'package:rxdart/rxdart.dart';

class NotificationModel{
  final BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get current => subject.value;

  update({required List data}){
    subject.add(data);
  }

  // CONTROLLER
  final BehaviorSubject<bool> controller = new BehaviorSubject();
  Stream get streamController => controller.stream;
  bool get currentController => controller.value;

  updateController({required bool data}){
    controller.add(data);
  }
}
final NotificationModel notificationModel = new NotificationModel();