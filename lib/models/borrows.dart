import 'package:rxdart/rxdart.dart';

class BorrowsModel{
  List checkers = [];

  final BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get current => subject.value;

  update({required List data}){
    subject.add(data);
  }
}
final BorrowsModel borrowsModel = new BorrowsModel();