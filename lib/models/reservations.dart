import 'package:rxdart/rxdart.dart';

class ReservationsModel{
  final BehaviorSubject<List> reservation = new BehaviorSubject();
  Stream get stream => reservation.stream;
  List get current => reservation.value;

  update({required List data}){
    reservation.add(data);
  }
}
final ReservationsModel reservationsModel = new ReservationsModel();