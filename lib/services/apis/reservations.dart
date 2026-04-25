import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:students/models/reservations.dart';
import '../../models/users.dart';

class ReservationApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // ADD BOOK RESERVATION
  Future add({required Map details, required DateTime start, required DateTime end})async{
    DatabaseReference usersRef = database.ref('reservations');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "borrower": {
        "name": usersModel.valueLogged["name"],
        "age": usersModel.valueLogged["age"],
        "email": usersModel.valueLogged["email"],
        "school_id": usersModel.valueLogged["school_id"],
        "department": usersModel.valueLogged["department"],
        "year": usersModel.valueLogged["year"],
        "section": usersModel.valueLogged["section"],
      },
      "book_information": jsonEncode(details),
      "borrow_details": {
        "borrow_date": "$start",
        "end_date": "$end",
      },
      "status": "Pending",
      "created_at": "${DateTime.now()}"
    });
  }

  // GET SERVERVATIONS
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('reservations');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          reservationsModel.update(data: data.values.toList());
          print("RESERVATIONS ${data.values.toList()}");
        } else if (data is List) {
          reservationsModel.update(data: data);
        }
      } else {
        reservationsModel.update(data: []);
      }
    });
  }
}