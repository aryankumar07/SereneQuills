// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentM{
  final String id;
  final String text;
  final DateTime creationTime;
  final String postId;
  final String username;
  final String profilepic;

  CommentM({
    required this.id, 
    required this.text, 
    required this.creationTime, 
    required this.postId, 
    required this.username, 
    required this.profilepic});

  
  CommentM copyWith({
    String? id,
    String? text,
    DateTime? creationTime,
    String? postId,
    String? username,
    String? profilepic,
  }) {
    return CommentM(
      id: id ?? this.id,
      text: text ?? this.text,
      creationTime: creationTime ?? this.creationTime,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilepic: profilepic ?? this.profilepic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'creationTime': creationTime.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilepic': profilepic,
    };
  }

  factory CommentM.fromMap(Map<String, dynamic> map) {
    return CommentM(
      id: map['id'] as String,
      text: map['text'] as String,
      creationTime: DateTime.fromMillisecondsSinceEpoch(map['creationTime']),
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilepic: map['profilepic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentM.fromJson(String source) => CommentM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, creationTime: $creationTime, postId: $postId, username: $username, profilepic: $profilepic)';
  }

  @override
  bool operator ==(covariant CommentM other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.text == text &&
      other.creationTime == creationTime &&
      other.postId == postId &&
      other.username == username &&
      other.profilepic == profilepic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      text.hashCode ^
      creationTime.hashCode ^
      postId.hashCode ^
      username.hashCode ^
      profilepic.hashCode;
  }
}
