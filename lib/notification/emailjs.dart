import 'dart:convert';
import 'package:http/http.dart' as http;

Future send(String name,String email) async {
  final servicesID = "tonynotifier";
  final templateID = "template1";
  final userID = "yIBXOHMGh1ACRMpl-";
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
   await http
      .post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': servicesID,
            'template_id': templateID,
            'user_id': userID,
            // 'accessToken': "4gez68Vuwd1f_tlax-j5c",
            'template_params': {
              'user_name': name,
              'user_email': email,
              'user_subject': "",
              'message': "User Name : $name\nUser Email : $email",
            }
          }))
      .then((value) => print(value.body));
}
