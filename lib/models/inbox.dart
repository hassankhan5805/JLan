import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  final String? chatID;
  final String? lastMessage;
  final Timestamp? createdAt;
  final List<String>? usersID;
  final List<String>? usersName;
  final List<String>? usersPicture;
  final int unreadMessageCountRciever;
  final int unreadMessageCountSender;

  InboxModel(
      {this.chatID,
      this.createdAt,
      this.usersPicture,
      this.usersName,
      this.usersID,
      this.lastMessage,
      this.unreadMessageCountRciever = 0,
      this.unreadMessageCountSender = 0});

  InboxModel.fromMap(Map<String, dynamic>? map)
      : this(
          chatID: map!['chatID'],
          usersPicture: map['usersPicture'].cast<String>()??null,
          usersName: map['usersName'].cast<String>()??null,
          usersID: map['usersID'].cast<String>()??null,
          lastMessage: map['lastMessage'],
          unreadMessageCountSender: map['unreadMessageCountSender'],
          unreadMessageCountRciever: map['unreadMessageCountRciever'],
          createdAt: map['createdAt'],
        );

  Map<String, dynamic> toMap() => {
        'chatID': chatID,
        'usersPicture': usersPicture,
        'usersName': usersName,
        'usersID': usersID,
        'lastMessage': lastMessage,
        'unreadMessageCountSender': unreadMessageCountSender,
        'unreadMessageCountRciever': unreadMessageCountRciever,
        'createdAt': createdAt,
      };
}
