import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:students/models/notifications.dart';
import 'package:students/models/reservations.dart';
import '../../models/users.dart';

class NotificationApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  // GET NOTIFICATIONS
  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('student_notifications');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          notificationModel.update(data: data.values.toList().where((s) => s["payload"]["borrower"] != null && s["payload"]["borrower"]["email"] == usersModel.loggedUser.value["email"]).toList());
        } else if (data is List) {
          notificationModel.update(data: data);
        }
      } else {
        notificationModel.update(data: []);
      }
    });
  }

  // SHOW NOTIFICATION
  Future showed({required String id})async{
    DatabaseReference usersRef = database.ref('student_notifications');
    FirebaseDatabase.instance.ref().child('student_notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_showed": "1",
      });
    });
  }

  // SEEN NOTIFICATION
  Future seen({required String id})async{
    DatabaseReference usersRef = database.ref('student_notifications');
    FirebaseDatabase.instance.ref().child('student_notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_read": "1",
      });
    });
  }

  // FOR ADMIN
  Future add({required String type, required String content})async{
    DatabaseReference usersRef = database.ref('admin_notifications');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "sender": {
        "name": usersModel.valueLogged["name"],
        "age": usersModel.valueLogged["age"],
        "email": usersModel.valueLogged["email"],
        "school_id": usersModel.valueLogged["school_id"],
        "department": usersModel.valueLogged["department"],
        "year": usersModel.valueLogged["year"],
        "section": usersModel.valueLogged["section"],
      },
      "receiver": "admin",
      "type": "$type",
      "content": "$content",
      "is_read": "0",
      "is_showed": "0",
      "created_at": "${DateTime.now()}"
    });
  }
}