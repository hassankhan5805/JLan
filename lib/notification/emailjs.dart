import 'dart:convert';
import 'package:http/http.dart' as http;

Future send(String name,String email) async {
  final servicesID = "hassankhan5805";
  final templateID = "template_dc3zwuo";
  final userID = "UXr24732yyTTHmHY9";
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http
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
              'user_subject': "subject ",
              'user_message': "your message",
            }
          }))
      .then((value) => print(value.body));
}
